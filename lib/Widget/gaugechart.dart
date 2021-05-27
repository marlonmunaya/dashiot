import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

Widget gaugechart(String label,String und,double data,double min, double max,) {
  List<charts.Series<GaugeSegment, String>> _createSampleData;
  if (data==null) {
    data = 0.0;
  }
  if (min <= 0.0 ) {
    min = 0.0;
  }
  double rest=(max-min)-data;

  return Card(
    elevation: 10.0,
      margin:EdgeInsets.all(5.0),
      child: Column(
      children: <Widget>[
        SizedBox(height:10.0,width: 280.0,),
        Text(label),
        Container(
          width: 250.0,
          height: 250.0,
          child: charts.PieChart(
              _createSampleData = [
                charts.Series<GaugeSegment, String>(
                  id: 'Segments',
                  domainFn: (GaugeSegment segment, _) => segment.segment,
                  measureFn: (GaugeSegment segment, _) => segment.size,
                  colorFn: (GaugeSegment segment, _) => 
                      charts.ColorUtil.fromDartColor(segment.colorval),
                  data: [
                    new GaugeSegment(min.toString()+und, 0, Color(0xff3366cc)),
                    new GaugeSegment(data.toString(), data, Color(0xff3366cc)),
                    new GaugeSegment('', rest, Colors.grey[50],),
                    new GaugeSegment(max.toString()+und, 0, Color(0xff3366cc)),
                  ],
                )
              ],
              animate: false,
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 35,
                  startAngle: 2.2,
                  arcLength: 5,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.auto)
                  ]
              )
          ),
        ),
        // Text(label),
      ],
    ),
  );
}

class GaugeSegment {
  final String segment;
  final double size;
  Color colorval;
  GaugeSegment(this.segment, this.size, this.colorval);
}
