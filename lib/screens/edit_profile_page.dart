import 'package:flutter/material.dart';
import 'package:flutter_user_profile/screens/profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../data/user_preferences.dart';
import '../data/user_table.dart';
import '../main.dart';
import '../widgets/myWidgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => EditProfileScreen();
}

class EditProfileScreen extends State<EditProfilePage> {
  TextEditingController dateInput = TextEditingController();
  final bool loggedIn = UserPreferences().getLoggedIn();

  //User? user;
  var text;
  var color;
  XFile? image;
  var _approve = false;
  final ImagePicker picker = ImagePicker();

  // Future<UserTable?> getUserTable(int id) {
  //   return objectbox.getById(id);
  // }
  int id =1;

  @override
  void initState() {
    //user = loggedIn ? UserPreferences().getUserObject() : User(name: '');
    //user = UserPreferences().getUserObject(); //юзер берется из юзер префс
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildEditProfile(context);
    //return buildScaffold(context);
  }

  Widget _buildEditProfile(BuildContext context) {
    if (loggedIn) {
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Extracting data from snapshot object
              final user = snapshot.data;
              return WillPopScope(
                  onWillPop: () async {
                    Navigator.pop(context, user);
                    return false;
                  },
                  child: buildScaffold(context));
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: objectbox.getById(id),
      );
    } else {
      return buildScaffold(context);
    }
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: loggedIn
              ? const Text(
                  'Редактировать профиль',
                  style: TextStyle(fontSize: 20),
                )
              : const Text('Регистрация', style: TextStyle(fontSize: 18)),
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Extracting data from snapshot object
              final user = snapshot.data;
              return OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return _buildPortraitEditProfile(context, user!);
                  } else {
                    return _buildLandscapeEditProfile(context, user!);
                  }
                },
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: objectbox.getById(id),
      ),
    );
  }

  Widget _buildPortraitEditProfile(context, UserTable user) {
    return Container(
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
              buildPhotoField(user),
              Container(
                child: _buildTextFieldsColumn(user, context),
              )
            ],
          )),
    );
  }

  Widget _buildLandscapeEditProfile(context, UserTable user) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/bg2.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: constraints.maxWidth > 1000
            ? EdgeInsets.only(
                left: 80,
                top: 20,
                right: 80,
              )
            : EdgeInsets.only(
                left: 40,
                top: 20,
                right: 40,
              ),
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(children: [
              Form(
                  key: _formkey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildPhotoField(user),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        flex: 4,
                        child: _buildTextFieldsColumn(user, context),
                      ),
                    ],
                  )),
            ]),
          ),
        ),
      );
    });
  }

  Column _buildTextFieldsColumn(UserTable user, BuildContext context) {
    return Column(
      children: [
        buildNameField(user),
        const SizedBox(
          height: 14,
        ),
        buildContactField(user),
        const SizedBox(
          height: 14,
        ),
        buildEmailField(user),
        const SizedBox(
          height: 14,
        ),
        buildPasswordField(user),
        if (loggedIn) buildAdditionalFields(user),
        if (!loggedIn) buildApproveField(),
        ElevatedButton(
            onPressed: () {
              Color color = Colors.green;
              String text;

              text = 'Данные профиля сохранены';

              if (_formkey.currentState!.validate()) {
                _formkey.currentState!.save();
                //UserPreferences().setUserObject(user!);

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
            child: Text(
              loggedIn ? 'Сохранить' : 'Зарегистроваться',
              style: TextStyle(fontSize: 16),
            ))
      ],
    );
  }

  Widget buildNameField(UserTable user) {
    return TextFormField(
      initialValue: user.name,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Имя')),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Введитие имя';
        }
        return null;
      },
      onSaved: (value) {
        user.name = value!;
      },
    );
  }

  Widget buildDateTimeField(UserTable user) {
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
          user.birthDate = pickedDate;
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

  Widget buildCityField(UserTable user) {
    return TextFormField(
      initialValue: user.city,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Город')),
      keyboardType: TextInputType.text,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Введите ваш город';
      //   }
      // },
      onSaved: (value) {
        user.city = value!;
      },
    );
  }

  Widget buildAboutField(UserTable user) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        initialValue: user.aboutSelf,
        decoration: InputDecoration(
          prefixIcon: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 5, top: 15),
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
          user.aboutSelf = value!;
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
  Widget buildPhotoField(UserTable user) {
    return Column(
      children: [
        if (image != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(width: 150, child: user.buildPhotoImage()),
          ),
        ] else ...[
          if (user.photo != 'lib/assets/default.jpg') ...[
            SizedBox(width: 150, child: user.buildPhotoImage()),
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
          style: ElevatedButton.styleFrom(
            //backgroundColor: const Color(0xFF7821E3),
            backgroundColor: const Color(0xFF2160E3),
          ),
          onPressed: () {
            photoAlert(user);
          },
          child: const Text('Выбрать фото', style: TextStyle(fontSize: 16)),
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
        // const SizedBox(
        //   height: 20,
        // ),
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

  Widget buildAdditionalFields(UserTable user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 14,
        ),
        buildDateTimeField(user),
        SizedBox(
          height: 14,
        ),
        buildCityField(user),
        SizedBox(
          height: 14,
        ),
        buildAboutField(user),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }

  Widget buildEmailField(UserTable user) {
    return TextFormField(
      initialValue: user.email,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Email')),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (value) {
        user.email = value!;
      },
    );
  }

  Widget buildContactField(UserTable user) {
    return TextFormField(
      initialValue: user.phone.isEmpty ? "+7" : user.phone,
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
        user.phone = value!;
      },
    );
  }

  Widget buildPasswordField(UserTable user) {
    return TextFormField(
      initialValue: user.password,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Пароль')),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return "Придуймайте пароль";
        }
      },
      onSaved: (value) {
        user.password = value!;
      },
    );
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, UserTable user) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
      user.photo = img != null ? img.path : user.photo;
    });
  }

  //show popup dialog
  void photoAlert(UserTable user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(builder: (context, constraints) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: const Text('Выберите фото'),
              content: Container(
                height: constraints.maxHeight / 3,
                //padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery, user);
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
                        getImage(ImageSource.camera, user);
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
