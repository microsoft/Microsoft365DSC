using Microsoft.Management.Infrastructure;
using System;
using System.Collections;
using System.Collections.Generic;

namespace Microsoft365DSC.Converter
{
    public class HashtableConverter
    {
        /// <summary>
        /// Converts the specified hashtable to its string representation.
        /// </summary>
        /// <param name="hashtable">The hashtable to convert to a string.</param>
        /// <returns>A string that represents the specified hashtable.</returns>
        public static string ToString(Hashtable hashtable)
        {
            List<string> propertyStrings = [];
            List<string> parametersToObfuscate = ["ApplicationId", "ApplicationSecret", "TenantId", "CertificateThumbprint", "CertificatePath", "CertificatePassword", "Credential", "Password"];
            foreach (DictionaryEntry entry in hashtable)
            {
                string propertyString;
                if (entry.Value is Array array)
                {
                    propertyString = $"{entry.Key}={ArrayConverter.ToString(array)}";
                }
                else if (entry.Value is Hashtable ht)
                {
                    propertyString = $"{entry.Key}={{{ToString(ht)}}}";
                }
                else if (entry.Value is CimInstance cimInstance)
                {
                    propertyString = $"{entry.Key}={CimInstanceConverter.ToString(cimInstance)}";
                }
                else
                {
                    if (entry.Value is null)
                    {
                        propertyString = $"{entry.Key}=$null";
                    }
                    else
                    {
                        if (parametersToObfuscate.Contains(entry.Key.ToString()))
                        {
                            propertyString = $"{entry.Key}=***";
                        }
                        else
                        {
                            propertyString = $"{entry.Key}={entry.Value}";
                        }
                    }
                }
                propertyStrings.Add(propertyString);
            }

            propertyStrings.Sort();
            return string.Join(Environment.NewLine, propertyStrings);
        }
    }
}
