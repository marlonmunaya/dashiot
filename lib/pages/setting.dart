import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:dashiot/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {

  const SettingPage({Key key}) : super(key: key);

  @override
  _SendMessageDialogState createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SettingPage> {

  String titleBar         = 'MQTT';
  String broker           = 'test.mosquitto.org';
  int port                = 8080;
  String username         = 'vxzjaxrh';
  String passwd           = 'rXJI6ulQjjaJ';
  String clientIdentifier = 'lamhx';

  bool switchControl = false;

  @override
  Widget build(BuildContext context) {
    final userstate = Provider.of<UserState>(context);
    final client = userstate.client; 
    final _broker= userstate.brokerController; 
    final _port= userstate.portController; 
    final _identifier= userstate.identifierController; 
    final _user= userstate.usernameController; 
    final _passwd= userstate.passwdController; 
    IconData connectionStateIcon= userstate.connectionStateIcon; 

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(connectionStateIcon),
              SizedBox( width: 8.0),
              Text('Setting'),
            ],
          ),
        ),
        body: PageView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _broker,
                        decoration: InputDecoration(
                          hintText: 'Input broker',
                          icon: Icon(
                            Icons.cloud,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _port,
                        decoration: InputDecoration(
                          hintText: 'Port',
                          icon: Icon(
                            Icons.compare_arrows,
                            color: Theme.of(context).primaryColor,
                          ), 
                        ),
                      ),
                      TextField(
                        controller: _identifier,
                        decoration: InputDecoration(
                          hintText: 'Client Identifier',
                          icon: Icon(
                            Icons.face,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                           Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text('Autenticacción'),
                          Switch(
                            value: switchControl, 
                            onChanged: toggleSwitch),
                        ],
                      ),
                      switchControl==false ? Container(height: 97.0,):
                      Column(
                        children: <Widget>[
                          TextField(
                            controller: _user,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              icon: Icon(
                                Icons.account_circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _passwd,
                            decoration: InputDecoration(
                              hintText: 'Passwd',
                              icon: Icon(
                                Icons.grain,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Text( _broker.value.text + ':' + _port.value.text.toString(),
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(width: 8.0),
                // Icon(connectionStateIcon),
            SizedBox(height: 8.0),
            RaisedButton(
              child: Text(client?.connectionStatus?.state ==
                      MqttConnectionState.connected
                  ? 'Disconnect'
                  : 'Connect'),
              onPressed: () {
                if (_broker.value.text.isNotEmpty) {
                  broker = _broker.value.text;
                }

                port = int.tryParse(_port.value.text);
                if (port == null) {
                  port = 8080;
                }
                if (_user.value.text.isNotEmpty) {
                  username = _user.value.text;
                }
                if (_passwd.value.text.isNotEmpty) {
                  passwd = _passwd.value.text;
                }

                clientIdentifier = _identifier.value.text;
                if (clientIdentifier.isEmpty) {
                  var random = new Random();
                  clientIdentifier = 'lamhx_' + random.nextInt(100).toString();
                }

                if (client?.connectionStatus?.state ==
                    MqttConnectionState.connected) {
                  Provider.of<UserState>(context, listen: false).disconnect();    
                  print('desconectar');
                } else {
                  Provider.of<UserState>(context, listen: false).connect(broker,port,clientIdentifier,username,passwd);    
                  print('conectar');
                }
              },
            ),
              ],
            ),
          ],
        ));
  }

void toggleSwitch(bool value) {
 
        setState(() {
          switchControl =! switchControl;
        });
  }
}