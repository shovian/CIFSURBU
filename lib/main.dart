import 'package:flutter/material.dart';
import 'package:ta/calendar.dart';
import 'package:ta/counter.dart';
import 'package:ta/login.dart';
import 'package:ta/notifikasi.dart';
import 'package:ta/perbaikan.dart';
import 'package:ta/tambahLaporan.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const Map<int, Color> colorCodes = {
    50: Color.fromRGBO(15, 42, 86, .1),
    100: Color.fromRGBO(15, 42, 86, .2),
    200: Color.fromRGBO(15, 42, 86, .3),
    300: Color.fromRGBO(15, 42, 86, .4),
    400: Color.fromRGBO(15, 42, 86, .5),
    500: Color.fromRGBO(15, 42, 86, .6),
    600: Color.fromRGBO(15, 42, 86, .7),
    700: Color.fromRGBO(15, 42, 86, .8),
    800: Color.fromRGBO(15, 42, 86, .9),
    900: Color.fromRGBO(15, 42, 86, 1),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Akhir',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primarySwatch: MaterialColor(0xFF0F2A56, colorCodes),
      ),
      home: const MyHomePage(user: 'a', title: 'Tugas Akhir'),
      // home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.user})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String user;

  @override
  State<MyHomePage> createState() => _MyHomePageState(user);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(String user) {
    _user = user;
    if (_user == 'admin') _isVisible = false;
  }
  bool _isVisible = true;
  String _user = '';
  int _selectedIndex = 1;
  bool _isTambahLaporan = false;
  String _label = 'Laporan';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _isTambahLaporan = false;
      if (index == 0) {
        _label = 'Perbaikan';
        _isVisible = false;
      } else if (index == 1) {
        _label = 'Laporan';
        _isVisible = true;
        if (_user == 'admin') _isVisible = false;
      } else if (index == 2) {
        _label = 'Notifikasi';
        _isVisible = false;
      } else
        _label = '';
      _selectedIndex = index;
    });
  }

  void setTambahLaporan() {
    setState(() {
      _isVisible = false;
      _isTambahLaporan = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Perbaikan(),
      TableEventsExample(function: setTambahLaporan),
      Notif(),
      TambahLaporan()
    ];
    Widget rend() {
      _label = '';
      if (_isTambahLaporan) {
        return Container(child: _widgetOptions.elementAt(3));
      } else
        return Container(child: _widgetOptions.elementAt(_selectedIndex));
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      floatingActionButton: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isVisible = false;
                _isTambahLaporan = true;
              });
            },
          )),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Perbaikan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(15, 42, 86, 1),
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Icon(
                Icons.account_circle,
                size: 50,
                color: Colors.grey,
              ),
              margin: EdgeInsets.fromLTRB(15, 20, 0, 20),
              alignment: Alignment.centerLeft,
            ),
            ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -4),
              title: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -4),
              title: Text(
                'Pengaturan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -4),
              title: Text(
                'Sign Out',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    )),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Kembali',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_label),
        centerTitle: false,
      ),
      body: Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: rend()),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
