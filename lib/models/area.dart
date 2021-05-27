// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class Area{
  String area;
  List<String> subarea = <String>[];
  List<Listsubareas> subareas;
  bool isExpanded = false;

  Area({this.isExpanded,this.area, this.subarea, this.subareas});

}
class Listsubareas{
  final String subarea;
  final List<Config> conf;
  Listsubareas({this.conf,this.subarea});
}

class Config{
  final String label;
  final String topic;
  final double min;
  final double max;
   double data;
  final String unit;
  final mqtt.MqttQos qos;

  Config({this.label,this.min, this.max, this.qos, this.unit,this.topic,this.data});

}


class DevicesModel2{
  
  final double var1valor;
  final double var2valor;
  final double var3valor;
  final double var4valor;
  final double var5valor;
  final double var6valor;
  final double var7valor;
  final double var8valor;
  final double lat;
  final double lng;
  final String time;
  final DocumentReference reference;

  DevicesModel2.fromMap(Map<String, dynamic> map, {this.reference})
      : 
        var1valor = map['var1valor'],
        var2valor = map['var2valor'],
        var3valor = map['var3valor'],
        var4valor = map['var4valor'],
        var5valor = map['var5valor'],
        var6valor = map['var6valor'],
        var7valor = map['var7valor'],
        var8valor = map['var8valor'],
        lat = map['lat'],
        lng = map['lng'],
        time = map['fecha']+' - '+map['hora']
        ;

  DevicesModel2.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);


  String toString() => "$lat;$lng;$var1valor;$var2valor;$var3valor;$var4valor;$var5valor;$var6valor;$var7valor;$var8valor;$time\n";
}
