import '../entities/contact.dart';

/// Interface for managing emergency contacts.
///
/// Implementations handle storage and retrieval of the user's
/// emergency contacts who are notified during SOS events.
abstract class ContactRepository {
  /// Returns all stored emergency contacts.
  List<Contact> getContacts();

  /// Returns the contact with [id], or `null` if not found.
  Contact? getContact(String id);

  /// Adds a new [contact] to the store.
  void addContact(Contact contact);

  /// Updates an existing contact in the store.
  void updateContact(Contact contact);

  /// Removes the contact with the given [id].
  void removeContact(String id);
}
