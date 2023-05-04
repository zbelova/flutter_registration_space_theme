//классы пользователя, вопроса, ответа, а также вспомогательные функции, которые используются на многих экранах

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class User {
  String name;
  String phone;
  String email;
  String? password;

  //DateTime birthDate = DateTime.now();
  DateTime? birthDate;
  String city;
  String aboutSelf;
  String photo;

  User({required this.name, this.phone = '', this.email = '', this.password, this.city = '', this.aboutSelf = '', this.photo = 'lib/assets/default.jpg', this.birthDate});

  User.fromJson(Map<String, dynamic> item) //распаковка юзера из json, используется при доставании юзера из юзер префс
      : name = item['name'] ?? '',
        aboutSelf = item['aboutSelf'] ?? '',
        city = item['city'] ?? '',
        email = item['email'] ?? '',
        password = item['password'] ?? '',
        phone = item['phone'] ?? '',
        photo = item['photo'] != '' ? item['photo'] : 'lib/assets/default.jpg',
        birthDate = item['birthDate'] == "null" ? null : DateTime.parse(item['birthDate']);

  Map<String, dynamic> toJson() {
    //запаковка юзера в json
    return {"name": name, "email": email, "phone": phone, "birthDate": birthDate.toString(), "city": city, "aboutSelf": aboutSelf, "photo": photo, "password": password};
  }

  Widget buildPhotoImage() {

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Color(0xff03ecd4), width: 5),
          //color: Colors.lightBlueAccent
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: AspectRatio(
            aspectRatio: 1,
            child: photo=='lib/assets/default.jpg'?Image.asset('lib/assets/default.jpg'):Image.file(
              File(photo),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

  //картинка с бордером через контейнер без ClipRRect
/*
  Widget buildPhotoImage(double width, double height) {
    if (photo == '' || photo == 'lib/assets/default.jpg') {
      return Image.asset('lib/assets/default.jpg');
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.lightBlueAccent,
              width: 5,
            ),
            image: DecorationImage( image:FileImage(File(photo),) )
        ),
      );
    }
  }*/

  String birthDateToString() {
    return DateFormat('dd.MM.yyyy').format(birthDate!);
  }
}
