extension StringExtension on String? {
  isNullOrEmpty() => this == null || this!.isEmpty;
}
