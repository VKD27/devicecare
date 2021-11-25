import 'package:devicecare_example/global/global.dart';
import 'package:devicecare_example/model/predicted_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViewReadings extends StatefulWidget {
  final PredictedData predictedData, actData;
  final WaveData wavePositionedData;
  final int reviewCount;

  ViewReadings(this.predictedData, this.actData, this.wavePositionedData,
      this.reviewCount);

  @override
  State<StatefulWidget> createState() {
    return ViewReadingsState();
  }
}

class ViewReadingsState extends State<ViewReadings> {
  List<Map<String, String>> listOfColumns = [];

  List<FlSpot> fVChartSpot =[]; // x- volume (L), y- speed (L/s)
  List<FlSpot> vTChartSpot =[]; // x- times (s), y- volume (L)

  @override
  void initState() {
    ShowPredictedTitle title = ShowPredictedTitle();
    // "predict": widget.predictedData.fev1Fvc+' (%)'
    listOfColumns = [
      {"name": title.fvc, "act": widget.actData.fvc + ' (L)', "predict": widget.predictedData.fvc + ' (L)'},
      {"name": title.fev1,"act": widget.actData.fev1 + ' (L)', "predict": widget.predictedData.fev1 + ' (L)'},
      {"name": title.pef, "act": widget.actData.pef + ' (L/s)', "predict": widget.predictedData.pef + ' (L/s)'},
      {"name": title.fev1Fvc, "act": widget.actData.fev1Fvc + ' (%)', "predict": ''},
      {"name": title.fef25, "act": widget.actData.fef25 + ' (L/s)', "predict": widget.predictedData.fef25 + ' (L/s)'},
      {"name": title.fef50, "act": widget.actData.fef50 + ' (L/s)', "predict": widget.predictedData.fef50 + ' (L/s)'},
      {"name": title.fef75, "act": widget.actData.fef75 + ' (L/s)', "predict": widget.predictedData.fef75 + ' (L/s)'},
      {"name": title.fef2575, "act": widget.actData.fef2575 + ' (L/s)', "predict": widget.predictedData.fef2575 + ' (L/s)'},
      {"name": title.peft, "act": widget.actData.peft + ' (ms)', "predict": ''},
      {"name": title.evol, "act": widget.actData.evol + ' (ml)', "predict": ''},
    ];

    print('time>> ${widget.wavePositionedData.time.length}');
    print('speed>>  ${widget.wavePositionedData.speed.length}');
    print('volume>>  ${widget.wavePositionedData.volume.length}');

    if (widget.wavePositionedData.volume.length == widget.wavePositionedData.speed.length) {
      for(int i=0; i< widget.wavePositionedData.speed.length;i++){
        fVChartSpot.add(FlSpot(widget.wavePositionedData.volume[i], widget.wavePositionedData.speed[i]));
      }
    }

    if (widget.wavePositionedData.volume.length == widget.wavePositionedData.time.length) {
      for(int i=0; i< widget.wavePositionedData.time.length;i++){
        vTChartSpot.add(FlSpot(widget.wavePositionedData.time[i], widget.wavePositionedData.volume[i]));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('View More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Review : ${widget.reviewCount}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Dated on : ' + Global.getDateBind(widget.actData.date)),
                ),
              ],
            ),
            showDataTable(),
            SizedBox(
              height: 8.0,
            ),
            Center(child: Text('F-V Chart', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),)),
            showFVChartGraph(),
            SizedBox(
              height: 8.0,
            ),
            Center(child: Text('V-T Chart', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),)),
            showVTChartGraph(),
          ],
        ),
      ),
    );
  }

  Widget showDataTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Params')),
        DataColumn(label: Text('Actual')),
        DataColumn(label: Text('Predicted')),
      ],
      rows: listOfColumns.map(
            ((element) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(element["name"] ?? '')), //Extracting from Map element the value
                    DataCell(Text(element["act"] ?? '')),
                    DataCell(Text(element["predict"] ?? '')),
                  ],
                )),
          )
          .toList(),
    );
  }

  Widget showFVChartGraph() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18)),
                color: Color(0xff232d37)),
            margin:  const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                fVChartData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData fVChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 2:
                return '2';
              case 4:
                return '4';
              case 6:
                return '6';
              case 8:
                return '8';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 4,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: fVChartSpot,
          isCurved: true,
         // colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            //colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }


  Widget showVTChartGraph() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18)),
                color: Color(0xff232d37)),
            margin:  const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                vTChartData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData vTChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 2:
                return '2';
              case 4:
                return '4';
              case 6:
                return '6';
              case 8:
                return '8';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          spots: vTChartSpot,
          isCurved: true,
          // colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            //colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

}
