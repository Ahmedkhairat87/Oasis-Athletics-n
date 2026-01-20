class ImageUtils {
  static String fixImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return "";

    // Convert backslashes → forward slashes
    String clean = raw.replaceAll("\\", "/");

    // If already a full URL → return it
    if (clean.startsWith("http")) return clean;

    // Otherwise attach base URL
    return "https://staff.oasisdemaadi.com/$clean";
  }
}
