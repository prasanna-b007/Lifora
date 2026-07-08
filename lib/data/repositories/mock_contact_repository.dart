import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';

/// In-memory mock implementation of [ContactRepository].
///
/// Pre-populated with three emergency contacts in an Indian family
/// context (Coimbatore, Tamil Nadu). All CRUD operations work on
/// the in-memory list and are lost on app restart.
class MockContactRepository implements ContactRepository {
  final List<Contact> _contacts = [
    const Contact(
      id: 'c1',
      name: 'Amma',
      phoneNumber: '+91 98765 43210',
      relationship: 'Mother',
      isPrimary: true,
    ),
    const Contact(
      id: 'c2',
      name: 'Appa',
      phoneNumber: '+91 98765 43211',
      relationship: 'Father',
      isPrimary: false,
    ),
    const Contact(
      id: 'c3',
      name: 'Kavitha',
      phoneNumber: '+91 98765 43212',
      relationship: 'Sister',
      isPrimary: false,
    ),
  ];

  @override
  List<Contact> getContacts() => List.unmodifiable(_contacts);

  @override
  Contact? getContact(String id) {
    try {
      return _contacts.firstWhere((contact) => contact.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  void addContact(Contact contact) {
    _contacts.add(contact);
  }

  @override
  void updateContact(Contact contact) {
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
    }
  }

  @override
  void removeContact(String id) {
    _contacts.removeWhere((contact) => contact.id == id);
  }
}
