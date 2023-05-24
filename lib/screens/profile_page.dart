//страница профиля пользователя
//есть кнопка редактировать, если это "мой профиль". Изменения сохранятся в объект юзера в префс
//еще должна быть кнопка "Написать", если это чужой профиль, там должен открываться чат
//и еще кнопку "Выйти" надо добавить

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/classes.dart';
import '../data/user_preferences.dart';
import 'edit_profile_page.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          title: const Text('Профиль'),
        ),
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
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortraitEditProfile(context);
            } else {
              return _buildLandscapeEditProfile(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLandscapeEditProfile(BuildContext context) => CupertinoScrollbar(
    child: LayoutBuilder (builder: (context, constraints) { return     ListView(
      children: [


        Padding(
          padding: constraints.maxWidth > 1000?const EdgeInsets.only(top: 15):const EdgeInsets.only(top: 15, left: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(height: 25,),
                    _buildTopImage(),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileTextFieldView("Имя", user.name),
                      if (user.city.isNotEmpty) _buildProfileTextFieldView("Город", user.city),
                      if (user.birthDate != null) _buildProfileTextFieldView("Дата рождения", user.birthDate != null ? DateFormat('dd.MM.yyyy').format(user.birthDate!) : ''),
                      if (user.aboutSelf.isNotEmpty) _buildProfileTextFieldView("О себе", user.aboutSelf),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Column(children: [
                  SizedBox(height: 22,),
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
                      //child: Text("Редактировать"),

                      child: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        UserPreferences().setLoggedIn(false);
                        //UserPreferences().setRememberLoggedIn(false);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false);
                      },
                      //child: Text("Выйти"),
                      child: const Icon(Icons.logout),
                    ),
                  ]
                ],),
              )

            ],
          ),
        ),
      ],
    );})

  );

  Widget _buildPortraitEditProfile(BuildContext context) => ListView(
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
                    //child: Text("Редактировать"),

                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      UserPreferences().setLoggedIn(false);
                      //UserPreferences().setRememberLoggedIn(false);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false);
                    },
                    //child: Text("Выйти"),
                    child: const Icon(Icons.logout),
                  ),
                ]
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopImage(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileTextFieldView("Имя", user.name),
                if (user.city.isNotEmpty) _buildProfileTextFieldView("Город", user.city),
                if (user.birthDate != null) _buildProfileTextFieldView("Дата рождения", user.birthDate != null ? DateFormat('dd.MM.yyyy').format(user.birthDate!) : ''),
                if (user.aboutSelf.isNotEmpty) _buildProfileTextFieldView("О себе", user.aboutSelf),
              ],
            ),
          )
        ],
      );

  Row _buildProfileTextFieldView(String fieldTitle, String fieldValue) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fieldTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff03ecd4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    fieldValue,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  //другой способ через передачу функции
/*
  Widget _buildName() {
    return Column(
      children: [
        Text(
          'Имя',
          style: Theme.of(context).textTheme.bodySmall,
          //style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(user.name)
      ],
    );
  }

  Widget _buildDesc() => Text(
        user.aboutSelf,
        softWrap: true,
        style: const TextStyle(fontSize: 16),
      );

  Row _buildProfileRow(Widget field) {
    return Row(
      children: [
        Expanded(child: field),
      ],
    );
  }*/

  Widget _buildTopImage() => SizedBox(
        width: 200,
        child: user.buildPhotoImage(),
      );
}
