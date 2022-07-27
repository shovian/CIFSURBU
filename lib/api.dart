import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

Future<List<String>> fetchData() {
  List<String> temp = [];
  return SharedPreferences.getInstance().then((SharedPreferences prefs) {
    return prefs.getStringList('laporan') ?? [];
  });
}

getObyekInspeksibyDate(DateTime date) {
  return fetchData().then((value) {
    List<String> list = [];
    for (var v in value) {
      var a = jsonDecode(v);
      String b = a.keys.first;
      if (isSameDay(date, DateTime.parse(b))) {
        var c = a[b];
        for (var w in c) {
          var d = w.keys.first; //nama (Runway, Taxiway,etc.)
          var e = w[d];
          var f = jsonDecode(e);
          Iterable<String> g = f.keys;
          g.forEach((element) {
            var h = f[element];
            print(h.keys.length);
            if (h.keys.length == 5) {
              list.add(d);
            }
            Iterable<String> i = h.keys;
            i.forEach((elementa) {
              // print(elementa);
            });
          });
        }
      }
    }
    return list;
  });
}

Future<List<String>> getDates() {
  return fetchData().then((value) {
    List<String> list = [];
    for (var v in value) {
      var a = jsonDecode(v);
      String b = a.keys.first;
      list.add(b);
    }
    return list;
  });
}

// Future<String> getRunway(DateTime date) async {

// }
