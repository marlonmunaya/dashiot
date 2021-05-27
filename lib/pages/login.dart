import 'package:dashiot/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dashiot/providers/user_provider.dart';
import 'package:dashiot/Widget/fondo.dart';

class LoginPage extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override

  String email;
  String password;
  static final formKeysign = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Consumer<UserState>(
            builder: (BuildContext context,UserState value,Widget child){
              if (value.isLoading()) {
                return Container(
                 height: MediaQuery.of(context).size.height*0.5,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            child: Stack(
              children: <Widget>[
                _crearfondo(context),
                _loginform(context),
              ],
            ),
          ),
        )
    );
  }

  _crearfondo(context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        fondo(size.height, context),    
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
            //  Text('ANJOES',
             //     style: Theme.of(context).textTheme.title),
            ],
          ),
        )
      ],
    );
  }

  _loginform(context) {
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Container(
              height: size.height * 0.25,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            margin: EdgeInsets.symmetric(vertical: 20.0),
            width: size.width * 0.85,
            height: 450.0,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ],
                borderRadius: BorderRadius.circular(10.0)),
            child: Form(
              key: formKeysign,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 1.0),
                  Image.asset('lib/src/assets/bee.png',
                    height: 80.0,
                    fit: BoxFit.fitHeight,),
                 // Text('Iniciar Sesión',
                  //  style:Theme.of(context).textTheme.subtitle,),
                  SizedBox(height: 30.0),
                  _crearEmail(context),
                  SizedBox(height: 30.0),
                  _crearPassword(context),
                  SizedBox(height: 30.0),
                  _crearboton(context),
                  SizedBox(height: 10.0),
                  // _crearbotonGoogle(context),
                    
                ],
              ),
            ),
          ),
          //Text('¿Olvidó la contraseña?'),
          FlatButton(
            child: Text('Crear cuenta'),
            onPressed: () {}//=>
              //  Navigator.pushReplacementNamed(context, '/'),
          ),
          SizedBox( height: 100.0)
        ],
      ),
    );
  }

  Widget _crearEmail(context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(
          Icons.alternate_email,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'ejemplo1@ejemplo.com',
        //hintStyle: Theme.of(context).textTheme.subtitle,
        labelText: 'Email3',
        errorText: null,//'dd',
        counterText: null,//'dd',
      ),
      onSaved: (String value) => email = value,
      validator: (value) {
         if (value.length < 5) {
        return 'Ingrese un correo válido';
      } else {
        return null;
      }
      },
    );
  }

  Widget _crearPassword(context) {
    return Container(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).primaryColor,
                ),
                labelText: 'Password',
                counterText: null,//'Password',
                errorText: null//'Password',
              ),
              obscureText: true,
              onSaved: (String value) => password = value,
              validator:(value){
                if (value.length < 6) {
                return 'Contraseña mínimo 6 caractéres';
                } else {
                return null;
                }
              }
            )
        );
  }

  _crearboton(BuildContext context) {

    return RaisedButton(
            child: Container(
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 85.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Text('Ingresar',style:TextStyle(color: Colors.white,fontSize: 18.0),),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
             setState(() {
              if ( !formKeysign.currentState.validate() ) return;
              formKeysign.currentState.save();
              Provider.of<UserState>(context, listen: false).login(email,password,context);
              // Navigator.push(
              //           context,
              //           MaterialPageRoute<String>(
              //             builder: (BuildContext context) =>
              //                 HomeApp(),
              //             fullscreenDialog: true,
              //           ));

            });
            } 
          );
      
  }

  _crearbotonGoogle(BuildContext context) {
    return RaisedButton(
            child: Container(
              width: 250.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Image.asset('lib/src/assets/search.png',
                  height: 40.0,
                  fit: BoxFit.fitHeight,),
                  Text('  Ingresa con google',style: Theme.of(context).textTheme.title,),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Color.fromRGBO(219, 68, 55, 1.0),
            onPressed: () => Provider.of<UserState>(context).login('marlon@munaya.com','marlon',context),
          );    
  }
}
