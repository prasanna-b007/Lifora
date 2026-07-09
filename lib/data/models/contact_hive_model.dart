import 'package:hive/hive.dart';
import 'package:lifora/domain/entities/contact.dart';

part 'contact_hive_model.g.dart';

@HiveType(typeId: 0)
class ContactHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String relationship;

  @HiveField(4)
  final bool isPrimary;

  ContactHiveModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.isPrimary,
  });

  /// Maps from Domain Entity to Hive Model
  factory ContactHiveModel.fromDomain(Contact contact) {
    return ContactHiveModel(
      id: contact.id,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      relationship: contact.relationship,
      isPrimary: contact.isPrimary,
    );
  }

  /// Maps from Hive Model to Domain Entity
  Contact toDomain() {
    return Contact(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      relationship: relationship,
      isPrimary: isPrimary,
    );
  }
}
