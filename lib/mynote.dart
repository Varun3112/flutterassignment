import 'package:flutter/cupertino.dart';

class MyNote {
  String title = "";
  String points = "";
  List<Offset> listpoints = <Offset>[];

  MyNote(String title) {
    this.title = title;
  }
  MyNote.fromMap(Map map)
      : this.title = map['title'],
        this.points = map['points'];

  Map toMap() {
    return {
      'title': this.title,
      'points': this.points,
    };
  }

  void encode() {
    for (int i = 0; i < this.listpoints.length; i++) {
      if (this.listpoints[i] != null) {
        if (this.points != null) {
          this.points = this.points + this.listpoints[i].dx.toString() + ",";
          this.points = this.points + this.listpoints[i].dy.toString() + ",";
        } else {
          this.points = this.listpoints[i].dx.toString() + ",";
          this.points = this.listpoints[i].dy.toString() + ",";
        }
      }
    }
  }

  void decode() {
    if (this.points != null) {
      List<String> pointslist = this.points.split(',');
      int i = 0;
      int j = 0;
      this.listpoints.length = (pointslist.length / 2).round();
      for (i = 0; i < pointslist.length - 1; i = i + 2, j++) {
        this.listpoints[j] = Offset(
            double.parse(pointslist[i]), double.parse(pointslist[i + 1]));
      }
    }
  }
}
