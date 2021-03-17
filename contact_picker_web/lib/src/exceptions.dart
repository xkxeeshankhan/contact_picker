/// Exception thrown when the Picker is not available on the current plattform
/// See https://web.dev/contact-picker/ and https://developer.mozilla.org/en-US/docs/Web/API/Contact_Picker_API#Browser_compatibility for more information
class PickerNotAvailableException implements Exception {
  @override
  String toString() =>
      'PickerNotAvailableException: The web contact picker API is not available in this browser. Right now it is only available in mobile versions of some chromium browser. Read this for more info: https://web.dev/contact-picker/ && https://developer.mozilla.org/en-US/docs/Web/API/Contact_Picker_API#Browser_compatibility';
}
