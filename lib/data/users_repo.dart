import 'package:flutter_user_profile/data/user_table.dart';

import '../objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<UserTable> _userTableBox;

  ObjectBox._create(this._store) {
    _userTableBox = Box<UserTable>(_store);

    // Add some demo data if the box is empty.
    if (_userTableBox.isEmpty()) {
      _putDemoData();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void _putDemoData() {
    final demoUsers = [
      UserTable(name: 'aaa', password: '123', email: '1@c.com', phone: '+75554445544'),
      UserTable(name: 'bbb', password: '123', email: '2@c.com', phone: '+75554445544'),
      UserTable(name: 'ccc', password: '123', email: '3@c.com', phone: '+75554445544'),
    ];
    _userTableBox.putManyAsync(demoUsers);
  }

  Stream<List<UserTable>> getUsers() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder = _userTableBox.query().order(UserTable_.name, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder
        .watch(triggerImmediately: true)
        // Map it to a list of notes to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  // Future<UserTable> getById(int id) async {
  //   Query<UserTable> query = _userTableBox.query(UserTable_.id.equals(id)).build();
  //   List<UserTable> objects = query.find();
  //   UserTablhe userById = objects.first;
  //   query.close();
  //   return userById;
  // }
  Future<UserTable?> getById(int id) {
    //id = 1;
    return _userTableBox.getAsync(id);
  }


  /// Add a note.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, asynchronously.
  /// For this example only a single object is put which would also be fine if
  /// done using [Box.put].
  Future<void> addUser(String name, String phone, String email, String password) => _userTableBox.putAsync(
        UserTable(name: name, password: password, email: email, phone: phone),
      );

  Future<void> removeUser(int id) => _userTableBox.removeAsync(id);
}

class UsersRepo {
  // final _users = <UserTable>[];
  //
  // List<UserTable> get users => _users;
  // UserTable getById (int id) {
  //   Query<UserTable> query = box.query(UserTable_.email.equals('Joe')).build();
  //   List<UserTable> userById = query.find();
  //   query.close();
  //   return userById;
  // }
  //
  // void addNote(UserTable user) {
  //   _users.add(user);
  // }
  late final Store _store;
  late final Box<UserTable> _box;

  List<UserTable> get notes => _box.getAll();

  Future initDB() async {
    _store = await openStore();
    _box = _store.box<UserTable>();
  }

  Future addUser(UserTable note) async {
    await _box.putAsync(note);
  }

  Future<UserTable> getById(int id) async {
    Query<UserTable> query = _box.query(UserTable_.id.equals(id)).build();
    List<UserTable> objects = query.find();
    UserTable userById = objects.first;
    query.close();
    return userById;
  }
}
