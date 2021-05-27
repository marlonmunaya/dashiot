import 'package:flutter/material.dart';
import 'package:dashiot/models/area.dart';

   Widget tabledataMaquinas(List<DevicesModel2> devicemodel){
    const style = TextStyle(fontStyle: FontStyle.italic);
    return devicemodel == null
        ? CircularProgressIndicator()
        : Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
        columns: const <DataColumn>[
              DataColumn(label: Text('Variable 1', style: style,), ),
              DataColumn(label: Text('Variable 2', style: style,), ),
              DataColumn(label: Text('Variable 3', style: style,), ),
              DataColumn(label: Text('Variable 4', style: style,),),
              DataColumn(label: Text('Variable 5', style: style,),),
              DataColumn(label: Text('Variable 6', style: style,),),
              DataColumn(label: Text('Variable 7', style: style,),),
              DataColumn(label: Text('Variable 8', style: style,),),
              DataColumn(label: Text('Variable 9', style: style,),),
              DataColumn(label: Text('Variable 10', style: style,),),
              DataColumn(label: Text('Date', style: style,),),
        ],
        rows: devicemodel
                        .map(
                          (d) => DataRow(
                            cells:[
                              DataCell(
                                Text(d.lat.toString()),
                              ),
                              DataCell(
                                Text(d.lng.toString()),
                              ),
                              DataCell(
                                Text(d.var1valor.toString()),
                              ),
                              DataCell(
                                Text(d.var2valor.toString()),
                              ),
                              DataCell(
                                Text(d.var3valor.toString()),
                              ),
                              DataCell(
                                Text(d.var4valor.toString()),
                              ),
                              DataCell(
                                Text(d.var5valor.toString()),
                              ),
                              DataCell(
                                Text(d.var6valor.toString()),
                              ),
                              DataCell(
                                Text(d.var7valor.toString()),
                              ),
                              DataCell(
                                Text(d.var8valor.toString()),
                              ),
                              DataCell(
                                Text(d.time.toString()),
                              ),
                              // DataCell(
                              //   Text(DateFormat('dd/MM/yyyy - kk:mm').format(d.time).toString()),
                              // ),
                              // Text(d.reference.documentID + ' - ' + d.var1name),
                              // Text(d.time.toString())
                            ],
                          ),
                        ).toList(),
      ),
            ),
          ),
    );
  }

