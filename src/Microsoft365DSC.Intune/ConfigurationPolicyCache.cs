using System;
using System.Collections.Concurrent;
using System.Collections.Generic;

namespace Microsoft365DSC.Intune
{
    /// <summary>
    /// A thread-safe cache for storing configuration policies by their template IDs.
    /// </summary>
    public static class ConfigurationPolicyCache
    {
        private static readonly ConcurrentDictionary<string, List<object>> _cache = new();
        private static volatile bool _isPopulated;
        private static readonly object _lock = new();

        public static void Populate(IEnumerable<object> allPolicies, Func<object, string> templateIdSelector)
        {
            lock (_lock)
            {
                if (_isPopulated)
                    return;

                foreach (var policy in allPolicies)
                {
                    string templateId = templateIdSelector(policy);
                    if (string.IsNullOrEmpty(templateId))
                        continue;

                    _cache.AddOrUpdate(templateId,
                        _ => [policy],
                        (_, list) => {list.Add(policy); return list; });
                }
                _isPopulated = true;
            }
        }

        public static List<object>? GetByTemplateId(string templateId) =>
            _cache.TryGetValue(templateId, out var list) ? list : null;

        public static void Reset()
        {
            lock (_lock) { _cache.Clear(); _isPopulated = false; }
        }
    }
}
