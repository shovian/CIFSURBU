// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta/tambahLaporan.dart';
import 'package:ta/tampilLaporan.dart';
import 'package:table_calendar/table_calendar.dart';

import './utils.dart';

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({Key? key, required this.function})
      : super(key: key);

  final VoidCallback function;
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    print(kEvents);
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // if (!isSameDay(_selectedDay, selectedDay)) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null; // Important to clean those
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDay(selectedDay);
    // }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  void setDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', date.toString());
  }

  bool isLoaded = false;
  bool isLoadedTwo = false;
  List<String> laporan = [];
  int totalEvent = -1;
  Future<List<String>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? _totalEvent = prefs.getInt('total-event');
    final List<String>? _laporan = prefs.getStringList('laporan');
    getCalendar();
    return _laporan ?? [];
    // print(_totalEvent);
    totalEvent = _totalEvent ?? -1;
    laporan = _laporan ?? [];

    // print(isLoaded);
    if (!isLoaded) {
      setState(() {
        isLoaded = true;
        _focusedDay = kToday;

        // kEvents.addAll(kEventSource);
      });
    }
  }

  void getCalendar() {
    for (var v in laporan) {
      List<Event> list = [];
      var a = jsonDecode(v);
      var b = a.keys.first; //date
      var c = a[b];
      Iterable<String> nama = c.keys; // runway taxiway
      nama.forEach((bagian) {
        var dtemp = c[bagian];
        var acceptedFile;
        var d = jsonDecode(dtemp);
        Iterable<String> bagianKerusakan = d.keys; //permukaan perkerasan
        bagianKerusakan.forEach((kerusakan) {
          var h = d[kerusakan];
          if (h.keys.length == 5) {
            list.add(Event(kerusakan));
          }
        });
      });
      kEvents.addAll({
        ...kEvents,
        DateTime.parse(jsonDecode(v).keys.first): list,
      });
    }
    // for (var v in laporan) {
    //   List<Event> list = [];
    //   print(jsonDecode(v).keys.first);
    //   var a = jsonDecode(v);
    //   var b = a.keys.first; //date
    //   var c = a[b];
    //   for (var w in c) {
    //     var d = w.keys.first; //nama (Runway, Taxiway,etc.)
    //     var e = w[d];
    //     var f = jsonDecode(e);
    //     Iterable<String> g = f.keys;
    //     g.forEach((element) {
    //       var h = f[element];
    //       print(h.keys.length);
    //       if (h.keys.length == 5) {
    //         list.add(Event(d));
    //       }
    //       Iterable<String> i = h.keys;
    //       i.forEach((elementa) {
    //         // print(elementa);
    //       });
    //     });
    //   }
    //   kEvents.addAll({
    //     ...kEvents,
    //     DateTime.parse(jsonDecode(v).keys.first): list,
    //   });
    // }
    // setState(() {});
  }

  Widget render() {
    print(isLoadedTwo.toString() + " loaded while render");

    if (isLoadedTwo)
      return Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  markerSize: 5,
                  selectedDecoration: BoxDecoration(
                      color: Colors.amber, shape: BoxShape.circle),
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey),
                            ),
                          ),
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${value[index]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Inspeksi Rutin'),
                                  Text('Last Update : 7/11/2022, 06:20')
                                ],
                              ),
                            ),
                            onTap: () {
                              widget.function();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => TambahLaporan()),
                              // );
                            },
                          )
                          // child: ListTile(
                          //   onTap: () => print('${value[index]}'),
                          //   title: Text('${value[index]}'),
                          // ),
                          );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    else {
      isLoadedTwo = isLoaded;

      return Text('data');
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    setDate(_focusedDay);
    getData();

    print(kEvents);
    return FutureBuilder<List<String>?>(
        future: getData(),
        builder: (((context, snapshot) {
          if (snapshot.hasData) {
            laporan = snapshot.data ?? [];
            print(kEvents.toString() + "ini");
            getCalendar();
            print(snapshot.data);
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: TableCalendar<Event>(
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                        // Use `CalendarStyle` to customize the UI
                        markerSize: 5,
                        selectedDecoration: BoxDecoration(
                            color: Colors.amber, shape: BoxShape.circle),
                        outsideDaysVisible: false,
                      ),
                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                ),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${value[index]}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Inspeksi Rutin'),
                                        Text('Last Update : 7/11/2022, 06:20')
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    widget.function();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => TambahLaporan()),
                                    // );
                                  },
                                )
                                // child: ListTile(
                                //   onTap: () => print('${value[index]}'),
                                //   title: Text('${value[index]}'),
                                // ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        })));
  }
}
