using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;

namespace Microsoft365DSC.Cache
{
    /// <summary>
    /// Provides a centralized, thread-safe cache for expensive data structures
    /// shared across PowerShell and C# layers. Loading data here avoids repeated
    /// deserialization and the boxing overhead that occurs when passing rich
    /// objects from PowerShell to C#.
    /// </summary>
    public static class CacheManager
    {
        private static readonly object SchemaLock = new();
        private static List<object> _schema;

        /// <summary>
        /// Gets a value indicating whether the M365DSC schema has been loaded.
        /// </summary>
        public static bool IsSchemaLoaded
        {
            get
            {
                lock (SchemaLock)
                {
                    return _schema != null;
                }
            }
        }

        /// <summary>
        /// Gets the cached schema as an <see cref="IEnumerable{Object}"/> of Hashtables.
        /// Returns <c>null</c> if the schema has not been loaded yet.
        /// </summary>
        public static IEnumerable<object> Schema
        {
            get
            {
                lock (SchemaLock)
                {
                    return _schema;
                }
            }
        }

        /// <summary>
        /// Loads the schema from a list of objects,
        /// deserializes it into a list of <see cref="Hashtable"/> trees, and caches
        /// the result. Subsequent calls are no-ops unless <paramref name="force"/>
        /// is <c>true</c>.
        /// </summary>
        /// <param name="schema">List of schema objects to cache.</param>
        public static void LoadSchema(List<object> schema)
        {
            List<object> newSchema = [];
            foreach (object entry in schema)
            {
                newSchema.Add(ConvertObjectToHashtable(entry));
            }

            lock (SchemaLock)
            {
                _schema = newSchema;
            }
        }

        /// <summary>
        /// Clears the cached schema, allowing it to be reloaded on next access.
        /// Primarily useful for testing.
        /// </summary>
        public static void ClearSchema()
        {
            lock (SchemaLock)
            {
                _schema = null;
            }
        }

        private static object ConvertObjectToHashtable(object entry)
        {
            Hashtable result = new(StringComparer.OrdinalIgnoreCase);

            if (entry is PSObject psObject)
            {
                foreach (var prop in psObject.Properties)
                {
                    result[prop.Name] = ConvertObjectToHashtable(prop.Value);
                }
            }
            else if (entry is IDictionary dict)
            {
                foreach (DictionaryEntry kvp in dict)
                {
                    result[kvp.Key.ToString()] = ConvertObjectToHashtable(kvp.Value);
                }
            }
            else if (entry is IEnumerable enumerable && entry is not string)
            {
                return ConvertEnumerableToHashtableArray(enumerable);
            }
            else
            {
                return entry;
            }
            return result;
        }

        private static object[] ConvertEnumerableToHashtableArray(IEnumerable enumerable)
        {
            var list = new List<object>();
            foreach (object item in enumerable)
            {
                list.Add(ConvertObjectToHashtable(item));
            }
            return list.ToArray();
        }
    }
}
