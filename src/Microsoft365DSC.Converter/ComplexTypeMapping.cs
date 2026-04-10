namespace Microsoft365DSC.Converter
{
    public class ComplexTypeMapping
    {
        public string Name { get; set; } = string.Empty;
        public string CimInstanceName { get; set; } = string.Empty;
        public bool IsArray { get; set; } = false;
        public bool IsRequired { get; set; } = false;
    }
}
