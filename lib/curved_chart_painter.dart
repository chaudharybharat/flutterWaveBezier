import 'package:flutter/material.dart';

class CurvedChartPainter extends CustomPainter {
  // Properties to configure the chart
  final List<Map<String, double>> xValues;
  final List<Map<String, double>> yValues;
  final Color? color;
  final double strokeWidth;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final TextStyle labelTextStyle;

  // Constructor
  CurvedChartPainter({
    required this.xValues,
    required this.yValues,
    required this.strokeWidth,
    this.color,
    this.gradientColors = const [
      Color(0x00F63E02),
      Color(0xFFCE1111),
    ],

    this.gradientStops = const [0.0, 1.0],
    this.labelTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
  });

  List<double> listX=[0,10,20,30,40,50,0,10,10,10,80,0,200];
  // The paint method is called when the custom painter needs to paint
  @override
  void paint(Canvas canvas, Size size) {
    // Set up the paint for the chart line

    debugPrint("=${size.width}=${size.height}=");
    var paint = Paint();
    paint.color = color ?? const Color(0xFFF63E02);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth;

    // Set up the paint for the chart fill
    var fillPaint = Paint();
    fillPaint.style = PaintingStyle.fill;

    // Set up the paint for the axes
    var axisPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw X axis
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), axisPaint);

    // Draw Y axis
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);

    // Create paths for the chart line and fill
    var path = Path();
    var fillPath = Path();
    // Check if there are enough values to draw the chart
    if (xValues.length > 1 && yValues.isNotEmpty) {

      final maxValue =500;
      final firstValueHeight = size.height * (listX[0] / maxValue);

      // Initialize the paths with the first point
      path.moveTo(0.0, size.height - firstValueHeight);
      fillPath.moveTo(0.0, size.height);
      fillPath.lineTo(0.0, size.height - firstValueHeight);

      // Calculate the distance between each x value
      final itemXDistance = size.width / (listX.length - 1);

      // Loop through the x values and draw the chart line and fill
      for (var i = 1; i < listX.length; i++) {
        final x = itemXDistance * i;
        final valueHeight = size.height -
            strokeWidth -
            ((size.height - strokeWidth) *
                (listX[i] / maxValue));
        final previousValueHeight = size.height -
            strokeWidth -
            ((size.height - strokeWidth) *
                (listX[i - 1] / maxValue));

        // Draw a quadratic bezier curve between each point
        path.quadraticBezierTo(
          x - (itemXDistance / 2) - (itemXDistance / 8),
          previousValueHeight,
          x - (itemXDistance / 2),
          valueHeight + ((previousValueHeight - valueHeight) / 2),
        );
        path.quadraticBezierTo(
          x - (itemXDistance / 2) + (itemXDistance / 8),
          valueHeight,
          x,
          valueHeight,
        );

        // Draw the fill path using the same quadratic bezier curves
        fillPath.quadraticBezierTo(
          x - (itemXDistance / 2) - (itemXDistance / 8),
          previousValueHeight,
          x - (itemXDistance / 2),
          valueHeight + ((previousValueHeight - valueHeight) / 2),
        );
        fillPath.quadraticBezierTo(
          x - (itemXDistance / 2) + (itemXDistance / 8),
          valueHeight,
          x,
          valueHeight,
        );
      }

      // Close the fill path
      fillPath.lineTo(size.width, size.height);
      fillPath.close();
    }

    // Create a gradient for the fill
    LinearGradient gradient = LinearGradient(
      colors: gradientColors,
      stops: gradientStops,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    fillPaint.shader = gradient.createShader(rect);

    // Draw the fill path with the gradient
    canvas.drawPath(fillPath, fillPaint);

    // Draw the chart line
    canvas.drawPath(path, paint);

    // Draw X axis labels
    for (int i = 0; i < xValues.length; i++) {
      double x = size.width * i / (xValues.length - 1);
      canvas.drawCircle( Offset(x, size.height + 2 ), 5,paint..color=Colors.red);

    }

    // Draw Y axis labels
    for (int i = 0; i < yValues.length; i++) {
      double y = size.height * i / (yValues.length - 1);

      canvas.drawCircle( Offset(0, y ), 5,paint..color=Colors.red);
    }
  }

  // Determine whether the chart should repaint
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
