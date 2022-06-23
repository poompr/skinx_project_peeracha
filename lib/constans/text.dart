import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextBcolorwidget extends StatelessWidget {
  final String name;
  final double size;
  final Color color;

  const TextBcolorwidget(
      {Key? key, required this.name, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style:
          TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color),
    );
  }
}

class TextScolorwidget extends StatelessWidget {
  final String name;
  final double size;
  final Color color;

  const TextScolorwidget(
      {Key? key, required this.name, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style:
          TextStyle(fontSize: size, fontWeight: FontWeight.w500, color: color),
    );
  }
}

class TextBwidget extends StatelessWidget {
  final String name;
  final double size;

  const TextBwidget({Key? key, required this.name, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: size, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }
}

class TextSwidget extends StatelessWidget {
  final String name;
  final double size;

  const TextSwidget({Key? key, required this.name, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: size, fontWeight: FontWeight.normal, color: Colors.black),
    );
  }
}

class TextBwhitewidget extends StatelessWidget {
  final String name;
  final double size;

  const TextBwhitewidget({Key? key, required this.name, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: size, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class TextSwhitewidget extends StatelessWidget {
  final String name;
  final double size;

  const TextSwhitewidget({Key? key, required this.name, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: size, fontWeight: FontWeight.normal, color: Colors.white),
    );
  }
}

String formattedDateDay(timeStamp) {
  var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return DateFormat('dd/MM/yy').format(dateFromTimeStamp);
}

class TimeAgo {
  static String timeAgoSinceDate(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);
    if (diff.inDays > 8) {
      return DateFormat("dd-MM-yy").format(notificationDate);
    } else if ((diff.inDays / 7).floor() >= 1) {
      return ' อาทิตย์ก่อน ';
    } else if (diff.inDays >= 2) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays >= 1) {
      return '1 วันก่อน ';
    } else if (diff.inHours >= 2) {
      return '${diff.inHours} ชั่วโมงที่แล้ว ';
    } else if (diff.inHours >= 1) {
      return '1 ชั่วโมงที่แล้ว ';
    } else if (diff.inMinutes >= 2) {
      return '${diff.inMinutes} นาทีที่แล้ว ';
    } else if (diff.inMinutes >= 1) {
      return '1 นาทีที่แล้ว ';
    } else if (diff.inSeconds >= 45) {
      return '${diff.inSeconds} วินาทีที่แล้ว ';
    } else {
      return ' ตอนนี้ ';
    }
  }
}
