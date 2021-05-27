import 'package:dashiot/Widget/drawer_area.dart';

import 'package:dashiot/Widget/linechart.dart';
import 'package:dashiot/Widget/tabla.dart';
import 'package:dashiot/pages/selection.dart';
import 'package:dashiot/providers/user_provider.dart';
import 'package:dashiot/models/area.dart';
import 'package:dashiot/pages/setting.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:html' as html;

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class HomeApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeApp> {
  MqttConnectionState connectionState;
  String namearea;
  String namesubarea;
  // List<DevicesModel> products;

  final formKeyarea = GlobalKey<FormState>();
  // List<DevicesModel> us_data = [];
  List<DevicesModel2> datos = [];
  int data = 0;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime _endDate = DateTime.now();

  // List<charts.Series<DevicesModel1, DateTime>> _createSampleData(
      // List<DevicesModel1> data) {
    // final us_data = data;
    // return [
      // charts.Series<DevicesModel, DateTime>(
        // id: 'Hopper 1',
        // domainFn: (DevicesModel sales, _) => sales.time,
        // measureFn: (DevicesModel sales, _) => sales.sales,
        // data: us_data,
        // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      // ),
      // charts.Series<DevicesModel, DateTime>(
        // id: 'Hopper 2',
        // domainFn: (DevicesModel sales, _) => sales.time,
        // measureFn: (DevicesModel sales, _) => sales.var2valor,
        // data: us_data,
        // colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      // ),
    // ];
  // }

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: new DateTime(DateTime.now().year - 5),
        lastDate: new DateTime(DateTime.now().year + 5));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0].add(Duration(hours: 23, minutes:59,seconds:59));
        _endDate = picked[1].add(Duration(hours: 23, minutes:59,seconds:59));
        print(_startDate);
        print(_endDate);
       Provider.of<UserState>(context, listen: false).getcollectionacme(_startDate,_endDate);
      });
    }
  }

  @override
  void initState() {
    Provider.of<UserState>(context, listen: false).getcollectionacme(_startDate,_endDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserState userstate = Provider.of<UserState>(context);
    IconData icono = userstate.connectionStateIcon;
    var lista = userstate.areas;

    return Scaffold(
      
      drawer: drawerwidget(
        context: context,
        nombrearea: (String value) => namearea = value,
        nombresubarea: (String value) => namesubarea = value,
        formkey: formKeyarea,
        listarea: lista,
        setting: null,
        //  () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute<String>(
        //         builder: (BuildContext context) => SettingPage(),
        //         fullscreenDialog: true,
        //       ));
        // },
        submit: () async {
          setState(() {
            if (!formKeyarea.currentState.validate()) return;
            formKeyarea.currentState.save();
            Provider.of<UserState>(context, listen: false).addarea(namearea);
            print(userstate.areas.toString());
            Navigator.of(context).pop();
          });
        },
        submit2: () async {
          setState(() {
            if (!formKeyarea.currentState.validate()) return;
            formKeyarea.currentState.save();
            Provider.of<UserState>(context, listen: false)
                .addsubareas(namesubarea);
            print(userstate.areas.toString());
            Navigator.of(context).pop();
          });
        },
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Dashboard',style: TextStyle(color:Colors.white),),
            SizedBox(width: 8.0),
            Icon(Icons.cloud_done,color: Colors.white,),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          child: Icon(Icons.update,color: Colors.white,),
          onPressed: () async {
            setState(() {
              data++;
              print(data.toString());
              print("Agregando");
              // print(us_data);
              // Provider.of<UserState>(context, listen: false).getcollectionacme(_startDate,_endDate);
              Provider.of<UserState>(context, listen: false).getdatatocsv();
              String datocsv = userstate.tocsv.replaceAll(',','');
              String datocsv1 = datocsv.replaceAll('[','');
              String datocsv2 = datocsv1.replaceAll(']','');
              final blob = html.Blob([datocsv2],"text/plain","transparent");
              final url = html.Url.createObjectUrlFromBlob(blob);
              final anchor = html.document.createElement('a') as html.AnchorElement;
              // as html.AnchorElement
                anchor.href = url;
                anchor.style.display = 'none';
                anchor.download = '$_endDate.csv';
              html.document.body.children.add(anchor);
              // download
              anchor.click();
              // cleanup
              html.document.body.children.remove(anchor);
              html.Url.revokeObjectUrl(url);
            });
          },
        );
      }),
      body: PageView(
        children: <Widget>[
          _buildMessagesPage(userstate, context),
        ],
      ),
    );
  }

  Widget _buildMessagesPage(userstate, BuildContext context) {
    List<DevicesModel2> modelo = userstate.model1;
    if (modelo != null) {
      datos = modelo;
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: RaisedButton.icon(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  icon: Icon(Icons.calendar_today),
                  label: Text("Select Dates"),
                  onPressed: () async {
                    await displayDateRangePicker(context);
                  },
                ),
              ),
              Flexible(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "Start Date: ${DateFormat('dd/MM/yyyy - kk:mm').format(_startDate).toString()}"),
                  ),
                ),
              ),
              Flexible(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "End Date: ${DateFormat('dd/MM/yyyy - kk:mm').format(_endDate).toString()}"),
                  ),
                ),
              ),
            ],
          ),
          // SelectionCallbackExample(_createSampleData(us_data),
          //     animate: true
          // ),
          // tabledataHopper(model),
          tabledataMaquinas(datos),
          // _data(datos)
        ],
      ),
    );
  }

  Widget _data(List<DevicesModel2> devicemodel) {
    return devicemodel == null
        ? CircularProgressIndicator()
        : Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('s'),
                ],
              ),
              Column(
                children: devicemodel
                    .map(
                      (d) => Column(
                        children: <Widget>[
                          Text(d.reference.documentID + ' - ' + d.var1valor.toString()),
                          // Text(d.time.toString())
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          );
  }
 
}
