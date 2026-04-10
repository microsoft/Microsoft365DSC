using Microsoft.Management.Infrastructure;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;

namespace Microsoft365DSC.Converter
{
    /// <summary>
    /// Recursively converts any object (CimInstance, PSObject, IDictionary, Graph SDK types,
    /// arrays of any of these) into a uniform Hashtable tree with case-insensitive key lookup.
    /// After normalization every node is either a Hashtable, a primitive/string, or an
    /// object[] of those. This eliminates all CimInstance/PSObject type-specific handling
    /// from the comparison pipeline.
    /// </summary>
    public static class ObjectNormalizer
    {
        /// <summary>
        /// Normalizes an arbitrary object into the primitives, Array or Hashtable tree.
        /// - null stays null
        /// - Primitives, strings, DateTime, Guid stay as-is
        /// - Arrays become object[] where each element is normalized
        /// - CimInstance / PSObject / IDictionary / Graph SDK objects become
        ///   Hashtable (case-insensitive) with recursively normalized values
        /// </summary>
        public static object? Normalize(object? obj)
        {
            if (obj is null)
                return null;

            // Unwrap PSObject wrapper to get at the real object
            if (obj is PSObject psObject)
            {
                // PSObject can wrap null
                if (psObject.BaseObject is null || psObject.BaseObject is PSCustomObject)
                {
                    return Normalize(psObject);
                }
                obj = psObject.BaseObject;
            }

            // Primitives and well-known leaf types: return directly
            if (IsLeafType(obj))
                return obj;

            // Arrays (including CimInstance[], object[], string[]): normalize each element
            if (obj is Array array)
                return NormalizeArray(array);
                
            if (obj is IDictionary or CimInstance)
                return ComplexObjectConverter.ToHashtable(obj);

            // IEnumerable but not primitive/array/dictionary: treat as array
            // (covers List<T>, Collection<T>, etc.)
            if (obj is IEnumerable enumerable && obj is not string)
                return NormalizeEnumerable(enumerable);

            // Truly unknown leaf: return as-is (ToString will be used downstream)
            return obj;
        }

        /// <summary>
        /// Returns true if the object is a leaf type that should not be decomposed further.
        /// </summary>
        private static bool IsLeafType(object obj)
        {
            if (obj is null)
                return true;

            Type type = obj.GetType();

            // All .NET primitive types (bool, int, long, double, etc.)
            if (type.IsPrimitive)
                return true;

            // Common non-primitive leaf types
            if (type == typeof(string) ||
                type == typeof(DateTime) ||
                type == typeof(DateTimeOffset) ||
                type == typeof(decimal) ||
                type == typeof(Guid) ||
                type == typeof(TimeSpan))
                return true;

            // Enum values are leaf types
            if (type.IsEnum)
                return true;

            // SwitchParameter from PowerShell
            if (type == typeof(SwitchParameter))
                return true;

            return false;
        }

        /// <summary>
        /// Normalizes an array. Returns object[] with each element normalized.
        /// </summary>
        private static object[] NormalizeArray(Array source)
        {
            var result = new object[source.Length];
            for (int i = 0; i < source.Length; i++)
            {
                result[i] = Normalize(source.GetValue(i));
            }
            return result;
        }

        /// <summary>
        /// Normalizes an IEnumerable (non-array, non-string, non-dictionary)
        /// by materializing to a list and converting to object[].
        /// </summary>
        private static object[] NormalizeEnumerable(IEnumerable source)
        {
            var items = new List<object>();
            foreach (object item in source)
            {
                items.Add(Normalize(item));
            }
            return items.ToArray();
        }
    }
}
