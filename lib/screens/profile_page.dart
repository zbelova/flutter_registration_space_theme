//страница профиля пользователя
//есть кнопка редактировать, если это "мой профиль". Изменения сохранятся в объект юзера в префс
//еще должна быть кнопка "Написать", если это чужой профиль, там должен открываться чат
//и еще кнопку "Выйти" надо добавить

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homework9_2/screens/edit_profile_page.dart';

import '../data/classes.dart';
import '../data/user_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  User? user;
  bool myPage = false;

  ProfilePage({super.key, this.user}) {
    myPage = user != null ? false : true;
    user = user ?? UserPreferences().getUserObject(); //если не передан пользователь в качестве аргумента, то открывается страница текущего пользователя приложения
  }

  @override
  Widget build(BuildContext context) {
    return PersonWidget(user: user!, myPage: myPage);
  }
}

class PersonWidget extends StatefulWidget {
  User user;
  bool myPage;

  PersonWidget({super.key, required this.user, required this.myPage});

  @override
  State<PersonWidget> createState() => _PersonWidgetState(user, myPage);
}

class _PersonWidgetState extends State<PersonWidget> {
  User user;
  bool myPage;

  _PersonWidgetState(this.user, this.myPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Профиль'),
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
        child: _buildMainColumn(context),
      ),
    );
  }

  Widget _buildMainColumn(BuildContext context) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (myPage) ...[
                  ElevatedButton(
                    onPressed: () async {
                      final data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                      setState(() {
                        user = data;
                      });
                    },
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const EditProfilePage(),
                    //     ),
                    //   );
                    //   //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ProfileScreen()), (Route<dynamic> route) => false);
                    // },
                    child: Text("Редактировать"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      UserPreferences().setLoggedIn(false);
                      //UserPreferences().setRememberLoggedIn(false);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                    },
                    child: Text("Выйти"),
                  ),
                ]
              ],
            ),
          ),
          _buildTopImage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildName(),
              _buildDesc(),
            ],
          )
        ],
      );

  Widget _buildName() {
    return Column(
      children: [
        Text(
          'Имя',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
        Text(user.name)
      ],
    );
  }

  Widget _buildTopImage() => Card(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      elevation: 5,
      child: ClipRRect(child: AspectRatio(aspectRatio: 1, child: user.buildPhotoImage())));

  Widget _buildDesc() => Text(
        user.aboutSelf,
        softWrap: true,
        style: const TextStyle(fontSize: 16),
      );
}
