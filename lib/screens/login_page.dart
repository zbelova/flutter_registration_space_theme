import 'package:flutter/material.dart';
import 'package:flutter_user_profile/screens/profile_page.dart';
import '../data/classes.dart';
import '../data/user_preferences.dart';
import '../widgets/myWidgets.dart';
import 'edit_profile_page.dart';

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

  @override
  void initState() {
    super.initState();
    user = UserPreferences().getUserObject(); //юзер берется из юзер префс
    // correctName = UserPreferences().getUsername();
    // correctPassword = UserPreferences().getUserpassword();
    correctName = user?.email;
    correctPassword = user?.password;
    _remember = UserPreferences().getRememberLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(
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
                            // style: TextStyle(
                            //   fontSize: 24,
                            //   color: Colors.white,
                            //   fontWeight: FontWeight.bold,
                            //   shadows: [
                            //     Shadow(
                            //       color: Colors.black.withOpacity(0.7),
                            //       offset: const Offset(1, 1),
                            //       blurRadius: 3,
                            //     ),
                            //   ],
                            // ),
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
                          SizedBox(
                            height: 10,
                          ),
                          buildRememberField(),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //backgroundColor: const Color(0xFF7821E3),
                                backgroundColor: const Color(0xFF2160E3),
                              ),
                              onPressed: _validateLogin,
                              child: const Text(
                                'Войти',
                                //style: TextStyle(fontFamily: 'Raleway'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: Color(0xFFE3003D),
                              // ),
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                                );
                              },
                              child: const Text('Пройти регистрацию'),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildEmailField() {
    return TextFormField(
        decoration: InputDecoration(
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
        decoration: InputDecoration(
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
              ),
              // style: TextStyle(
              //   color: Colors.white,
              //   // RfontWeight: FontWeight.bold,
              //   fontFamily: "Proxima Nova Rg Regular",
              //   fontSize: 16,
              //   shadows: [
              //     Shadow(
              //       color: Colors.black.withOpacity(0.7),
              //       offset: const Offset(2, 2),
              //       blurRadius: 4,
              //     ),
              //   ],
              // ),
            ),
            value: _remember,
            contentPadding: EdgeInsets.all(0),
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

      if ((name != correctName && password != correctPassword) || (correctName == '' || correctPassword == '')) {
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


