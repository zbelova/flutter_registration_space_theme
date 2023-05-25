import 'package:objectbox/objectbox.dart';

//вызвать после создания entity
//flutter packages pub run build_runner build или flutter packages pub run build_runner build --delete-conflicting-outputs (удалит конфликтующие файлы).

@Entity()
class UserTable {
  @Id()
  int id;
  String name;
  String phone;
  String email;
  String password;

  //DateTime birthDate = DateTime.now();
  DateTime? birthDate;
  String city;
  String aboutSelf;
  String photo;

  UserTable({
    this.id = 0,
    required this.name, required this.phone, required this.email, required this.password, this.city = '', this.aboutSelf = '', this.photo = 'lib/assets/default.jpg', this.birthDate
  });
}