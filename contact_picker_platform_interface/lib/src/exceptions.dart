/// Exception thrown when a user hits the back button without selecting a contact
class UserCancelledPickingException implements Exception {
  @override
  String toString() =>
      'UserCancelledPickingException: The user hit the back button instead of selecting a contact';
}
