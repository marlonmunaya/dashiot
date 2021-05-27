
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dashiot/Widget/header.dart';
import 'package:dashiot/models/area.dart';
import 'package:dashiot/providers/user_provider.dart';


Widget drawerwidget(
    {BuildContext context,
    List<Area> listarea,
    Function nombrearea,
    Function nombresubarea,
    formkey,
    submit,
    submit2,
    setting
    }) {
  return Drawer(
    
    child: SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  header(
                    context:context,
                    setting: setting
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Listado de Areas:'),
                          _botonAgregar(context, nombrearea, formkey, submit),
                        ],
                      )),
                  _buildList(context, listarea, nombresubarea, formkey, submit2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildList(BuildContext context, List<Area> listarea, nombresubarea,
    formkey, submit2) {
  return Padding(
      padding: EdgeInsets.only(left:5.0,right: 5.0),
      child: Column(children: <Widget>[
      ExpansionPanelList(
        key: UniqueKey(),
        expansionCallback: (int index, bool isExpanded) {
          Provider.of<UserState>(context, listen: false).expandarea(index);
        },
        children: listarea.map((Area data) {
          var indexes = listarea.indexOf(data);
          return _buildListItem(context, data, indexes, nombresubarea, formkey, submit2);
        }).toList(),
      ),
    ]),
  );
}

ExpansionPanel _buildListItem(BuildContext context, Area data, int index1,
    nombresubarea, formkey, submit2) {
  final String sub = "Sub-area";
  return ExpansionPanel(
    headerBuilder: (BuildContext context, bool isExpanded) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
        onDismissed: (value) {
          try {
            Provider.of<UserState>(context, listen: false).removearea(index1);
          } catch (e) {
            print('error es : ${e.toString()}');
          }
        },
        child: ListTile(
          title: Text(
            data.area,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.mode_edit),
                tooltip: 'Editar el area',
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Agregar un sub-area',
                onPressed: () {
                  Provider.of<UserState>(context, listen: false)
                      .setindexsubarea(index1);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) =>
                          alert(context, nombresubarea, formkey, submit2, sub));
                },
              ),
            ],
          ),
        ),
      );
    },
    isExpanded: data.isExpanded,
    body: Column(
      children: data.subareas.map((Listsubareas sub) {
      var index2 = data.subareas.indexOf(sub);
      double sel =  Provider.of<UserState>(context).sellist;
      return Dismissible(
         key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
        onDismissed: (value) {
          try {
            Provider.of<UserState>(context, listen: false).removesubarea(index1,index2);
          } catch (e) {
            print('error es : ${e.toString()}');
          }
        },
        child: tile(context, sel, index1, index2, sub),
      );
    }).toList()),
  );
}

Widget tile(context,sel,index,index2,sub){

  return  RadioListTile(
          groupValue: sel,
          title: Text(
            sub.subarea,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          value: index2/10+index,
          controlAffinity: ListTileControlAffinity.leading,
          secondary: IconButton(
            icon: Icon(Icons.mode_edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {
           Provider.of<UserState>(context, listen: false).setconfig(sub.conf);
            },
          ),
          activeColor: Theme.of(context).primaryColor,
          onChanged: (val){
           Provider.of<UserState>(context, listen: false).selectlist(val);
           Provider.of<UserState>(context, listen: false).setindexs(index,index2);
           Provider.of<UserState>(context, listen: false).setconfig(sub.conf);
          } 
        );
}

Widget _botonAgregar(context, nombrearea, formkey, submit) {
  final String area = 'Area';
  return Container(
    margin: EdgeInsets.only(right: 16.0),
    alignment: Alignment.centerRight,
    child: RaisedButton(
      child: Text(
        'Agregar',
        style: TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                alert(context, nombrearea, formkey, submit, area));
      },
    ),
  );
}

Widget alert(context, nombrearea, formkey, submit, area) {
  return AlertDialog(
    title: Text('Agrega una $area'),
    content: SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Aquí podras agregar el nombre del $area'),
            _crearNombre(context, nombrearea),
            SizedBox(height: 10.0),
            SizedBox(height: 0.0),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      ////////////// Boton Cancelar /////////////////////
      FlatButton(
          textColor: Theme.of(context).primaryColor,
          child: Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop()),
      SizedBox(width: 20.0),
      ////////////// Boton Guardar /////////////////////
      FlatButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: Text('Guardar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onPressed: submit,
      ),
      SizedBox(width: 10.0),
    ],
  );
}

Widget _crearNombre(context, nombrearea) {
  return TextFormField(
    enabled: true,
    decoration: InputDecoration(
      // hintText: 'Area 93',
      labelText: 'Ingresa un nombre',
    ),
    onSaved: nombrearea,
    validator: (value) {
      if (value.length < 3) {
        return 'Mínimo 03 caracteres';
      } else {
        return null;
      }
    },
  );
}
