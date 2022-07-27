import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_toggle_tab/helper.dart';
import 'package:ta/laporanReported.dart';

class LaporanTab extends StatefulWidget {
  const LaporanTab({Key? key}) : super(key: key);

  @override
  State<LaporanTab> createState() => _LaporanTabState();
}

class _LaporanTabState extends State<LaporanTab> {
  @override
  var _tabTextIndexSelected = 0;

  var _listTextTabToggle = ["Reported", "In Progress", "Done"];
  var _listTextSelectedToggle = [
    Reported(),
    Reported(),
    Reported(),
    // Text('data2'),
    // Text('data3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// Basic Toggle Sample
            SizedBox(
              height: heightInPercent(3, context),
            ),

            SizedBox(
              height: heightInPercent(3, context),
            ),
            Center(
              child: FlutterToggleTab(
                // width in percent
                width: 90,
                borderRadius: 5,
                height: 30,
                selectedIndex: _tabTextIndexSelected,
                selectedBackgroundColors: [Colors.grey, Colors.grey],
                selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                unSelectedTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
                labels: _listTextTabToggle,
                selectedLabelIndex: (index) {
                  setState(() {
                    _tabTextIndexSelected = index;
                  });
                },
                isScroll: false,
              ),
            ),

            _listTextSelectedToggle[_tabTextIndexSelected],
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
