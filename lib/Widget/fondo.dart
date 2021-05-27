import 'package:flutter/material.dart';

Widget fondo(double size,BuildContext context){
  return  Container(
            height: size,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Theme.of(context).primaryColor,
              Theme.of(context).secondaryHeaderColor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight 
            )));
}