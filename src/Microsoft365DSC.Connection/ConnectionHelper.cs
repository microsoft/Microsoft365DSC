using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace Microsoft365DSC.Connection
{
    /// <summary>
    /// Provides methods for determining the most secure authentication type
    /// supported by Microsoft365DSC resources.
    /// </summary>
    public static class ConnectionHelper
    {
        /// <summary>
        /// Gets all resources that support the specified authentication method and
        /// determines the most secure authentication method supported by each resource.
        /// </summary>
        /// <param name="dscResourcesPath">
        /// The path to the DSCResources folder containing the .psm1 resource modules.
        /// </param>
        /// <param name="authenticationMethods">
        /// The authentication methods to evaluate, in order of preference:
        /// ApplicationWithSecret, CertificateThumbprint, CertificatePath, Credentials,
        /// CredentialsWithTenantId, CredentialsWithApplicationId, ManagedIdentity, AccessTokens.
        /// </param>
        /// <param name="resources">
        /// The resource names to evaluate (without MSFT_ prefix and .psm1 extension).
        /// </param>
        /// <returns>
        /// A list of Hashtable objects, each containing 'Resource' (string) and 'AuthMethod' (string).
        /// </returns>
        public static List<Hashtable> GetComponentsWithMostSecureAuthenticationType(
            string dscResourcesPath,
            string[] authenticationMethods,
            string[] resources)
        {
            if (string.IsNullOrEmpty(dscResourcesPath))
            {
                throw new ArgumentNullException(nameof(dscResourcesPath));
            }

            if (authenticationMethods == null || authenticationMethods.Length == 0)
            {
                throw new ArgumentNullException(nameof(authenticationMethods));
            }

            if (resources == null || resources.Length == 0)
            {
                throw new ArgumentNullException(nameof(resources));
            }

            HashSet<string>? resourceSet = new(resources, StringComparer.OrdinalIgnoreCase);
            HashSet<string>? authMethodSet = new(authenticationMethods, StringComparer.OrdinalIgnoreCase);
            List<Hashtable>? components = [];

            string[]? modules = Directory.GetFiles(dscResourcesPath, "*.psm1", SearchOption.AllDirectories);

            foreach (string modulePath in modules)
            {
                string fileName = Path.GetFileNameWithoutExtension(modulePath);
                string resourceName = StripPrefix(fileName, "MSFT_");

                if (!resourceSet.Contains(resourceName))
                {
                    continue;
                }

                List<string> parameters;
                try
                {
                    parameters = Utilities.Utilities.GetFunctionParameterNamesByAST(modulePath, "Set-TargetResource");
                }
                catch (InvalidOperationException)
                {
                    continue;
                }

                HashSet<string>? paramSet = new(parameters, StringComparer.OrdinalIgnoreCase);
                string? authMethod = DetermineMostSecureAuthMethod(authMethodSet, paramSet, fileName);

                if (authMethod != null)
                {
                    components.Add(new Hashtable
                    {
                        { "Resource", resourceName },
                        { "AuthMethod", authMethod }
                    });
                }
            }

            return components;
        }

        /// <summary>
        /// Determines the most secure authentication method for a resource based on
        /// the authentication methods requested and the parameters the resource supports.
        /// The priority order matches the original PowerShell elseif chain.
        /// </summary>
        private static string? DetermineMostSecureAuthMethod(
            HashSet<string> authMethods,
            HashSet<string> parameters,
            string fileName)
        {
            // CertificateThumbprint
            if (authMethods.Contains("CertificateThumbprint") &&
                parameters.Contains("ApplicationId") &&
                parameters.Contains("CertificateThumbprint") &&
                parameters.Contains("TenantId"))
            {
                return "CertificateThumbprint";
            }

            // CertificatePath
            if (authMethods.Contains("CertificatePath") &&
                parameters.Contains("ApplicationId") &&
                parameters.Contains("CertificatePath") &&
                parameters.Contains("TenantId"))
            {
                return "CertificatePath";
            }

            // ApplicationWithSecret -> AuthMethod = "ApplicationSecret"
            if (authMethods.Contains("ApplicationWithSecret") &&
                parameters.Contains("ApplicationId") &&
                parameters.Contains("ApplicationSecret") &&
                parameters.Contains("TenantId"))
            {
                return "ApplicationSecret";
            }

            // CredentialsWithTenantId (excludes SPO, OD, PP prefixed resources)
            if (authMethods.Contains("CredentialsWithTenantId") &&
                parameters.Contains("Credential") &&
                parameters.Contains("TenantId") &&
                !fileName.StartsWith("MSFT_SPO", StringComparison.OrdinalIgnoreCase) &&
                !fileName.StartsWith("MSFT_OD", StringComparison.OrdinalIgnoreCase) &&
                !fileName.StartsWith("MSFT_PP", StringComparison.OrdinalIgnoreCase))
            {
                return "CredentialsWithTenantId";
            }

            // CredentialsWithApplicationId
            if (authMethods.Contains("CredentialsWithApplicationId") &&
                parameters.Contains("Credential"))
            {
                return "CredentialsWithApplicationId";
            }

            // Credentials
            if (authMethods.Contains("Credentials") &&
                parameters.Contains("Credential"))
            {
                return "Credentials";
            }

            // ManagedIdentity
            if (authMethods.Contains("ManagedIdentity") &&
                parameters.Contains("ManagedIdentity"))
            {
                return "ManagedIdentity";
            }

            // AccessTokens
            if (authMethods.Contains("AccessTokens") &&
                parameters.Contains("AccessTokens"))
            {
                return "AccessTokens";
            }

            return null;
        }

        private static string StripPrefix(string value, string prefix)
        {
            return value.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)
                ? value.Substring(prefix.Length)
                : value;
        }
    }
}
