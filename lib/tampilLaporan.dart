import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ta/api.dart';

class TampilLaporan extends StatefulWidget {
  const TampilLaporan({Key? key, required this.selectedDay}) : super(key: key);
  final DateTime selectedDay;
  @override
  State<TampilLaporan> createState() => _TampilLaporanState();
}

class _TampilLaporanState extends State<TampilLaporan> {
  Map<String, Map<String, String>> _runway = {};
  void getData(DateTime date) {
    fetchData().then((List<String> data) {
      print(data);
      if (data != []) {
        for (var v in data) {
          var tempCurrentData = jsonDecode(v);
          // print(v + "AK");
          var existingDate = DateTime.parse(tempCurrentData.keys.first);
          if ((existingDate.day == date.day) &&
              (existingDate.month == date.month) &&
              (existingDate.year == date.year)) {
            setState(() {
              _runway = tempCurrentData[date]!.elementAt(0);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getData(widget.selectedDay);
    return Text(_runway.toString());
  }
}
