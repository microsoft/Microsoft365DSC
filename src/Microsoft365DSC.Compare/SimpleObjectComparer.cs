using Microsoft.Management.Infrastructure;
using Microsoft365DSC.Converter;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Reflection;

namespace Microsoft365DSC.Compare
{
    public static class SimpleObjectComparer
    {
        public static Dictionary<string, object> Compare(
            Hashtable currentValues,
            object desiredValues,
            ICollection valuesToCheck,
            Hashtable? includedDrifts = null,
            bool noEventMessage = false,
            bool noDriftReset = false,
            List<string>? excludedProperties = null)
        {
            // Contains the strings to write to the event log
            Hashtable driftedParameters = [];
            // Contains the drift
            Hashtable driftObject = new()
            {
                { "DriftInfo", new List<Hashtable>() },
                { "CurrentValues", new Hashtable() },
                { "DesiredValues", new Hashtable() }
            };

            // The final return value for the method
            bool returnValue = true;

            if (includedDrifts is not null && includedDrifts.Keys.Count > 0)
            {
                driftedParameters = includedDrifts;
                foreach (DictionaryEntry existingDrift in includedDrifts)
                {
                    string propertyName = (string)existingDrift.Key;
                    string value = (string)existingDrift.Value;
                    int startIndex = value.IndexOf("</CurrentValue>");
                    string currentValue = value.Substring(0, startIndex)
                        .Replace("<CurrentValue>", "");
                    string desiredValue = value.Substring(startIndex + 15, value.Length - (startIndex + 15))
                        .Replace("<DesiredValue>", "")
                        .Replace("</DesiredValue>", "");

                    AddDriftInfo(driftObject, propertyName, currentValue, desiredValue);
                }
            }

            // Match for Hashtable, CimInstance and PSBoundParametersDictionary, which inherits from Dictionary<string, object>
            if (desiredValues is not Hashtable and not CimInstance and not Dictionary<string, object>)
            {
                throw new ArgumentException($"Property 'DesiredValues' must be either a Hashtable or CimInstance. Type detected was {desiredValues.GetType().FullName}");
            }

            if (desiredValues is CimInstance && valuesToCheck is null)
            {
                throw new ArgumentException("If 'DesiredValues' is a CimInstance, then property 'ValuesToCheck' must contain a value");
            }

            List<string> keyList = valuesToCheck.Cast<string>().ToList();
            Hashtable desiredValuesHashtable = ComplexObjectConverter.ToHashtable(desiredValues);

            // Add default Ensure value if it is not present in the DesiredValues but present in the CurrentValues
            if (!keyList.Contains("Ensure") && !keyList.Contains("IsSingleInstance") && currentValues.ContainsKey("Ensure"))
            {
                keyList.Add("Ensure");
                if (desiredValuesHashtable is not null && !desiredValuesHashtable.ContainsKey("Ensure"))
                {
                    desiredValuesHashtable.Add("Ensure", "Present");
                }
            }

            List<string> propertiesToExclude = ["Verbose", "Credential", "ApplicationId", "CertificateThumbprint", "CertificatePath", "CertificatePassword", "TenantId", "ApplicationSecret", "ManagedIdentity", "AccessTokens"];
            if (excludedProperties is not null)
            {
                propertiesToExclude.AddRange(excludedProperties);
                propertiesToExclude = propertiesToExclude.Distinct().ToList();
            }

            foreach (string key in keyList)
            {
                if (propertiesToExclude.Contains(key))
                {
                    continue;
                }

                if (desiredValuesHashtable[key] is null && currentValues.ContainsKey(key) && currentValues[key] is null)
                {
                    // Do nothing - Both are null
                    continue;
                }

                if (!currentValues.ContainsKey(key) ||
                    !(currentValues[key]?.ToString().Equals(desiredValuesHashtable[key]?.ToString(), StringComparison.OrdinalIgnoreCase) ?? false) ||
                        (desiredValuesHashtable.ContainsKey(key) &&
                            desiredValuesHashtable[key] is not null && desiredValuesHashtable[key] is Array))
                {
                    if (desiredValuesHashtable.ContainsKey(key))
                    {
                        object? desiredValue = desiredValuesHashtable[key];
                        Type desiredType;
                        if (desiredValue is null)
                        {
                            desiredType = currentValues[key]?.GetType() ?? typeof(object);
                        }
                        else
                        {
                            desiredType = desiredValue.GetType();
                        }

                        if (desiredType.IsArray)
                        {
                            if (!currentValues.ContainsKey(key) || currentValues[key] is null)
                            {
                                AddDriftInfo(driftObject, key, null, desiredValue);
                                AddDriftedParameter(driftedParameters, key, "null", "[Array]");
                                returnValue = false;
                                continue;
                            }

                            if (desiredType.Name.Equals("CimInstance[]"))
                            {
                                // Do nothing because it's already handled previously through Compare-M365DSCComplexObject -> ComplexObjectComparer
                                // Complex properties are removed and thus not handled by this function
                                // However, since we might miss something during developing, throw an error
                                throw new NotSupportedException($"Comparing CimInstances with {typeof(SimpleObjectComparer).Name} is not supported.");
                            }

                            Array desiredValuesArray = desiredValue is null
                                ? Array.CreateInstance(desiredType, 0)
                                : (Array)desiredValue;
                            Array currentValuesArray = EnsureArray(currentValues[key], desiredType.GetElementType());
                            var arrayDifferences = ArrayComparer.CompareArrays(currentValuesArray, desiredValuesArray);
                            if (arrayDifferences.Count > 0)
                            {
                                string currentValuesString = string.Join(", ", Utilities.Utilities.UnwrapArrayToStrings(currentValuesArray));
                                string desiredValuesString = string.Join(", ", Utilities.Utilities.UnwrapArrayToStrings(desiredValuesArray));
                                string deltaString = string.Join("; ", arrayDifferences.Select(d => $"{d.SideIndicator} {d.InputObject}"));
                                AddDriftInfoWithDelta(driftObject, key, currentValuesString, desiredValuesString, deltaString);
                                AddDriftedParameterWithDelta(driftedParameters, key, currentValuesString, desiredValuesString, deltaString);
                                returnValue = false;
                            }
                            continue;
                        }

                        switch (desiredValue)
                        {
                            case null:
                                AddDriftInfo(driftObject, key, currentValues[key] as string ?? string.Empty, "$null");
                                AddDriftedParameter(driftedParameters, key, currentValues[key] as string ?? string.Empty, "$null");
                                returnValue = false;
                                break;

                            case string desiredValueString:
                                string currentValueString = currentValues[key] as string;
                                if (!string.IsNullOrEmpty(currentValueString))
                                {
                                    currentValueString = ReplaceLineBreaks(currentValueString);
                                }
                                desiredValueString = ReplaceLineBreaks(desiredValueString);

                                if (string.IsNullOrEmpty(currentValueString) && string.IsNullOrEmpty(desiredValueString))
                                {
                                    // Do nothing - Strings are equally empty
                                    continue;
                                }

                                if (!string.IsNullOrEmpty(currentValueString) && !string.IsNullOrEmpty(desiredValueString)
                                    && string.Equals(desiredValueString, currentValueString, StringComparison.OrdinalIgnoreCase))
                                {
                                    // Do nothing - Strings are the same
                                    continue;
                                }

                                AddDriftInfo(driftObject, key, currentValueString, desiredValueString);
                                AddDriftedParameter(driftedParameters, key, currentValueString, desiredValueString);
                                returnValue = false;
                                break;

                            default:
                                // Handle all value types (numeric types and bool)
                                if (!desiredValue.GetType().IsValueType)
                                {
                                    throw new NotSupportedException($"Comparing {desiredType.FullName} with {typeof(SimpleObjectComparer).Name} is not supported.");
                                }

                                AddDriftInfo(driftObject, key, currentValues[key]?.ToString() ?? string.Empty, desiredValue.ToString());
                                AddDriftedParameter(driftedParameters, key, currentValues[key]?.ToString() ?? string.Empty, desiredValue.ToString());
                                returnValue = false;
                                break;
                        }
                    }
                }
            }

            return new()
            {
                { "TestResult", returnValue },
                { "DriftObject", driftObject },
                { "DriftedParameters", driftedParameters }
            };
        }

        private static Array EnsureArray(object value, Type? elementType = null)
        {
            if (value is null)
            {
                elementType = elementType ?? typeof(object);
                return Array.CreateInstance(elementType, 0);
            }

            if (value is PSObject psObject)
                value = psObject.BaseObject;

            if (value is Array array)
            {
                return array;
            }

            if (value is IList list)
            {
                Type[] genericArguments = list.GetType().GetGenericArguments();
                if (genericArguments.Length == 0)
                {
                    elementType = elementType ?? typeof(object);
                }
                else
                {
                    elementType = genericArguments[0];
                }

                Array newArray = Array.CreateInstance(elementType, list.Count);
                list.CopyTo(newArray, 0);
                return newArray;
            }

            // Single value (ValueType or String) - create array with that value
            elementType = elementType ?? value.GetType();
            Array result = Array.CreateInstance(elementType, 1);
            result.SetValue(value, 0);
            return result;
        }

        private static void AddDriftInfo(Hashtable driftObject, string propertyName, object currentValue, object desiredValue)
        {
            ((List<Hashtable>)driftObject["DriftInfo"]).Add(new Hashtable()
            {
                { "PropertyName", propertyName },
                { "CurrentValue", currentValue },
                { "DesiredValue", desiredValue }
            });
        }

        private static void AddDriftInfoWithDelta(Hashtable driftObject, string propertyName, object currentValue, object desiredValue, string delta)
        {
            ((List<Hashtable>)driftObject["DriftInfo"]).Add(new Hashtable()
            {
                { "PropertyName", propertyName },
                { "CurrentValue", currentValue },
                { "DesiredValue", desiredValue },
                { "DeltaValue", delta }
            });
        }

        private static void AddDriftedParameter(Hashtable driftedParameters, string propertyName, string currentValue, string desiredValue)
        {
            string eventValue = $"<CurrentValue>{currentValue}</CurrentValue>";
            eventValue += $"<DesiredValue>{desiredValue}</DesiredValue>";
            driftedParameters.Add(propertyName, eventValue);
        }

        private static void AddDriftedParameterWithDelta(Hashtable driftedParameters, string propertyName, string currentValue, string desiredValue, string deltaValue)
        {
            string eventValue = $"<CurrentValue>{currentValue}</CurrentValue>";
            eventValue += $"<DesiredValue>{desiredValue}</DesiredValue>";
            eventValue += $"<DeltaValue>{deltaValue}</DeltaValue>";
            driftedParameters.Add(propertyName, eventValue);
        }

        private static string ReplaceLineBreaks(string text)
        {
            return text.Replace("\r\n", "\n");
        }
    }
}
