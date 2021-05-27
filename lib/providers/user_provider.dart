
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:dashiot/models/area.dart';
import 'package:firebase_auth/firebase_auth.dart';


///Librerias para la conexion MQTT
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

///Librerias para la conexion DB
import 'package:cloud_firestore/cloud_firestore.dart';
///API prueba/////
import '../services/api.dart';

class UserState with ChangeNotifier {
  //// MQTT Client - Instancias////
  MqttBrowserClient _client;
  MqttConnectionState _connectionState;
  MqttClientTopicFilter _topicFilter;
  Set<String> _topics = Set<String>();
  IconData _connectionStateIcon=Icons.cloud_off;
  MqttBrowserClient get client => _client;
  MqttConnectionState get connectionState => _connectionState;
  MqttClientTopicFilter get topicFilter => _topicFilter;
  Set<String> get topics => _topics;
  IconData get connectionStateIcon => _connectionStateIcon;
  //// Configuration MQTT Client ////
  TextEditingController _brokerController = TextEditingController(text: 'ws://test.mosquitto.org');
  TextEditingController _portController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwdController = TextEditingController();
  TextEditingController _identifierController = TextEditingController();
  TextEditingController get brokerController => _brokerController;
  TextEditingController get portController => _portController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwdController => _passwdController;
  TextEditingController get identifierController => _identifierController;

  //// Estado de Autenticación///
  bool _loggedIn = true;
  bool _loading = false;
  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  /////line /////
  DateTime _time;
  Map<String, num> _measures;
  DateTime get time => _time;
  Map<String, num> get measures => _measures;
  //// Autenticacion via email////
  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  FirebaseUser currentUser() => _user;
  //////Area/////////////
  List<Area> _area = [];
  List<Area> _areafront = [Area(subareas:[Listsubareas(conf:[Config(label:'Emulate',max: 100.0,min: 10.0,data:22.2,unit: '°C',qos: MqttQos.atLeastOnce)])])];
  List<DevicesModel2> _model1;
  List<DevicesModel2> get model1 => _model1;
  List<DevicesModel2> _model2;
List<DevicesModel2> get model2 => _model2;
  String _tocsv;
  String get tocsv => _tocsv;

  String _namearea;
  int _index1;
  int _index2;
  double _sellist;
  List<Config> _dashboard ;
  List<Area> get areas => _area;
  String get namearea => _namearea;
  int get index1 => _index1;
  int get index2 => _index2;
  double get sellist => _sellist;
  List<Config> get dashboard => (_index2==null||_index1==null)? _areafront[0].subareas[0].conf: _dashboard ;
  /// Data Base Instancia ////
  Firestore _db = Firestore.instance ;
////////Agrega los nombre de subarea
  void addsubareas(String area) {
    _area[_index1].subareas.add(
      Listsubareas(
        subarea:area,
          conf: []
      )   
    );
    notifyListeners();
  }

  void removesubarea(int i, int i2) {
    _area[i].subareas.removeAt(i2);
    notifyListeners();
  }
  void setindexsubarea(int i) {
    _index1 = i;
    notifyListeners();
  }
  void setindexs(int i,int i2) {
    _index1 = i;
    _index2 = i2;
    notifyListeners();
  }
  void setconfig(List<Config> config) {
    if (config.isEmpty) {
    _dashboard = _areafront[0].subareas[0].conf;
    // notifyListeners();
    } else {
    _dashboard = config;
    }
    notifyListeners();
  }

////////Agrega los nombre de area
  void addarea(String area) {
    _area.add(
      Area(area: area, subarea: [], isExpanded: false,subareas:[]),
    );
    notifyListeners();
  }

  void removearea(int i) {
    _area.removeAt(i);
    notifyListeners();
  }

  void expandarea(int i) {
    _area[i].isExpanded = !_area[i].isExpanded;
    // _area.removeAt(i);
    notifyListeners();
  }

  ///Seleccionar el ListTile del Drawer
  void selectlist(double i) {
    _sellist = i;
    notifyListeners();
  }
  /// Guardar configuración de widgets
  void savesetting(String _topic,String _unit,String _label,double _min,double _max){
      _area[_index1].subareas[_index2].conf.add(
      Config(
        topic:_topic,
        unit: _unit,
        label: _label,
        min: _min,
        max: _max,
        data: 33.0,
        qos: MqttQos.atLeastOnce  
      )
    );
    print('guardado');   
    notifyListeners();  
  }
////////User Login
  void login(String email, String password, cont) async {
    _loading = true;
    notifyListeners();
    _user = await _handleSignIn(email, password, cont);
    _loading = false;
    if (_user != null && _auth.currentUser!=null) {
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = true;
      // TODO: Cambiar a false
      notifyListeners();
    }
  }

  void logout() {
    _auth.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  void seldatum(measures,time){
      _measures = measures;
      _time = time;
      notifyListeners();
      print(time.toString());
      print(measures.toString());
  }

  Future<FirebaseUser> _handleSignIn(String email, String password, cont) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      _user = await _auth.currentUser();
      assert(user.uid == _user.uid);
      return user;
    } catch (e) {
      print(e);
      showDialog(
          context: cont,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void connect(broker,port,clientIdentifier,username,passwd) async {
    print(path.current);
    _client = MqttBrowserClient(broker, '');
    _client.logging(on: false);
    _client.port = port;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.pongCallback = pong;
    
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .keepAliveFor(20)  // Must agree with the keep alive set above or not set
        .withWillTopic('willtopic')
        .withWillMessage('my will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('MQTT client connecting....');
    _client.connectionMessage = connMess;
     notifyListeners();
    try {
      //TODO:falta habilitar conectarse con username y passwd
      // await client.connect(username, passwd);
      await _client.connect();
    } on Exception catch (e) {
      print(e);
      disconnect();
    }
    /// Verificar si estas conectado
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      print('MQTT client connected');
        _connectionState = _client.connectionStatus.state;
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionStatus.state}');
      _client.disconnect();
    }
    notifyListeners();
    stateicon();
    
    _topicFilter = MqttClientTopicFilter('$clientIdentifier/#', _client.updates);
    _topicFilter.updates.listen(_onFilter); 
    notifyListeners();
  }
  void stateicon() {

     switch (_client?.connectionStatus?.state) {
      case MqttConnectionState.connected:
        _connectionStateIcon = Icons.cloud_done;
        break;
      case MqttConnectionState.disconnected:
        _connectionStateIcon = Icons.cloud_off;
        break;
      case MqttConnectionState.connecting:
        _connectionStateIcon = Icons.cloud_upload;
        break;
      case MqttConnectionState.disconnecting:
        _connectionStateIcon = Icons.cloud_download;
        break;
      case MqttConnectionState.faulted:
        _connectionStateIcon = Icons.error;
        break;
      default:
        _connectionStateIcon = Icons.cloud_off;
    }
    notifyListeners();
  }
  void _onFilter(List<MqttReceivedMessage<MqttMessage>> c){
    var indicador = 0;
    final MqttPublishMessage recMess = c[0].payload;
    final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print( 'Filtered topic is <${c[0].topic}>, payload is <-- $pt -->');
    print(c.length);
    for(var prop in _dashboard){
      if (prop.topic==c[0].topic){
            prop.data= double.parse(pt);
      }
    } 
    print(indicador);
    notifyListeners();
  }
  void disconnect() {
    _client.disconnect();
    onDisconnected();
    notifyListeners();
  }
  void onDisconnected() {
    _topics.clear();
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.disconnectionOrigin ==  MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    print('MQTT client disconnected');
    notifyListeners();
  }
  void pong() {
    print('Ping response client callback invoked');
  }
  void onConnected() {
    print(  'OnConnected client callback - Client connection was sucessful');
  }
  void subscribeToTopic(String topic) {
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
        if (_topics.add(topic.trim())) {
          print('Subscribing to ${topic.trim()}');
          _client.subscribe(topic, MqttQos.exactlyOnce);
          // TODO:Agregar aqui los datos
        }
      // print(_messages.toList());
    }
    notifyListeners();
  }
  void unsubscribeFromTopic(String topic) {
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
        if (_topics.remove(topic.trim())) {
          print('Unsubscribing from ${topic.trim()}');
          _client.unsubscribe(topic);
        }
        // _messages.removeWhere((i) => i.topic==topic);
    }
    notifyListeners();
  }

  Stream<QuerySnapshot> connectDB(){

     var ref =_db.collection('users');
     return ref.snapshots().map((querySnapshot) {});
              
  }

  Api _api = Api('users');




  void getcollectionacme (start,end) async {
    print('obteniento dato ACME');
    final snapshot = await Firestore.instance.collection('acme')
    .where('fecha2',isGreaterThanOrEqualTo: start)
    .where('fecha2',isLessThanOrEqualTo:end)
    .orderBy('fecha2',descending: true)
    .limit(50)
    .getDocuments();
    _model1 = snapshot.documents.map((e) =>DevicesModel2.fromSnapshot(e)).toList();
    print('obtenido acme');
    notifyListeners();

    final snapshot1 = await Firestore.instance.collection('acme')
    .where('fecha2',isGreaterThanOrEqualTo: start)
    .where('fecha2',isLessThanOrEqualTo:end)
    .orderBy('fecha2',descending: true)
    // .limit(50)
    .getDocuments();
    _model2 = snapshot1.documents.map((e) =>DevicesModel2.fromSnapshot(e)).toList();
    print('obtenido acme');
    notifyListeners();
}
  

  void getdatatocsv () async {
    
    _tocsv  =_model2.toString();
    print('obtenido data to csv');
    notifyListeners();
 } 


}




