import 'package:flutter/material.dart';
import 'package:homework9_2/globals/theme/app_theme.dart';
import 'package:homework9_2/screens/login_page.dart';
import 'package:homework9_2/screens/profile_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



import 'data/classes.dart';
import 'data/user_preferences.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  //User? user = UserPreferences().getUserObject();
   //await UserPreferences().clear(); //если раскомментить эти строчки, то сбросятся все сохраненные данные пользователя - если надо для тестов
  runApp(RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  RegistrationApp({super.key});
  final bool goToMainPage = UserPreferences().getRememberLoggedIn();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
 debugShowCheckedModeBanner: false,
      title: 'Регистрация пользователя',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: SpaceTheme,
      localizationsDelegates: const [ //локализация нужна, чтобы в виджете календаря в поле дата рождения был русифицированный календарь
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ru'),
      home: buildHomePage(),
    );
  }

  Widget buildHomePage() {
    if (goToMainPage) {
      UserPreferences().setLoggedIn(true);
      return ProfilePage();
    } else {
      return LoginPage();
    }
  }
}