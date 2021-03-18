import 'package:flutter/material.dart';

import 'package:flutterassignment/mynote.dart';

class DrawingPage extends StatefulWidget {
  final MyNote note;
  DrawingPage({Key key, @required this.note}) : super(key: key);
  @override
  _DrawingPageState createState() => new _DrawingPageState(note);
}

class _DrawingPageState extends State<DrawingPage> {
  MyNote note;
  _DrawingPageState(this.note);
  List<Offset> _points = <Offset>[];
  @override
  Widget build(BuildContext context) {
    _points = note.listpoints;
    return new Scaffold(
        body: new Container(
          child: new GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = new List.from(_points)..add(_localPosition);
                note.listpoints = _points;
              });
            },
            onPanEnd: (DragEndDetails details) => _points.add(null),
            child: new CustomPaint(
              painter: new Signature(points: _points),
              size: Size.infinite,
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            new FloatingActionButton(
              child: new Icon(Icons.clear),
              onPressed: () => _points.clear(),
            ),
            new FloatingActionButton(
                child: new Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.pop(context, note);
                  note.encode();
                })
          ],
        ));
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.pink
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
