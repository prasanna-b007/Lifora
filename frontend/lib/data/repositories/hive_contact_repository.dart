import 'package:hive/hive.dart';
import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/domain/repositories/contact_repository.dart';
import 'package:lifora/data/models/contact_hive_model.dart';
import 'package:lifora/data/repositories/mock_contact_repository.dart';

class HiveContactRepository implements ContactRepository {
  final Box<ContactHiveModel> _box;

  HiveContactRepository(this._box) {
    _initSeedData();
  }

  void _initSeedData() {
    if (_box.isEmpty) {
      final mockRepo = MockContactRepository();
      for (final contact in mockRepo.getContacts()) {
        final hiveModel = ContactHiveModel.fromDomain(contact);
        _box.put(contact.id, hiveModel);
      }
    }
  }

  @override
  List<Contact> getContacts() {
    return _box.values.map((model) => model.toDomain()).toList();
  }

  @override
  Contact? getContact(String id) {
    return _box.get(id)?.toDomain();
  }

  @override
  void addContact(Contact contact) {
    final hiveModel = ContactHiveModel.fromDomain(contact);
    _box.put(contact.id, hiveModel);
  }

  @override
  void updateContact(Contact contact) {
    final hiveModel = ContactHiveModel.fromDomain(contact);
    _box.put(contact.id, hiveModel);
  }

  @override
  void removeContact(String id) {
    _box.delete(id);
  }
}
