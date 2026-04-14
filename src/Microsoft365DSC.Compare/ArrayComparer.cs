using System;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft365DSC.Compare
{
    internal class ArrayComparer
    {
        public static List<CompareObjectModel> CompareArrays(Array currentArray, Array desiredArray, bool passThru = false)
        {
            List<CompareObjectModel> compareResults = [];

            if (currentArray is null || desiredArray is null)
            {
                throw new ArgumentException("Both currentValue and desiredValue must be of type Array and cannot be null.");
            }

            IEnumerable<object> currentObjects = Utilities.Utilities.UnwrapArray(currentArray).Cast<object>();
            IEnumerable<object> desiredObjects = Utilities.Utilities.UnwrapArray(desiredArray).Cast<object>();

            if (!currentObjects.Any() && !desiredObjects.Any())
            {
                return compareResults; // Both arrays are empty, return empty results
            }

            // Find items in desired but not in current
            foreach (var item in desiredObjects)
            {
                if (!ContainsItem(currentObjects, item))
                {
                    compareResults.Add(new CompareObjectModel
                    {
                        SideIndicator = "<=",
                        InputObject = item
                    });
                    continue;
                }

                if (passThru)
                {
                    compareResults.Add(new CompareObjectModel
                    {
                        SideIndicator = "==",
                        InputObject = item
                    });
                }
            }
            // Find items in current but not in desired
            foreach (var item in currentObjects)
            {
                if (!ContainsItem(desiredObjects, item))
                {
                    compareResults.Add(new CompareObjectModel
                    {
                        SideIndicator = "=>",
                        InputObject = item
                    });
                    continue;
                }

                if (passThru)
                {
                    compareResults.Add(new CompareObjectModel
                    {
                        SideIndicator = "==",
                        InputObject = item
                    });
                }
            }

            return compareResults;
        }

        private static bool ContainsItem(IEnumerable<object> collection, object item)
        {
            return collection.Any(x => string.Equals(x.ToString(), item.ToString(), StringComparison.OrdinalIgnoreCase));
        }
    }
}
