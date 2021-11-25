import 'dart:math';
import 'package:charts_flutter/flutter.dart';
//import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {

  final String textTip;

  CustomCircleSymbolRenderer({required this.textTip});

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int>? dashPattern, Color? fillColor, FillPatternType? fillPattern, Color? strokeColor, double? strokeWidthPx}) {
    // TODO: implement paint
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, fillPattern: fillPattern, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
        fill: Color.white
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement.TextElement(textTip, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }

 /* @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {required List<int> dashPattern, required Color fillColor, required FillPatternType fillPattern, required Color strokeColor, required double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor,fillPattern: fillPattern, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
        fill: Color.white
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(

        TextElement.TextElement("1", style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }*/
}