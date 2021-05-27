import 'package:dashiot/providers/user_provider.dart';
import 'package:dashiot/pages/login.dart';
import 'package:dashiot/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyAppmain());

class MyAppmain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
      ],
      child: Consumer<UserState>(
        builder: (context, userstate , _) {
          return  MaterialApp(
            title: "Dashboard",
            theme: new ThemeData(
        primarySwatch: Colors.orange, // Your app THEME-COLOR
      ),
            debugShowCheckedModeBanner: false,
            routes: {
            '/'       :(BuildContext context){
                      UserState state= Provider.of<UserState>(context, listen: false);
                      
                      if (state.isLoggedIn()) {
                        return HomeApp();
                      } else {
                        return  LoginPage();
                      }
                      },
        'login'      :(BuildContext context)=>LoginPage(),
      },
          );
        },
      ),
    );
  }
}
