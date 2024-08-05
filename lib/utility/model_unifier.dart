class ModelUnifier {
  /// Converts the given string to lowercase and removes underscores.
  static String formatString(String input) {
    if (input.isEmpty) {
      return input;
    }
    String lowercased = input.toLowerCase();
    String formatted = lowercased.replaceAll('_', '');
    return formatted;
  }
}
