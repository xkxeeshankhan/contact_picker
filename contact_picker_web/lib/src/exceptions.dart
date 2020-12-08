/// Exception thrown when the Picker is not available on the current plattform
class PickerNotAvailableException implements Exception {}

/// Exception thrown when a user hits the back button without selecting a contact
class UserCancelledPickingException implements Exception {}
