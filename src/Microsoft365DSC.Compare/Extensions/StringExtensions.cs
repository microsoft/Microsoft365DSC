using System;

namespace Microsoft365DSC.Compare.Extensions
{
    /// <summary>
    /// Extension methods for System.String
    /// </summary>
    public static class StringExtensions
    {
        /// <summary>
        /// Converts a single string to a string array containing one element.
        /// </summary>
        /// <param name="value">The string to convert</param>
        /// <returns>A string array containing the input string</returns>
        public static string[] ToArray(this string value)
        {
            return new[] { value };
        }

        /// <summary>
        /// Converts a single string to an Array of the specified type.
        /// </summary>
        /// <param name="value">The string to convert</param>
        /// <param name="elementType">The type of elements in the resulting array</param>
        /// <returns>An Array containing the input string</returns>
        public static Array ToArray(this string value, Type elementType)
        {
            Array result = Array.CreateInstance(elementType, 1);
            result.SetValue(value, 0);
            return result;
        }
    }
}