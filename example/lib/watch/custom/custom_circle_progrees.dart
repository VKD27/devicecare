import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter{

  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {

    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 4
      ..color = Color(0xFFCCCCCC).withOpacity(.5)
      ..style = PaintingStyle.stroke;

   /* Paint completeArc = Paint()
      ..strokeWidth = 8
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;*/
    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = new SweepGradient(
      startAngle: 3 * pi / 2,
      endAngle: 7 * pi / 2,
      tileMode: TileMode.repeated,
      colors: [Color(0xFF00E7F0), Color(0xFF3D9AE2)],
    );

    Paint completeArc = Paint()
      ..strokeWidth = 8
      ..shader = gradient.createShader(rect)
      //..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;



    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

/*
to show the linear gradient from container or box type of display

BoxDecoration(
gradient: LinearGradient(
colors: [
AppColors.roseGradientColor,
AppColors.purpleInAppGradientColor,
AppColors.blueInAppGradientColor
],
begin: Alignment(-0.7,12),
end: Alignment(1,-2),
),
borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25))
)

========================


var rect = Offset.zero & size;
Path rectPathThree = Path();
Paint paint = Paint();
paint.shader = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Colors.blue[900],
    Colors.blue[500],
  ],
).createShader(rect);


*/

/*
class GradientArcPainter extends CustomPainter {
  const GradientArcPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.width,
  })  : super();

  final double progress;
  final Color startColor;
  final Color endColor;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = new SweepGradient(
      startAngle: 3 * math.pi / 2,
      endAngle: 7 * math.pi / 2,
      tileMode: TileMode.repeated,
      colors: [startColor, endColor],
    );

    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt  // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (width / 2);
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}*/
