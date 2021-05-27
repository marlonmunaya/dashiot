import 'package:flutter/material.dart';
import 'package:dashiot/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
Widget header({context,setting}){
  // FirebaseUser user = Provider.of<UserState>(context).currentUser(); 
  // TODO:habilitar
  return UserAccountsDrawerHeader(
        accountName: Text('Cliente Monitor',style: TextStyle(color:Colors.white),),
        accountEmail: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text('${user.email}'),
            Text('user@email.com',style: TextStyle(color:Colors.white),),
            SizedBox(width: 0.0,),
            Material(
              color: Theme.of(context).primaryColor,
              child: IconButton(
                focusNode: FocusNode(),
                // padding: EdgeInsets.all(10.0),
                // highlightColor: Colors.red,
                icon:Icon(Icons.settings,color: Colors.white,),
                // splashColor: Colors.red,
                onPressed: setting,
                ),
            ),
            SizedBox(width: 0.0,)
          ],
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          // backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638__340.png'),
          child: Image.network(
            'https://www.acmecia.com/images/acmi-logo.png',
            height: 30,
            fit: BoxFit.fill,
            ),
          
          // backgroundImage: NetworkImage(''),
        ),
      );
}