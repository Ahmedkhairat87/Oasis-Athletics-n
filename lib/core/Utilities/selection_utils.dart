// lib/core/utils/selection_utils.dart

class SelectionUtils {
  SelectionUtils._(); // private constructor

  /// Safe string normalize
  static String s(dynamic v) => (v ?? '').toString().trim();

  /// Converts CSV string OR List to Set<String>
  /// supports: null | "a,b,c" | ["a","b"] | ""
  static Set<String> parseCsvToSet(dynamic selected) {
    if (selected == null) return {};

    if (selected is List) {
      return selected.map((e) => s(e)).where((x) => x.isNotEmpty).toSet();
    }

    final str = s(selected);
    if (str.isEmpty) return {};

    return str
        .split(',')
        .map((e) => s(e))
        .where((x) => x.isNotEmpty)
        .toSet();
  }

  /// Builds checkbox map from API list
  /// Supports:
  ///  - [{Column1: "..."}]
  ///  - model with `.column1`
  static Map<String, bool> buildOptionsMap(List<dynamic>? apiList) {
    final keys = <String>[];

    for (final e in (apiList ?? [])) {
      final k = (e is Map)
          ? s(e['Column1'])
          : s((e as dynamic).column1);

      if (k.isNotEmpty) keys.add(k);
    }

    // preserve order, remove duplicates
    final seen = <String>{};
    final unique = <String>[];

    for (final k in keys) {
      if (seen.add(k)) unique.add(k);
    }

    return {for (final k in unique) k: false};
  }

  /// Applies selected CSV/List into checkbox map
  static void applySelected(
      Map<String, bool> map,
      dynamic selected,
      ) {
    final selectedSet = parseCsvToSet(selected);

    map.updateAll((k, v) => selectedSet.contains(k));
  }

  /// Converts checkbox map -> CSV string
  static String mapToCsv(Map<String, bool> map) {
    return map.entries
        .where((e) => e.value)
        .map((e) => e.key.trim())
        .where((x) => x.isNotEmpty)
        .join(',');
  }
}