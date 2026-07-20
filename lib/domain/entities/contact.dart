/// An emergency contact who will be notified during SOS.
///
/// Each contact has a phone number, a relationship label
/// (e.g., 'Mother', 'Father'), and a flag indicating whether
/// they are the primary point of contact.
class Contact {
  /// Unique identifier for the contact.
  final String id;

  /// Full name of the contact.
  final String name;

  /// Phone number in E.164 or local format.
  final String phoneNumber;

  /// Email address for the contact.
  final String? email;

  /// Relationship to the user, e.g., 'Mother', 'Father', 'Sister'.
  final String relationship;

  /// Whether this contact is the primary emergency contact.
  final bool isPrimary;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    required this.relationship,
    required this.isPrimary,
  });

  /// Returns a copy of this [Contact] with the given fields replaced.
  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? relationship,
    bool? isPrimary,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
