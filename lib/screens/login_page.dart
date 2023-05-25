import 'package:flutter/material.dart';
import 'package:flutter_user_profile/data/user_table.dart';
import 'package:flutter_user_profile/screens/profile_page.dart';
import '../data/classes.dart';
import '../data/user_preferences.dart';
import '../data/users_repo.dart';
import '../widgets/myWidgets.dart';
import 'edit_profile_page.dart';
import 'package:flutter_user_profile/main.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String password = '';
  String? correctName;
  String? correctPassword;
  User? user;
  bool? _remember;


  //final _usersRepo = UsersRepo();
  //late UserTable _user1;
  //late UserTable _users;
  //late var user1 = _usersRepo.getById(1);

  @override
  void initState() {
    super.initState();

    user = UserPreferences().getUserObject(); //юзер берется из юзер префс
    correctName = user?.email;
    correctPassword = user?.password;
    _remember = UserPreferences().getRememberLoggedIn();
    //_usersRepo.initDB().whenComplete(() => setState(() => _users = _usersRepo.getById(1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLoginPage(context);
          } else {
            return _buildLandscapeLoginPage(context);
          }
        },
      ),
    );
  }

  Widget _buildPortraitLoginPage(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'lib/assets/bg1.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Вход в приложение',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildEmailField(),
                      const SizedBox(
                        height: 14,
                      ),
                      biuldPasswordField(),
                      const SizedBox(
                        height: 10,
                      ),
                      buildRememberField(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //backgroundColor: const Color(0xFF7821E3),
                            backgroundColor: const Color(0xFF2160E3),
                          ),
                          onPressed: _validateLogin,
                          child: const Text(
                            'Войти',
                              style: TextStyle(fontSize: 16)
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: Color(0xFFE3003D),
                          // ),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const EditProfilePage()),
                            );
                          },
                          child: const Text('Пройти регистрацию', style: TextStyle(fontSize: 16)),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLoginPage(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'lib/assets/bg1.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(left:80, top: constraints.maxHeight/5, right:80,  ),
                child: Form(
                    key: formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Вход в приложение',
                                style: constraints.maxWidth <900?Theme.of(context).textTheme.displayMedium:Theme.of(context).textTheme.displayLarge,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              buildEmailField(),
                              const SizedBox(
                                height: 14,
                              ),
                              biuldPasswordField(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildRememberField(),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Expanded(

                          child: Padding(
                            padding: EdgeInsets.only(left: constraints.maxWidth/20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 50,),
                              //  Spacer(),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      //backgroundColor: const Color(0xFF7821E3),
                                      backgroundColor: const Color(0xFF2160E3),
                                    ),
                                    onPressed: _validateLogin,
                                    child: const Text(
                                      'Войти',
                                         style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    // style: ElevatedButton.styleFrom(
                                    //   backgroundColor: Color(0xFFE3003D),
                                    // ),
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                                      );
                                    },
                                    child: const Text('Пройти регистрацию', style: TextStyle(fontSize: 18),),
                                  ),
                                ),
                               // Spacer()
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ));
    });
  }

  Widget buildEmailField() {
    return TextFormField(
        decoration: const InputDecoration(
          //labelText: prefix,
          //prefixText: prefix + ':   ',
          prefixIcon: PrefixWidget('Email'),
        ),

        //style: Theme.of(context).textTheme.titleMedium,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Введите ваш email';
          }
          return null;
        },
        onChanged: (name) => setState(() => this.name = name));
    // return buildTextFormField(
    //   'Email',
    //   (value) {
    //     if (value!.isEmpty) {
    //       return 'Введите ваш email';
    //     }
    //     return null;
    //   },
    // );
  }

  Widget biuldPasswordField() {
    return TextFormField(
        decoration: const InputDecoration(
          //labelText: prefix,
          //prefixText: prefix + ':   ',
          prefixIcon: PrefixWidget('Пароль'),
        ),
        // cursorColor: Colors.red,
        // cursorRadius: Radius.circular(16.0),
        // cursorWidth: 8.0,
        // keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Введите пароль для входа';
          }
        },
        onChanged: (password) => setState(() => this.password = password));
  }

  Widget buildRememberField() {
    return SizedBox(
      width: 220,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        child: CheckboxListTile(
            title: Text(
              'Запомнить пароль',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(2, 2),
                    blurRadius: 1,
                  ),
                ],
                fontSize: 18,
              ),

            ),
            value: _remember,
            contentPadding: const EdgeInsets.all(0),
            onChanged: (bool? value) {
              setState(() => _remember = value!);
            }),
      ),
    );
  }

  void _validateLogin() {
    if (formKey.currentState!.validate()) {
      Color color = Colors.red;
      String text;

      if (name != correctName || password != correctPassword ) {
        text = 'Пароль или email не совпадают';
      } else {
        text = 'Идентификация пройдена';
        color = Colors.green;
        UserPreferences().setLoggedIn(true);
        UserPreferences().setRememberLoggedIn(_remember!);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ProfilePage()),
          (Route<dynamic> route) => false,
        );
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
        ),
      );
    }
  }
}

// TextFormField buildTextFormField(String prefix, String? Function(String?) validatorFunc) {
//   return TextFormField(
//       decoration: InputDecoration(
//         //labelText: prefix,
//         //prefixText: prefix + ':   ',
//           prefixIcon: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 10),
//                 child: Text(
//                   "$prefix:".toUpperCase(),
//                 ),
//               ),
//             ],
//           )),
//
//       //style: Theme.of(context).textTheme.titleMedium,
//       keyboardType: TextInputType.emailAddress,
//       validator: validatorFunc,
//       onChanged: (name) => setState(() => this.name = name));
// }
