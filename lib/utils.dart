// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:ta/api.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);
  @override
  String toString() => title;
}

/// Example events
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);
// Map<DateTime, List<Event>> getList() {
//   Map<DateTime, List<Event>> maps = {};
//   getDates().then((value) {
//     for (var item in value) {
//       maps = {
//         kToday: [Event(item)]
//       };
//     }
//   });
//   print(maps.toString() + "maps");
//   return maps;
// }

var kEventSource = {
  null: [null]
};
// = {
//   ...getList()

//   // for (var item in List.generate(500, (index) => index))
//   //   DateTime.utc(kFirstDay.year, kFirstDay.month, item * 2): List.generate(
//   //       item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
//   // kToday: [
//   //   Event('a'),
//   //   Event('a'),
//   //   Event('a'),
//   // ]

//   // kToday: [
//   //   Event('Runway'),
//   //   Event('Taxiway'),
//   // ]
// }; //basically the format is the date : Event('isinya')

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

var eventArr = [
  {"2022-04-28 22:19:40.988": "a"}
];

// final kTomorrow = DateTime(year);
// final x = kTomorrow![0];
final kToday = DateTime.now();
// final Arr = [kToday, kTomorrow];
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
