using Microsoft.Management.Infrastructure;
using System.Text;

namespace Microsoft365DSC.Converter
{
    public class CimInstanceConverter
    {
        public static string ToString(CimInstance cimInstance)
        {
            StringBuilder sb = new();
            _ = sb.Append("{");
            foreach (var property in cimInstance.CimInstanceProperties)
            {
                _ = sb.Append($"{property.Name}={property.Value}");
            }
            _ = sb.Append("}");
            return sb.ToString();
        }
    }
}
