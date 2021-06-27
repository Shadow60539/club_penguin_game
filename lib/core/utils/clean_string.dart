String cleanString(String? input) {
  if (input == null) {
    return '';
  } else {
    return input.trim().replaceAll(RegExp(' +'), ' ');
  }
}
