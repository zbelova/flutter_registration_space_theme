//страница редактирования профиля. Во время регистрации показывается меньше полей.
//При открытии через "Редактировать" на странице профиля, открывается больше полей.
//Данные сохраняются в юзер префс через объект User, запакованный в json.
//Кнопка "Загрузить диплом психолога" не обрабатывается. По логике после загрузки и подтверждения диплома
//модератором должно открываться дополнительное поле стаж


import 'package:flutter/material.dart';
import 'package:homework9_2/screens/profile_page.dart';
import 'package:homework9_2/widgets/myWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../data/classes.dart';
import '../data/user_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<EditProfilePage> {
  TextEditingController dateInput = TextEditingController();
  final bool loggedIn = UserPreferences().getLoggedIn();
  User? user;
  var text;
  var color;
  XFile? image;
  var _approve = false;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    user = loggedIn ? UserPreferences().getUserObject() : User(name: '');
    //user = UserPreferences().getUserObject(); //юзер берется из юзер префс
    super.initState();
    if (loggedIn) {
      dateInput.text = user!.birthDate != null ? DateFormat('dd.MM.yyyy').format(user!.birthDate!) : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildUserProfile(context);
    //return buildScaffold(context);
  }

  Widget buildUserProfile(BuildContext context) {
    if (loggedIn) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, user);
            return false;
          },
          child: buildScaffold(context));
    } else {
      return buildScaffold(context);
    }
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: loggedIn ? const Text('Редактировать профиль') : const Text('Регистрация'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/bg2.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formkey,
            child: ListView(
              children: [
                buildPhotoField(),
                buildNameField(),
                const SizedBox(
                  height: 14,
                ),
                buildContactField(),
                const SizedBox(
                  height: 14,
                ),
                buildEmailField(),
                const SizedBox(
                  height: 14,
                ),
                buildPasswordField(),
                if (loggedIn) buildAdditionalFields(),
                if (!loggedIn) buildApproveField(),
                ElevatedButton(
                    onPressed: () {
                      Color color = Colors.green;
                      String text;
                      //text = 'Необходимо заполнить поля';
                      text = 'Данные профиля сохранены';
                      // if (_approve == false) {
                      //   text = 'Необходимо предоствить согласие на обработку персональных данных';
                      // }
                      // if (!_formkey.currentState!.validate()) {
                      //   text = 'Необходимо заполнить поля';
                      // } else {
                      if (_formkey.currentState!.validate()) {
                        //text = 'Необходимо заполнить поля';

                        _formkey.currentState!.save();
                        UserPreferences().setUserObject(user!);

                        text = 'Данные профиля сохранены';
                        color = Colors.green;
                        if (loggedIn) {
                          //Navigator.of(context).pop();
                          Navigator.pop(context, user);
                        } else {
                          UserPreferences().setLoggedIn(true);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                            (Route<dynamic> route) => false,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(text),
                            backgroundColor: color,
                          ),
                        );
                      }


                    },
                    child: const Text(
                      'Сохранить',
                    ))
              ],
            )),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      initialValue: user!.name,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Имя')),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Введитие имя';
        }
      },
      onSaved: (value) {
        user!.name = value!;
      },
    );
  }

  Widget buildDateTimeField() {
    return TextFormField(
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Введитие дату рождения';
      //   }
      // },
      controller: dateInput,
      //editing controller of this TextField
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          //labelText: "Дата рождения" //label text of field
          prefixIcon: PrefixWidget("Дата рождения")),
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          //initialDate: user!.birthDate,
          initialDate: DateTime.now(),
          firstDate: DateTime(1940),
          //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          user!.birthDate = pickedDate;
          //pickedDate output format => 2021-03-10 00:00:00.000
          //String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
          //formatted date output using intl package =>  2021-03-16
          setState(() {
            dateInput.text = formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );
  }

  Widget buildCityField() {
    return TextFormField(
      initialValue: user!.city,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Город')),
      keyboardType: TextInputType.text,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Введите ваш город';
      //   }
      // },
      onSaved: (value) {
        user!.city = value!;
      },
    );
  }

  Widget buildAboutField() {
    return SizedBox(
      height: 80,
      child: TextFormField(
        initialValue: user!.aboutSelf,
        decoration: InputDecoration(
          prefixIcon: Column(

            children: [ Padding(
              padding: EdgeInsets.only(left: 20, right: 5, top:15),
              child: Text(
                "О себе:".toUpperCase(),
                style: TextStyle(color: Colors.grey[700]),
                //style: TextStyle(color: Colors.blue[700]),
              ),
            ),

            ],
          ),
        ),
        keyboardType: TextInputType.multiline,

        maxLines: 3,

        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'Напишите о себе ';
        //   }
        // },
        onSaved: (value) {
          user!.aboutSelf = value!;
        },
      ),
    );
  }

  // Widget buildPhotoField() { //фото из интернета. заменила на фото из галлереи
  //   return TextFormField(
  //     initialValue: user!.photo == 'lib/data/photos/default.jpg' ? '' : user!.photo,
  //     decoration: const InputDecoration(labelText: 'Ваше фото (URL ссылка)'),
  //     keyboardType: TextInputType.multiline,
  //     validator: validateImageUrl,
  //     onSaved: (value) {
  //       user!.photo = value!;
  //     },
  //   );
  // }
  Widget buildPhotoField() {
    return Column(
      children: [
        if (image != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: 150,
              child: user!.buildPhotoImage()
            ),
          ),
        ] else ...[
          if (user!.photo != 'lib/assets/default.jpg') ...[
            SizedBox(
              width: 150,
              child: user!.buildPhotoImage()
            ),
          ] else ...[
            const Text(
              "Не выбрано",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ],
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            myAlert();
          },
          child: const Text('Выбрать фото'),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildApproveField() {
    // return CheckboxListTile(
    //   title: const Text(
    //     'Я даю согласие на обработку персональных данных',
    //     style: TextStyle(color: Colors.white),
    //   ),
    //   value: _approve,
    //   onChanged: (bool? value) {
    //     setState(() => _approve = value!);
    //   },
    // );
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        CheckboxFormField(
          title: 'Я даю согласие на обработку персональных данных',
          initialValue: _approve,
          validator: (value) {
            if (value == false) {
              return 'Необходимо предоставить согласие на обработку персональных данных';
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildAdditionalFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 14,
        ),
        buildDateTimeField(),
        SizedBox(
          height: 14,
        ),
        buildCityField(),
        SizedBox(
          height: 14,
        ),
        buildAboutField(),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      initialValue: user!.email,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Email')),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (value) {
        user!.email = value!;
      },
    );
  }

  Widget buildContactField() {
    return TextFormField(
      initialValue: user!.phone.isEmpty ? "+7" : user!.phone,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Телефон')),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Введите ваш номер телефона';
        } else if (value.length != 12) {
          return 'Некорректная длина номера';
        }
      },
      onSaved: (value) {
        user!.phone = value!;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      initialValue: user!.password,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Пароль')),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return "Придуймайте пароль";
        }
      },
      onSaved: (value) {
        user!.password = value!;
      },
    );
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
      user!.photo = img != null ? img.path : user!.photo;
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Выберите фото'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('Из галереи'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('Использовать камеру'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? validateImageUrl(String? value) {
    String pattern = r'^https?:\/\/.*\.(jpeg|jpg|gif|png)$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!) && value.isNotEmpty) {
      return 'Неверный формат ссылки';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Укажите адрес элекронной почты';
    } else if (!regex.hasMatch(value)) {
      return 'Неверный формат адреса почты';
    } else {
      return null;
    }
  }
}
