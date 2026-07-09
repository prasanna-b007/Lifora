import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';
import 'package:lifora/core/constants.dart';

/// View model for managing emergency contacts.
class ContactsProvider extends ChangeNotifier {
  ContactsProvider({
    required ContactRepository contactRepository,
  }) : _contactRepository = contactRepository;

  final ContactRepository _contactRepository;

  /// Returns all emergency contacts.
  List<Contact> get contacts {
    print("Loading contacts...");
    return _contactRepository.getContacts();
  }

  /// Whether the user can add more contacts.
  bool get canAddContact => contacts.length < AppConstants.maxEmergencyContacts;

  /// Adds a new contact if the limit has not been reached.
  void addContact(Contact contact) {
    if (!canAddContact) return;
    
    print("Saving contact...");
    
    // If this is the first contact or marked as primary, ensure others are not primary.
    final isFirst = contacts.isEmpty;
    final newContact = contact.copyWith(isPrimary: contact.isPrimary || isFirst);

    if (newContact.isPrimary) {
      _clearPrimary();
    }

    _contactRepository.addContact(newContact);
    notifyListeners();
  }

  /// Updates an existing contact.
  void updateContact(Contact contact) {
    print("Saving contact...");
    if (contact.isPrimary) {
      _clearPrimary();
    }
    _contactRepository.updateContact(contact);
    notifyListeners();
  }

  /// Removes a contact by ID.
  void removeContact(String id) {
    final contact = _contactRepository.getContact(id);
    _contactRepository.removeContact(id);
    
    // If we removed the primary contact and others exist, make the first one primary.
    if (contact?.isPrimary == true && contacts.isNotEmpty) {
      final first = contacts.first;
      _contactRepository.updateContact(first.copyWith(isPrimary: true));
    }
    
    notifyListeners();
  }

  /// Sets a specific contact as the primary contact.
  void setPrimaryContact(String id) {
    final contact = _contactRepository.getContact(id);
    if (contact == null || contact.isPrimary) return;

    _clearPrimary();
    _contactRepository.updateContact(contact.copyWith(isPrimary: true));
    print("Primary contact updated.");
    notifyListeners();
  }

  /// Helper to clear the primary flag from all contacts.
  void _clearPrimary() {
    for (final c in contacts) {
      if (c.isPrimary) {
        _contactRepository.updateContact(c.copyWith(isPrimary: false));
      }
    }
  }
}
