import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class HomeBestSellers extends StatelessWidget {
  const HomeBestSellers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35,bottom: 15,left: 30),
      alignment: Alignment.centerLeft,
      child: Text("Now Playing",
      style: TextStyle(
        fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 23,
          color: Colors.white
      ),),
    );;
  }
}