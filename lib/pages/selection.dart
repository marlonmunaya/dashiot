
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;
import 'package:provider/provider.dart';
import 'package:dashiot/providers/user_provider.dart';
import 'package:dashiot/Widget/gaugechart.dart';

class SelectionPage extends StatefulWidget {

  @override
  _SendMessageDialogState createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SelectionPage> {
  PageController _pageController = PageController(initialPage: 0);

  String topic;
  String unit;
  String label;
  double min =0.0;
  double max = 100.0;
  final formKeyselection = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var userstate = Provider.of<UserState>(context);
    IconData connectionStateIcon = userstate.connectionStateIcon;

    void navigationTapped() {
      _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(connectionStateIcon),
            SizedBox(width: 8.0),
            Text('Selection'),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          widgetpage(navigationTapped),
          parampage(userstate),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }),
    );
  }


  Widget widgetpage(navigationTapped) {
    return SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              InkWell(
                  onLongPress:(){ navigationTapped();},
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: gaugechart('etiqueta', '°C', 10.0, -5.0, 100.0),
                  )),
              InkWell(
                  onLongPress: (){ navigationTapped();},
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: gaugechart('etiqueta', '°C', 10.0, -5.0, 100.0),
                  )),
              InkWell(
                  onLongPress: () { navigationTapped();},
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: gaugechart('etiqueta', '°C', 10.0, -5.0, 100.0),
                  )),
              InkWell(
                  onLongPress: () { navigationTapped();},
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: gaugechart('etiqueta', '°C', 10.0, -5.0, 100.0),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget parampage(userstate) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          child: Form(
              key: formKeyselection,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: 'Tópico',
                  onSaved: (String value)=> topic=value,
                  validator: (value)=>value.length<3?'Mínimo 03 caracteres':null,
                  decoration: InputDecoration(
                    hintText: 'Topic',
                    icon: Icon(
                      Icons.import_export,
                      color: Theme.of(context).primaryColor,
                    ),                 
                  ),
                ),
                 Row(children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: '°C',
                      onSaved: (String value)=> unit=value,
                      validator: (value)=>value.length<1?'Mínimo 01 caracter':null,
                      decoration: InputDecoration(
                        hintText: 'Unit',
                        icon: Icon(
                          Icons.polymer,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width:150)
                ]),
                TextFormField(
                  initialValue: 'Sensor A',
                  onSaved: (String value)=> label=value,
                  validator: (value)=>value.length<3?'Mínimo 01 caracter':null,
                  decoration: InputDecoration(
                    hintText: 'Label',
                    icon: Icon(
                      Icons.label,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                  initialValue: '0.0',
                  onSaved: (String value)=> min=double.parse(value),
                  validator: (value)=>value.length<3?'Mínimo 01 caracter':null,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'min',  
                        hintText: 'min',
                        icon: Icon(
                          Icons.minimize,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: '100.0',
                      onSaved: (String value)=> max=double.parse(value),
                      validator: (value)=>value.length<3?'Mínimo 01 caracter':null,
                      decoration: InputDecoration(
                        labelText: 'max',
                        hintText: 'max',
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                ]),
                SizedBox(height: 10.0,),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: <Widget>[
                      Text('Save'),
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  onPressed: (){
                    setState(() {                  
                      print('guardando');
                      if(!formKeyselection.currentState.validate()) return;
                      formKeyselection.currentState.save();
                      print(topic);
                      Provider.of<UserState>(context, listen: false).savesetting(topic,unit,label,min,max);
                      Provider.of<UserState>(context, listen: false).subscribeToTopic(topic);
                      Navigator.pop(context);
                    });
                  }, 
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
