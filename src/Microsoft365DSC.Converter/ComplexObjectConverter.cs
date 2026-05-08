using Microsoft.Management.Infrastructure;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Reflection;
using System.Text;

namespace Microsoft365DSC.Converter
{
    /// <summary>
    /// Provides optimized CIM instance to hashtable conversion with cached reflection.
    /// Replaces repeated reflection-based property access with cached PropertyInfo lookups.
    /// </summary>
    public static class ComplexObjectConverter
    {
        private static readonly Dictionary<string, PropertyInfo[]> _propertyCache =
            new(StringComparer.OrdinalIgnoreCase);
        private static readonly object _cacheLock = new();

        /// <summary>
        /// Converts a CIM instance or object to a hashtable with cached property reflection.
        /// </summary>
        /// <param name="complexObject">Complex object instance to convert</param>
        /// <returns>Hashtable representation of the object</returns>
        public static Hashtable? ToHashtable(object complexObject)
        {
            if (complexObject is null)
                return null;

            if (complexObject is PSObject psObject && psObject.BaseObject is not null)
                complexObject = psObject.BaseObject;

            if (complexObject is PSObject psObject2)
            {
                var result = new Hashtable(StringComparer.OrdinalIgnoreCase);
                foreach (PSPropertyInfo prop in psObject2.Properties)
                {
                    // Skip computed properties; only take NoteProperty and Property
                    if (prop.MemberType != PSMemberTypes.NoteProperty &&
                        prop.MemberType != PSMemberTypes.Property)
                        continue;

                    try
                    {
                        result[prop.Name] = ToHashtable(prop.Value);
                    }
                    catch
                    {
                        // Some properties may throw on access (ParameterizedProperty etc.)
                        // Skip them silently
                    }
                }
                return result;
            }

            if (complexObject is Hashtable hashtable)
                return hashtable;

            if (complexObject is IDictionary dictionary)
            {
                var dictionaryResult = new Hashtable(StringComparer.OrdinalIgnoreCase);
                foreach (DictionaryEntry entry in dictionary)
                {
                    dictionaryResult[entry.Key!] = GetValueFromObject(entry.Value);
                }
                return dictionaryResult;
            }

            if (complexObject is CimInstance cimInstance)
            {
                var cimResult = new Hashtable(StringComparer.OrdinalIgnoreCase);
                foreach (var property in cimInstance.CimInstanceProperties)
                {
                    if (property.Name.Equals("PSComputerName", StringComparison.OrdinalIgnoreCase) || !property.IsValueModified)
                        continue;

                    cimResult[property.Name] = GetValueFromObject(property.Value);
                }
                return cimResult;
            }
            else if (complexObject.GetType().FullName.Contains("Microsoft.Graph."))
            {
                return GetValueFromGraphObject(complexObject);
            }

            return new(StringComparer.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Converts an array of complex objects to an array of hashtables.
        /// </summary>
        /// <param name="complexObjects">Array of complex objects to convert</param>
        /// <returns>Array of hashtables representing the complex objects</returns>
        public static Array ToHashtableArray(Array complexObjects)
        {
            var result = new Hashtable?[complexObjects.Length];
            for (int i = 0; i < complexObjects.Length; i++)
            {
                var item = complexObjects.GetValue(i);
                result[i] = ToHashtable(item!);
            }
            return result;
        }

        /// <summary>
        /// Converts an array, handling nested CIM instances and complex objects.
        /// </summary>
        /// <param name="source">The source array to convert.</param>
        /// <returns>A new array with the converted values.</returns>
        private static Array ConvertArray(Array source)
        {
            var result = new object?[source.Length];

            for (int i = 0; i < source.Length; i++)
            {
                var item = source.GetValue(i);

                if (item is null)
                    result[i] = null;
                else if (item is Array nestedArray)
                    result[i] = ConvertArray(nestedArray);
                else if (item is Hashtable)
                    result[i] = item;
                else if (IsCimLikeObject(item))
                    result[i] = ToHashtable(item);
                else
                    result[i] = item;
            }

            return result;
        }

        /// <summary>
        /// Determines if an object is a CIM-like complex object (not a primitive or common .NET type).
        /// </summary>
        /// <param name="obj">The object to check.</param>
        /// <returns>True if the object is CIM-like, false otherwise.</returns>
        private static bool IsCimLikeObject(object obj)
        {
            if (obj is null)
            {
                return false;
            }

            var type = obj.GetType();
            var typeName = type.FullName ?? string.Empty;

            // Check for CIM instance types
            // Because .Contains with a StringComparison is not available, we use IndexOf
            if (typeName.IndexOf("CimInstance", StringComparison.OrdinalIgnoreCase) > -1)
            {
                return true;
            }

            // Check for Microsoft Graph model types
            if (typeName.StartsWith("Microsoft.Graph.", StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }

            // Exclude primitive types and common .NET types
            if (type.IsPrimitive || type == typeof(string) || type == typeof(DateTime) ||
                type == typeof(decimal) || type == typeof(Guid))
            {
                return false;
            }

            // Check if it's a complex object with properties
            var properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            return properties.Length > 0;
        }

        /// <summary>
        /// Gets a value from an object, handling various types.
        /// </summary>
        /// <param name="value">The object to get the value from.</param>
        /// <returns>The extracted value.</returns>
        private static object? GetValueFromObject(object? value)
        {
            if (value is PSObject psObject)
                value = psObject.BaseObject;

            if (value is null)
            {
                return null;
            }
            else if (value is Array array)
            {
                return ConvertArray(array);
            }
            else if (value is Hashtable hashValue)
            {
                return hashValue;
            }
            else if (IsCimLikeObject(value))
            {
                return ToHashtable(value);
            }
            else
            {
                // Primitive types
                return value;
            }
        }

        /// <summary>
        /// Creates a hashtable representation of the public and selected non-public properties of the specified complex
        /// object.
        /// </summary>
        /// <remarks>Properties named "EntityItem" are excluded from the result. Non-public properties
        /// containing "AdditionalProperties" in their name are also included. The method uses a cache to improve
        /// performance when processing objects of the same type.</remarks>
        /// <param name="complexObject">The object whose properties are to be extracted and represented in the resulting hashtable. Cannot be null.</param>
        /// <returns>A hashtable containing the names and values of the object's properties. Property names are used as keys, and
        /// their corresponding values are recursively processed. The hashtable is case-insensitive with respect to
        /// keys.</returns>
        private static Hashtable GetValueFromGraphObject(object complexObject)
        {
            var type = complexObject.GetType();
            PropertyInfo[] properties;
            lock (_cacheLock)
            {
                if (!_propertyCache.TryGetValue(type.FullName!, out properties))
                {
                    // Exclude "EntityItem" property because it is a ParameterizedProperty and is not required
                    properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                        .Where(property => !property.Name.Equals("EntityItem")).ToArray();
                    var additionalProperties = type.GetProperties(BindingFlags.NonPublic | BindingFlags.Instance)
                        .Where(property => property.Name.Contains("AdditionalProperties")).ToArray();
                    _propertyCache[type.FullName!] = properties.Concat(additionalProperties).ToArray();
                }
            }

            var graphResult = new Hashtable(StringComparer.OrdinalIgnoreCase);
            foreach (var property in properties)
            {
                var value = property.GetValue(complexObject);
                if (property.Name.Equals("Microsoft.Graph.Beta.PowerShell.Runtime.IAssociativeArray<System.Object>.AdditionalProperties"))
                {
                    graphResult["AdditionalProperties"] = GetValueFromObject(value);
                }
                else
                {
                    graphResult[property.Name] = GetValueFromObject(value);
                }
            }

            return graphResult;
        }


        /// <summary>
        /// Clears the property reflection cache (primarily for testing purposes).
        /// </summary>
        public static void ClearCache()
        {
            lock (_cacheLock)
            {
                _propertyCache.Clear();
            }
        }

        /// <summary>
        /// Converts a complex object to its DSC configuration string representation.
        /// </summary>
        /// <param name="complexObject">The complex object to convert (can be null, object, or array)</param>
        /// <param name="cimInstanceName">The name of the CIM instance type</param>
        /// <param name="complexTypeMapping">Optional mapping of complex type properties (not implemented yet)</param>
        /// <param name="whitespace">Optional whitespace for formatting</param>
        /// <param name="indentLevel">The indentation level (default is 3)</param>
        /// <param name="isArray">Indicates if the object is part of an array</param>
        /// <returns>A formatted DSC configuration string</returns>
        public static object ToDscString(
            object complexObject,
            string cimInstanceName,
            List<ComplexTypeMapping> complexTypeMapping,
            string whitespace = "",
            uint indentLevel = 3,
            bool isArray = false)
        {
            if (complexObject is null)
            {
                return string.Empty;
            }

            if (complexObject is PSObject psObject)
            {
                complexObject = psObject.BaseObject;
            }

            complexTypeMapping ??= [];

            var indent = new string(' ', (int)indentLevel * 4);

            // If ComplexObject is an Array
            if (complexObject is IEnumerable enumerable and not string and not IDictionary)
            {
                List<object> currentProperty = [];
                indentLevel++;

                foreach (var item in enumerable)
                {
                    var itemResult = ToDscString(
                        item,
                        cimInstanceName,
                        complexTypeMapping,
                        whitespace,
                        indentLevel,
                        true);

                    currentProperty.Add((string)itemResult);
                }

                // Add an indented new line after the last item in the array
                if (currentProperty.Count > 0)
                {
                    int lastIndex = currentProperty.Count - 1;
                    currentProperty[lastIndex] += $"\r\n{indent}";
                }

                return currentProperty.ToArray();
            }

            var currentPropertyBuilder = new StringBuilder();
            if (isArray)
            {
                currentPropertyBuilder.AppendLine();
                currentPropertyBuilder.Append(indent);
            }

            // Remove MSFT_ prefix if present
            cimInstanceName = cimInstanceName.Replace("MSFT_", string.Empty);
            _ = currentPropertyBuilder.Append($"MSFT_{cimInstanceName}{{");
            _ = currentPropertyBuilder.AppendLine();

            indentLevel++;
            indent = new string(' ', (int)indentLevel * 4);

            // Get keys from the object
            IEnumerable<string> keys;
            IDictionary? dict = null;
            CimInstance? cimInstance = null;

            if (complexObject is IDictionary dictionary)
            {
                dict = dictionary;
                var keyList = new List<string>();
                foreach (var key in dictionary.Keys)
                {
                    keyList.Add(key.ToString());
                }
                keys = keyList.OrderBy(k => k);
            }
            else if (complexObject is CimInstance instance)
            {
                cimInstance = instance;
                keys = cimInstance.CimInstanceProperties
                    .Where(p => p.IsValueModified && p.Name != "PSComputerName")
                    .Select(p => p.Name);
            }
            else
            {
                // Handle objects with properties
                var properties = complexObject.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);
                if (complexObject.GetType().FullName!.Contains("Microsoft.Graph."))
                {
                    properties = complexObject.GetType()
                        .GetProperties(BindingFlags.Public | BindingFlags.Instance)
                        .Where(property => !property.Name.Equals("EntityItem")).ToArray();
                }
                if (properties.Length == 0)
                {
                    return string.Empty;
                }
                keys = properties.Select(p => p.Name).OrderBy(k => k);
            }

            foreach (var key in keys)
            {
                object? value;
                if (dict is not null)
                {
                    value = dict[key];
                }
                else if (cimInstance is not null)
                {
                    value = cimInstance.CimInstanceProperties[key]?.Value;
                }
                else
                {
                    var property = complexObject.GetType().GetProperty(key);
                    value = property?.GetValue(complexObject);
                }

                if (value is not null)
                {
                    if (value is PSObject psObjectValue)
                    {
                        value = psObjectValue.BaseObject;
                    }
                    if (value is ArrayList arrayList)
                    {
                        value = arrayList.ToArray();
                    }

                    var valueType = value.GetType();
                    var valueTypeName = valueType.FullName ?? valueType.Name;

                    // Check if value is a complex type (Graph model or CIM instance)
                    if (valueTypeName.StartsWith("Microsoft.Graph.PowerShell.Models.", StringComparison.Ordinal) ||
                        complexTypeMapping.Any(ctm => ctm.Name.Equals(key, StringComparison.OrdinalIgnoreCase)))
                    {
                        // Handle complex nested types recursively
                        var itemValue = value;
                        var hashPropertyType = valueType.Name.ToLower();

                        bool isNestedArray = value is Array;

                        if (complexTypeMapping.Any(ctm => ctm.Name.Equals(key, StringComparison.OrdinalIgnoreCase)))
                        {
                            hashPropertyType = complexTypeMapping.First(ctm => ctm.Name.Equals(key, StringComparison.OrdinalIgnoreCase)).CimInstanceName;
                        }

                        if (isNestedArray && complexTypeMapping.Any(ctm => ctm.Name.Equals(key, StringComparison.OrdinalIgnoreCase)))
                        {
                            if (itemValue is Array)
                            {
                                _ = currentPropertyBuilder.Append($"{indent}{key} = @(");
                            }
                        }

                        if (isNestedArray)
                        {
                            // Handle array of complex types
                            indentLevel++;
                            var arrayItems = (Array)value;
                            for (int i = 0; i < arrayItems.Length; i++)
                            {
                                object item = arrayItems.GetValue(i);
                                var itemHash = ToHashtable(item);
                                var nestedPropertyString = (string)ToDscString(
                                    itemHash,
                                    hashPropertyType,
                                    complexTypeMapping,
                                    whitespace,
                                    indentLevel,
                                    true);

                                if (string.IsNullOrWhiteSpace(nestedPropertyString))
                                {
                                    nestedPropertyString = "@()\r\n";
                                }

                                if (i != 0)
                                {
                                    nestedPropertyString = nestedPropertyString.Substring(2);
                                }
                                _ = currentPropertyBuilder.Append(nestedPropertyString);
                                if (!currentPropertyBuilder.ToString().EndsWith("\r\n"))
                                {
                                    _ = currentPropertyBuilder.AppendLine();
                                }
                            }
                            indentLevel--;

                            _ = arrayItems.Length > 0
                                ? currentPropertyBuilder.Append($"{indent})").AppendLine()
                                : currentPropertyBuilder.Append($")").AppendLine();
                        }
                        else
                        {
                            // Get hashtable representation
                            Hashtable hashProperty = ToHashtable(itemValue)!;
                            _ = currentPropertyBuilder.Append($"{indent}{key} = ");
                            var nestedPropertyString = ToDscString(
                                hashProperty,
                                hashPropertyType,
                                complexTypeMapping,
                                whitespace,
                                indentLevel,
                                false);

                            if (string.IsNullOrWhiteSpace((string)nestedPropertyString))
                            {
                                nestedPropertyString = "$null\r\n";
                            }
                            _ = currentPropertyBuilder.Append(nestedPropertyString).AppendLine();
                        }
                    }
                    else
                    {
                        // Handle simple types using SimpleObjectConverter
                        var currentValue = value;

                        if (currentValue is not null && !currentValue.GetType().Name.Contains("Dictionary"))
                        {
                            if (currentValue is string stringValue)
                            {
                                // Replace special character (right single quotation mark)
                                stringValue = stringValue.Replace("�", "''");
                                currentValue = stringValue;
                            }
                            _ = currentPropertyBuilder.Append(SimpleObjectConverter.ToDscString(key, currentValue, indent));
                        }
                    }
                }
                else
                {
                    var mappedKey = complexTypeMapping.Where(ctm => ctm.Name.Equals(key)).FirstOrDefault();
                    if (mappedKey is not null && mappedKey.IsRequired)
                    {
                        _ = mappedKey.IsArray
                            ? currentPropertyBuilder.Append($"{indent}{key} = @()").AppendLine()
                            : currentPropertyBuilder.Append($"{indent}{key} = $null").AppendLine();
                    }
                }
            }

            indent = new string(' ', (int)(indentLevel - 1) * 4);
            _ = currentPropertyBuilder.Append($"{indent}}}");

            var result = currentPropertyBuilder.ToString();
            var emptyCIM = result.Replace(" ", "").Replace("\r\n", "");

            return emptyCIM.Equals($"MSFT_{cimInstanceName}{{}}")
                ? string.Empty
                : result;
        }
    }
}
