import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SpinnerPage extends StatefulWidget {
  const SpinnerPage({super.key});

  @override
  State<SpinnerPage> createState() => _SpinnerPageState();
}

class _SpinnerPageState extends State<SpinnerPage> {
  StreamController<int> controller = StreamController<int>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      '100',
      '200',
      '300',
      '400',
      '500',
      '600',
      '700',
      '800',

      "1000"
      // Add more items as needed
    ];
    // items.shuffle();
    List<int> rewards = [
      800,
      300,
      1500,
      850,
      900,
      2000,
      750,
      3000,
      500,
    ];

    rewards.shuffle();
    int win = 0;
    // List<Color> colors = [
    //   Color(0xffe8d174),
    //   Color(0xffe39e54),
    //   Color(0xffd64d4d),
    //   Color(0xff4d7358),
    //   Color(0xff9ed670),
    // ];

    // List<FortuneItem> fortuneItems = rewards.asMap().entries.map(
    //   (entry) {
    //     int index = entry.key;
    //     int reward = entry.value;
    //     Color color = colors[index % colors.length]; // Get color based on index

    //     return FortuneItem(
    //       style: FortuneItemStyle(color: color),
    //       child: Text(
    //         "  $reward\$",
    //         style: GoogleFonts.pressStart2p(
    //           fontSize: 15,
    //           color: Colors.black,
    //         ),
    //       ),
    //     );
    //   },
    // ).toList();
    // controller.add(0);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 350,
            width: 350,
            child: CustomPaint(
              painter: WheelPainter(
                rewards,
              ),
            ),
          ),
          buildIndicator()
        ],
      ),
    );

    // Column(
    //   children: [
    //     SizedBox(
    //       height: Get.height * 0.6,
    //       width: Get.width * 0.9,
    //       child: FortuneWheel(
    //         duration: const Duration(seconds: 1),
    //         onAnimationStart: () {
    //           print("STARTED");
    //         },
    //         onAnimationEnd: () {
    //           print(
    //               "FINISGED ${controller.stream}");
    //           // win = rewards[];
    //           // win = controller;
    //           print(controller.stream);
    //         },
    //         animateFirst: false,
    //         indicators: const [
    //           FortuneIndicator(
    //             alignment: Alignment.topCenter,
    //             child: Stack(
    //               children: [
    //                 Positioned(
    //                   top: -35,
    //                   left: 0,
    //                   right: 0,
    //                   child: Icon(
    //                     Icons.arrow_drop_down,
    //                     color: Colors.black,
    //                     size: 80,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //         items: [
    //           // for (var fortuneItem in fortuneItems) ...<FortuneItem>{
    //           //   fortuneItem,
    //           // }
    //           for (var reward in rewards) ...<FortuneItem>{
    //             FortuneItem(
    //               style: FortuneItemStyle(
    //                 borderColor: Colors.black.withAlpha(150),
    //                 borderWidth: 1.5,
    //                 color: reward < 750
    //                     ? const Color(0xFF808080)
    //                     : reward >= 750 && reward < 1000
    //                         ? const Color(0xFF800080)
    //                         : const Color(0xFFFFD700),
    //               ),
    //               child: Text(
    //                 "  $reward\$",
    //                 style: GoogleFonts.pressStart2p(
    //                     fontSize: 15, color: Colors.black),
    //               ),
    //             ),
    //           }
    //         ],
    //         selected: controller.stream,
    //       ),
    //     ),
    //     IconButton(
    //         splashColor: Colors.white,
    //         highlightColor: Colors.white,
    //         onPressed: () {
    //           controller.sink.add(Fortune.randomInt(0, rewards.length));
    //         },
    //         icon: const Icon(
    //           Icons.swipe_outlined,
    //           size: 70,
    //           color: Colors.black,
    //         ))
    //   ],
    // );
  }
}

Widget buildIndicator() {
  return const Positioned(
    top: -50,
    left: 0,
    right: 0,
    child: Icon(
      Icons.arrow_drop_down,
      color: Colors.black,
      size: 100,
    ),
  );
}

// class WheelPainter extends CustomPainter {
//   final List<int> items;

//   WheelPainter(this.items);
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double radius = size.shortestSide / 2;
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;
//     final double sliceAngle = 2 * math.pi / items.length;
//     Paint paint = Paint()..style = PaintingStyle.fill;
//     final Paint borderPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8;
//     for (int i = 0; i < items.length; i++) {
//       paint.color = items[i] < 600
//           ? Colors.grey
//           : items[i] >= 600 && items[i] < 1500
//               ? Colors.purple
//               : Colors.yellow;
//       // _getColor(i);
//       canvas.drawArc(
//         Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
//         sliceAngle * i,
//         sliceAngle,
//         true,
//         paint,
//       );
//       // Draw text parallel to the pie angle
//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: "${items[i]}\$",
//           style: GoogleFonts.pressStart2p(
//             color: Colors.black,
//             fontSize: 14.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();
//       final textPath = Path()
//         ..addRect(Rect.fromLTWH(0, 0, textPainter.width, textPainter.height));
//       final textRotateOffset = Offset(
//         centerX + (radius / 1.2) * math.cos(sliceAngle * i + sliceAngle / 1.9),
//         centerY + (radius / 1.2) * math.sin(sliceAngle * i + sliceAngle / 1.9),
//       );
//       canvas.save();
//       canvas.translate(textRotateOffset.dx, textRotateOffset.dy);
//       canvas.rotate(sliceAngle * i + sliceAngle / 0.42 + math.pi / 1.81);
//       canvas.drawPath(textPath, Paint()..color = Colors.transparent);
//       textPainter.paint(canvas, Offset.zero);
//       canvas.restore();
//     }
//   }
//   Color _getColor(int index) {
//     List<Color> colors = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//       // Add more colors if needed
//     ];
//     return colors[index % colors.length];
//   }
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
// class WheelPainter extends CustomPainter {
//   final int itemCount;
//   final List<String> list;
//   WheelPainter(this.itemCount, this.list);
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double radius = size.shortestSide / 2;
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;
//     final double sliceAngle = 2 * math.pi / itemCount;
//     Paint paint = Paint()..style = PaintingStyle.fill;
//     final double labelRadius = radius / 2; // Adjust label position as needed
//     for (int i = 0; i < itemCount; i++) {
//       paint.color = _getColor(i);
//       final double startAngle = sliceAngle * i;
//       final double endAngle = startAngle + sliceAngle;
//       final double midAngle = (startAngle + endAngle) / 2;
//       final double labelX = centerX + labelRadius * math.cos(midAngle);
//       final double labelY = centerY + labelRadius * math.sin(midAngle);
//       // Draw pie slice
//       canvas.drawArc(
//         Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
//         startAngle,
//         sliceAngle,
//         true,
//         paint,
//       );
//       // Draw item label
//       _drawText(canvas, labelX, labelY, list[i], size);
//     }
//   }
//   void _drawText(Canvas canvas, double x, double y, String text, Size size) {
//     final textStyle = GoogleFonts.pressStart2p(
//       color: Colors.black,
//       fontSize: 8,
//       fontWeight: FontWeight.bold,
//     );
//     final TextSpan span = TextSpan(
//       style: textStyle,
//       text: text,
//     );
//     final TextPainter tp = TextPainter(
//       text: span,
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );
//     tp.layout();
//     final textX = x - (tp.width / 2);
//     final textY = y - (tp.height / 2);
//     tp.paint(canvas, Offset(textX, textY));
//   }
//   Color _getColor(int index) {
//     List<Color> colors = [
//       Colors.indigo,
//       Colors.deepOrange,
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.orange,
//       Colors.purple,
//       // Add more colors if needed
//     ];
//     return colors[index % colors.length];
//   }
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// BORDER LINE WHEEL
class WheelPainter extends CustomPainter {
  final List<int> items;
  WheelPainter(this.items);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // Border width
    final Paint slicePaint = Paint()..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, borderPaint); // Draw the wheel border

    final sliceAngle = (2 * math.pi) / items.length;

    double startAngle = -math.pi / 2; // Start angle

    for (var i = 0; i < items.length; i++) {
      slicePaint.color = Colors.primaries[i % Colors.primaries.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        slicePaint,
      );
      final Paint borderside = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final double x1 = center.dx + radius * math.cos(startAngle);
      final double y1 = center.dy + radius * math.sin(startAngle);
      final double x2 = center.dx + radius * math.cos(startAngle + sliceAngle);
      final double y2 = center.dy + radius * math.sin(startAngle + sliceAngle);

      canvas.drawLine(
        // Offset(center.dx, center.dy),
        Offset(x1, y1),
        Offset(x2, y2),
        borderside,
      );
      // canvas.drawLine(
      //   Offset(center.dx, center.dy),
      //   Offset(x2, y2),
      //   borderPaint,
      // );
      drawText(
        canvas,
        center,
        radius,
        startAngle + (sliceAngle / 2),
        items[i],
      );
      startAngle += sliceAngle;
    }
  }

  void drawText(
      Canvas canvas, Offset center, double radius, double angle, int text) {
    final textStyle = GoogleFonts.pressStart2p(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: [
        const Shadow(
          color: Colors.black,
          offset: Offset(0.5, 0.5),
          blurRadius: 0,
        ),
        const Shadow(
          color: Colors.black,
          offset: Offset(-0.5, -0.5),
          blurRadius: 10,
        ),
        const Shadow(
          color: Colors.black,
          offset: Offset(-0.5, 0.5),
          blurRadius: 0,
        ),
        const Shadow(
          color: Colors.black,
          offset: Offset(0.5, -0.5),
          blurRadius: 0,
        ),
        // Shadow(
        //   color: Colors.black.withOpacity(0.1),
        //   offset: const Offset(-2, 2),
        //   blurRadius: 5,
        // )
      ],
      fontSize: 12,
    );
    final textSpan = TextSpan(
      text: "$text\$",
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textRadius =
        radius * 0.8; // Adjust text distance from the circle center
    final dx = center.dx + textRadius * math.cos(angle);
    final dy = center.dy + textRadius * math.sin(angle);
    canvas.save();
    canvas.translate(dx, dy);
    canvas.rotate(angle + math.pi / 2);
    textPainter.paint(
        canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
