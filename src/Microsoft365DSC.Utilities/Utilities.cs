using Microsoft365DSC.Cache;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Language;

namespace Microsoft365DSC.Utilities
{
    public static class Utilities
    {
        public static List<string> GetFunctionParameterNamesByAST(string modulePath, string functionName)
        {
            ScriptBlockAst ast = Parser.ParseFile(modulePath, out var tokens, out var errors);
            FunctionDefinitionAst? functionAst = ast.FindAll(node =>
                node is FunctionDefinitionAst funcDef &&
                funcDef.Name == functionName, true).FirstOrDefault() as FunctionDefinitionAst;

            return functionAst is null || functionAst.Body.ParamBlock is null
                ? throw new InvalidOperationException($"Function '{functionName}' not found in module '{modulePath}' or it does not have a parameter block.")
                : functionAst.Body.ParamBlock.Parameters.Select(param => param.Name.VariablePath.UserPath).ToList();
        }

        /// <summary>
        /// Method to update special characters in strings.
        /// This method handles the conversion of special characters similar to Update-M365DSCSpecialCharacters.
        /// This function updates special characters in a string to be escaped in a DSC configuration.
        /// The function replaces the following characters:
        ///     - 0x201C = “
        ///     - 0x201D = ”
        ///     - 0x201E = „
        /// </summary>
        /// <param name="input">The input string to process</param>
        /// <returns>The processed string with special characters updated</returns>
        public static string UpdateSpecialCharacters(string input)
        {
            input = input.Replace(((char)0x201C).ToString(), "`" + ((char)0x201C).ToString());
            input = input.Replace(((char)0x201D).ToString(), "`" + ((char)0x201D).ToString());
            input = input.Replace(((char)0x201E).ToString(), "`" + ((char)0x201E).ToString());
            return input;
        }

        public static List<Hashtable> FilterHashtablesByResourceAndKey(IEnumerable<object> hashtables, string resourceName, string key, string keyValue)
        {
            List<Hashtable> results = [];
            foreach (Hashtable entry in hashtables.Cast<Hashtable>())
            {
                if (entry["ResourceName"].ToString() == resourceName &&
                    entry[key]?.ToString() == keyValue)
                {
                    results.Add(entry);
                }
            }
            return results;
        }

        public static object? FilterLoadedCimClassesByName(string className)
        {
            if (CacheManager.IsSchemaLoaded)
            {
                return FilterCimClassesByName(CacheManager.Schema, className);
            }
            return null;
        }

        public static object? FilterCimClassesByName(IEnumerable<object> schemaObjects, string className)
        {
            foreach (object obj in schemaObjects)
            {
                if (obj is PSObject psObject)
                {
                    dynamic dyn = psObject as dynamic;
                    string name = dyn.ClassName;
                    if (name == className)
                    {
                        return psObject;
                    }
                }
                else if (obj is IDictionary hashtable)
                {
                    if (hashtable["ClassName"]?.ToString() == className)
                    {
                        return hashtable;
                    }
                }
            }
            return null;
        }

        public static Array UnwrapArray(Array array)
        {
            for (int i = 0; i < array.Length; i++)
            {
                if (array.GetValue(i) is PSObject psObject)
                {
                    array.SetValue(psObject.BaseObject, i);
                }
            }
            return array;
        }

        public static List<string> UnwrapArrayToStrings(Array array)
        {
            List<string> results = [];
            foreach (object item in array)
            {
                object? innerItem = item;
                if (item is PSObject psObject)
                    innerItem = psObject.BaseObject;

                if (innerItem is string str)
                    results.Add(str);
                else
                    results.Add(innerItem.ToString());
            }
            return results;
        }
    }
}
