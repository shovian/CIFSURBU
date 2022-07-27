import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta/api.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "bold-proton-325413",
  "private_key_id": "fc0194b5375e1047772deb50fe2cff0611dc1f1a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDMdGIafbQylWYo\nvjQADKNXy0lvEix3/77G0P2gvkQPvxHilkWljK6AM1bwTBtTpSAJysDPOvmjh2x2\nruZTMitOeFz4REM5+PDOPTAZbYpjKa1Kil5RMDlDGMzjTzxLJs4rbJEZJdXHB5O8\nPQb451TE6a60kt9VE6YRmlsT6TINPPZRRsiIiivuUEPLxGnIR83rPBz8P6B5Clrr\n5TFczZxTKvlbRCJkGMvb9syEGGb5j+Py3bdERatN0PpWQz+Jls01J16M8HtcPBy8\n7phPwzBpsrq0VNX29UJ8Ys4M+MT+i0wJL+spsOuV5O4zJku2khDB1LgtYo+S7YYC\nC0q7uYOFAgMBAAECggEAEMqKIroqKhwCTNxPcaWYEKYdvM/VnnFUM13cm+6kW6q0\nhv29GzsyOvh8bmBsah0zRA/xGn6HHBALhLUZLhdTs9kcwY2m+8Q0equkdKIowxDG\n2PVY3lAYk9Md7e6G+XZmvkLnU7+7Y+InwZuSzq7+U5cMMGuo3dgu7l5/67heJ59c\nLTldjYxCm/wv8dxxlyZbES54DYAOS1NOnTrw6idsErdYpfKzHLVZ4hJR086NkZZl\nRD7XxICxOfnMcpfPBzDo9VZ/qaPrDQ2//d/k4jkhYMYvRB4k5t+dKR7ClXzolAGl\n++271tu0P27vtFFPvek+FhWpDACkAwjn6XJAvFZeTQKBgQDnqhennJF6ibE++wEc\nSVXPs0FjRbxtzpfO1R6F8Cj9wnkjj2cCQ4jY55Ew1GojTEVRsVb7jYFMlXGDbymK\n5Zs4fyCGoV/BcYnZZEG4AdLme0cYFpHDvgKng36pn0aSr2/Uft4N0v3vvzrtqO9p\nyi4EQUDGwgdzGvrRZgY8Nz8ivwKBgQDh7pD14aChZnQ/RKO/OPeAAij+PKKRTE64\nI3Lvm//yCB8N3/+CvNUT2SI3Vo+t6QAcROn3BkE0PxH21CBd2pqXwlb0lAWSUGEy\nmzCO1tskaJ1iXC9OzRDqz7yx5pwLfFxT1zHt3MkAGMikWcdUHJKpJLbM7EAsi1+g\nmbJ6iWdeuwKBgQCQxh9aQ+I2be4yqbIb90iFMETgwSfsh3sfathUY616SBpkOq3p\nIENZKf32QgjCXlvDncv6EIiJT6tMtB+GCc9jEy9Ec3zf6xB2pszbLWibWNcpGpGl\nfg0yml6BqmP0L2b3qQEkKoM/XIZ7F2Pm/M6dIhpVG9SD/oxYaCXlY7E1CQKBgQCC\nNUWiD3jNzAgu9lYQvLoXMieB7lwatQmhIfz5jsSBLqEHFBNju4Rpvff0QJTpu6Du\nqeDVFuu5OqgVwscsj/IMiFoo9q4HVv/NdJcVm0oMv6YEq/Av0Atx6Gttc+R20iM7\nxofl+Bp3TdFEtuEj3pu/k4MusvGBOonQOwQbjtjeRQKBgHpAZ6wRpwGLCYfwdLMo\nJEaj7dUmlsLczO44ge6AHn7j6zaQ+4FJ4pjP3Ndp6xL4TPuf2AvQ6q0Ejo1tOSTl\nghbkD4SnVpbPSLaWhHtq8pQ3hZsiqnugDyFxguE421AeZmizt+UoLsuK2oVnv1Cy\nvnSJc1deE+4sYnV5gQdhNDto\n-----END PRIVATE KEY-----\n",
  "client_email": "ta-78-945@bold-proton-325413.iam.gserviceaccount.com",
  "client_id": "112118118329412626001",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ta-78-945%40bold-proton-325413.iam.gserviceaccount.com"
}
''';
const _credprint = r'''{
  "type": "service_account",
  "project_id": "bold-proton-325413",
  "private_key_id": "99d2f06ce47a791dc967b4470f67e221077118c5",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDclhoeKVDKouek\n0jVzFu8KNiJ+YY7tAeEUlzGQNovTUFQzhBaIYDTV3yuFyP0uOae486ANedZMOqel\n5k8pSVD8Ps/QOk5q4YNs4l73uvySrXKNt7s8pTgQxn7FERKje3VsUH9V93TXFSoh\nJiU2XH5fzVDI3R9ar2rpbMuCYwRJAjoL5yxoHQl/irfotK1mE9r8CHfxZh1hOrHx\nprxwZtG585D0SOUL6Y1RITfysRcU0kdfsMXlrqC3aKLBcJl0myHP2vCjorILUN+0\nLdNhfRZLE3gTqAaTzywLgVvyoH+euf9kTdHJynRC6euF4FAgzlvvZ0QW0lYSVSqj\nfFtaquFjAgMBAAECggEAUH+0m1IviiuGBoex+sShSmQ0FVPr8UEwzy9X5o2JXH3h\npIUtJeqaDXyqaOHOx0pCE4RQ4eoXEu2K1celFueLFuqjMxW8HVQb/qXjy1shJjQG\n7IHi4gBXZAPUKn2PBDsfQH5l4czzBjTSkZNWnC6H7dVDCHJtqU3/4ZyS7gvNegiY\n1Qh18HEcQ3K/vDhR8x1WE3XTVI4mZ8m6tPmRq4iU/fJfOhx/Eembrq/WnXxV4Kon\n4WJseUfTMmxAMyX9sHcbQwR+s/FnoOP+76LGiVWYT70aVB6twXbln97UBzxTl3y/\nPrBeT7/1lqHW9OWdaK3gmKiC5acAM5CKe1TTQXF5KQKBgQD5+Dg8wk7E2CQKA3eT\nif++COs872qeHYe7l/e03DdwkHMCwFU1qRI6QubBewaGI+Zooq8sMdBJVibZLz7Y\n4LGKGeZj+UfSqpKIQwwBq8tsC0UIAo+IFds0fA+BWoJypmkTgvHZZDIPejOxtlH6\nlnp1HjyGJjNUEeHjk58ZYT13SwKBgQDh6Go+fQSZWRM6ypR7BQ4vufuubITDs1bh\nypHLsdqGJ442OOvlZMVxSnxdDYr8WtSwtgjliaCxQgoi7whbTEHhoXBAjlS7rV25\nf777mSqr0FTbUUrTQTTpe1lB5D7AwTrsIe3rBsLY3JAf0xJLQu37Pr3glNSzPz9e\nVWjeKxB3SQKBgQCFwG5+/E1fgHOQNBi4hj+kdGtCmKzI2+4zz3XIfYjgnzoa/8TY\nSJYrPH7yihyMjAsOc/YdRK45f3KcBW6wZ1I4HfGsDseCjqiHZrC2+DCJqGIQjiY0\n39UB+VvmkAJ6zFYvDYLRGo66v12HupGU7w2pOzuRYEFYu5TNy8B2uRRFjwKBgQCL\nuavVAJBSpMR/DYNu336ZyGfBx38KaCcpupgYq+WkKl0MboKBPKXeX5qyF0lKsodw\n0PaJumk4mccZOk0p4u2wt6BtXVtNRXp93GRsy5yX7mA90nb8WQ14CAH5/klOAXYH\nTSkRv/nOFgXSmUNsZ3Y4euMIQCWaxFjWaO9W0r35eQKBgGtnY6lQIo02zJb0g8ze\nUOBuBRby3Mov32wz+e7dDpzv+B7xNLJcMOcYzfj2qLXRzgT/VB+WbrjVzLYzXclD\nWeqY43H6X6FbaodLUm3PCiI/+EkakjOoZk/fIqk3dh+aIr0IQeUSAv5gIqtEiCN8\n7Ha1rJnfTDgP1tYB7qgiVK6o\n-----END PRIVATE KEY-----\n",
  "client_email": "print-735@bold-proton-325413.iam.gserviceaccount.com",
  "client_id": "101430865240282155592",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/print-735%40bold-proton-325413.iam.gserviceaccount.com"
}''';

/// Your spreadsheet id
///
/// It can be found in the link to your spreadsheet -
/// link looks like so https://docs.google.com/spreadsheets/d/YOUR_SPREADSHEET_ID/edit#gid=0
/// [YOUR_SPREADSHEET_ID] in the path is the id your need
const _spreadsheetId = '1Ijd_Ot2u4FKdNpoHoxrEv4pY5x3McVY3Ptnvibt5Fqg';
const _printId = '1yeP_eyq-5HK_PjQWPTU589az4nkcyZePTUoPYjJMz20';

class TambahLaporan extends StatefulWidget {
  const TambahLaporan({Key? key}) : super(key: key);

  @override
  State<TambahLaporan> createState() => _TambahLaporanState();
}

// List<String> _rusakPagarPerimeter = [];
Map<String, Map<String, String>> _rusakRunway = {};
Map<String, Map<String, String>> _rusakTaxiway = {};
Map<String, Map<String, String>> _rusakApron = {};
Map<String, Map<String, String>> _rusakRunwayStrip = {};
Map<String, Map<String, String>> _rusakDrainase = {};
Map<String, Map<String, String>> _rusakPagarPerimeter = {};
// String _runway = "{}";
// String _taxiway = "{}";
// String _apron = "{}";
String date = "";
bool dateLoaded = false;
bool dataLoaded = false;
// var sheet = ss.worksheetByTitle('data');
// create worksheet if it does not exist yet
List<String>? storedData;

class _TambahLaporanState extends State<TambahLaporan> {
  void updateData() {
    fetchData().then((List<String> data) {
      if (!dataLoaded) {
        setState(() {
          print(data);
          dataLoaded = true;
        });
      }
      ;
    });
  }

  void printToSpreadsheet() {}
  void getDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _date = prefs.getString('date');
    date = _date ?? '2022-06-27 10:53:50.058';
    // sheet ??= await ss.addWorksheet('data');
    if (!dateLoaded) setState(() {});
    dateLoaded = !dateLoaded;
  }

  void saveLaporan() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? currentData = prefs.getStringList('laporan');
    var map = {
      "Runway": jsonEncode(_rusakRunway),
      "Taxiway": jsonEncode(_rusakTaxiway),
      "Apron": jsonEncode(_rusakApron),
      "Runway Strip": jsonEncode(_rusakRunwayStrip),
      "Drainase": jsonEncode(_rusakDrainase),
      "Pagar Perimeter": jsonEncode(_rusakPagarPerimeter)
    };
    Map<String, Map<String, String>> tempData = {date: map};

    if (currentData != null) {
      for (var v in currentData) {
        var tempCurrentData = jsonDecode(v);

        print(v + "AK");
        var existingDate = DateTime.parse(tempCurrentData.keys.first);
        var stagedDate = DateTime.parse(date);
        // print(existingDate.day.toString() + "vs" + stagedDate.day.toString());
        if (isSameDay(existingDate, stagedDate)) {
          currentData.remove(v);
        }
      }
    }
    // print(jsonDecode(tempData[date]!.elementAt(0))['Permukaan Perkerasan']);
    await prefs.setStringList(
        'laporan', <String>[...?currentData, jsonEncode(tempData)]);
    printableData = tempData;
    storedData = prefs.getStringList('laporan');
    print(_rusakTaxiway.length);
    setTotalEvent((_rusakRunway.isNotEmpty ? 1 : 0) +
        (_rusakTaxiway.isNotEmpty ? 1 : 0) +
        (_rusakApron.isNotEmpty ? 1 : 0) +
        (_rusakRunwayStrip.isNotEmpty ? 1 : 0) +
        (_rusakDrainase.isNotEmpty ? 1 : 0) +
        (_rusakPagarPerimeter.isNotEmpty ? 1 : 0));
  }

  var ss;
  var ssprint;
  void saveSS() async {
    var sheet = ss.worksheetByTitle('data');
    await sheet.values.insertValue(storedData.toString(), column: 2, row: 2);
  }

  var printableData;
  void crySS() async {
    var sheet = ssprint.worksheetByTitle('data');
    var dateInExcel = printableData.keys.first;
    await sheet.values.insertValue(dateInExcel.toString(), column: 2, row: 2);
    Iterable<String> obyek = printableData[dateInExcel].keys;
    print(obyek);
    // var i = 2;
    // var j = 3;
    // obyek.forEach((element) {
    //   var dataKerusakan =
    //       jsonDecode(printableData[printableData.keys.first][element]);
    //   Iterable<String> kerusakan = dataKerusakan.keys;
    //   kerusakan.forEach((elementA) {
    //     var attribKerusakan = dataKerusakan[elementA];
    //     Iterable<String> attrib = attribKerusakan.keys;
    //     attrib.forEach((elementB) async {
    //       if (attrib.length == 5) {
    //         await sheet.values.insertValue(
    //             // attribKerusakan[elementB]
    //             //     .toString(),
    //             j,
    //             column: i,
    //             row: j);
    //         j++;
    //         print(j.toString() + elementB);
    //       }
    //     });
    //     // if (jsonDecode(
    //     //             printableData[printableData.keys.first][element])[elementA]
    //     //         .keys
    //     //         .length ==
    //     //     5) {
    //     //   await sheet.values.insertValue(
    //     //       jsonDecode(printableData[printableData.keys.first][element])[
    //     //               'Permukaan Perkerasan']['status']
    //     //           .toString(),
    //     //       column: i,
    //     //       row: j++);
    //     // }
    //   });
    // });
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Permukaan Perkerasan']['status']
            .toString(),
        column: 2,
        row: 3);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Permukaan Perkerasan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 3);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Permukaan Perkerasan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 3);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Permukaan Perkerasan']['tindakan']
            .toString(),
        column: 5,
        row: 3);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Permukaan Perkerasan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 3);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Konstruksi Perkerasan']['status']
            .toString(),
        column: 2,
        row: 4);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Konstruksi Perkerasan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 4);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Konstruksi Perkerasan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 4);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Konstruksi Perkerasan']['tindakan']
            .toString(),
        column: 5,
        row: 4);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Konstruksi Perkerasan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 4);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Marka']
                ['status']
            .toString(),
        column: 2,
        row: 5);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Marka']
                ['jenisKerusakan']
            .toString(),
        column: 3,
        row: 5);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Marka']
                ['levelKerusakan']
            .toString(),
        column: 4,
        row: 5);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Marka']
                ['tindakan']
            .toString(),
        column: 5,
        row: 5);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Marka']
                ['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 5);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Rambu']
                ['status']
            .toString(),
        column: 2,
        row: 6);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Rambu']
                ['jenisKerusakan']
            .toString(),
        column: 3,
        row: 6);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Rambu']
                ['levelKerusakan']
            .toString(),
        column: 4,
        row: 6);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Rambu']
                ['tindakan']
            .toString(),
        column: 5,
        row: 6);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])['Rambu']
                ['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 6);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Genangan Air']['status']
            .toString(),
        column: 2,
        row: 7);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Genangan Air']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 7);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Genangan Air']['levelKerusakan']
            .toString(),
        column: 4,
        row: 7);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Genangan Air']['tindakan']
            .toString(),
        column: 5,
        row: 7);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway'])[
                'Genangan Air']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 7);

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Permukaan Perkerasan']['status']
            .toString(),
        column: 2,
        row: 10);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Permukaan Perkerasan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 10);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Permukaan Perkerasan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 10);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Permukaan Perkerasan']['tindakan']
            .toString(),
        column: 5,
        row: 10);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Permukaan Perkerasan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 10);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Konstruksi Perkerasan']['status']
            .toString(),
        column: 2,
        row: 11);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Konstruksi Perkerasan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 11);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Konstruksi Perkerasan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 11);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Konstruksi Perkerasan']['tindakan']
            .toString(),
        column: 5,
        row: 11);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Konstruksi Perkerasan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 11);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Marka']
                ['status']
            .toString(),
        column: 2,
        row: 12);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Marka']
                ['jenisKerusakan']
            .toString(),
        column: 3,
        row: 12);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Marka']
                ['levelKerusakan']
            .toString(),
        column: 4,
        row: 12);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Marka']
                ['tindakan']
            .toString(),
        column: 5,
        row: 12);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Marka']
                ['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 12);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Rambu']
                ['status']
            .toString(),
        column: 2,
        row: 13);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Rambu']
                ['jenisKerusakan']
            .toString(),
        column: 3,
        row: 13);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Rambu']
                ['levelKerusakan']
            .toString(),
        column: 4,
        row: 13);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Rambu']
                ['tindakan']
            .toString(),
        column: 5,
        row: 13);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])['Rambu']
                ['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 13);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Genangan Air']['status']
            .toString(),
        column: 2,
        row: 14);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Genangan Air']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 14);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Genangan Air']['levelKerusakan']
            .toString(),
        column: 4,
        row: 14);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Genangan Air']['tindakan']
            .toString(),
        column: 5,
        row: 14);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Taxiway'])[
                'Genangan Air']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 14);

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Permukaan Perkerasan']['status']
            .toString(),
        column: 2,
        row: 17);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Permukaan Perkerasan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 17);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Permukaan Perkerasan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 17);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Permukaan Perkerasan']['tindakan']
            .toString(),
        column: 5,
        row: 17);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Permukaan Perkerasan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 17);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Konstruksi Perkerasan']['status']
            .toString(),
        column: 2,
        row: 18);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Konstruksi Perkerasan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 18);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Konstruksi Perkerasan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 18);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Konstruksi Perkerasan']['tindakan']
            .toString(),
        column: 5,
        row: 18);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Konstruksi Perkerasan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 18);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Marka']
                ['status']
            .toString(),
        column: 2,
        row: 19);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Marka']
                ['jenisKerusakan']
            .toString(),
        column: 3,
        row: 19);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Marka']
                ['levelKerusakan']
            .toString(),
        column: 4,
        row: 19);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Marka']
                ['tindakan']
            .toString(),
        column: 5,
        row: 19);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Marka']
                ['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 19);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Rambu']
                ['status']
            .toString(),
        column: 2,
        row: 20);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Rambu']
                ['jenisKerusakan']
            .toString(),
        column: 3,
        row: 20);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Rambu']
                ['levelKerusakan']
            .toString(),
        column: 4,
        row: 20);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Rambu']
                ['tindakan']
            .toString(),
        column: 5,
        row: 20);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])['Rambu']
                ['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 20);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Genangan Air']['status']
            .toString(),
        column: 2,
        row: 21);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Genangan Air']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 21);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Genangan Air']['levelKerusakan']
            .toString(),
        column: 4,
        row: 21);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Genangan Air']['tindakan']
            .toString(),
        column: 5,
        row: 21);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Apron'])[
                'Genangan Air']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 21);

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Permukaan']['status']
            .toString(),
        column: 2,
        row: 24);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Permukaan']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 24);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Permukaan']['levelKerusakan']
            .toString(),
        column: 4,
        row: 24);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Permukaan']['tindakan']
            .toString(),
        column: 5,
        row: 24);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Permukaan']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 24);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Rumput/Vegetasi']['status']
            .toString(),
        column: 2,
        row: 25);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Rumput/Vegetasi']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 25);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Rumput/Vegetasi']['levelKerusakan']
            .toString(),
        column: 4,
        row: 25);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Rumput/Vegetasi']['tindakan']
            .toString(),
        column: 5,
        row: 25);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Runway Strip'])[
                'Rumput/Vegetasi']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 25);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Konstruksi']['status']
            .toString(),
        column: 2,
        row: 28);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Konstruksi']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 28);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Konstruksi']['levelKerusakan']
            .toString(),
        column: 4,
        row: 28);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Konstruksi']['tindakan']
            .toString(),
        column: 5,
        row: 28);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Konstruksi']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 28);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Aliran']['status']
            .toString(),
        column: 2,
        row: 29);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Aliran']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 29);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Aliran']['levelKerusakan']
            .toString(),
        column: 4,
        row: 29);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Aliran']['tindakan']
            .toString(),
        column: 5,
        row: 29);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Drainase'])[
                'Aliran']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 29);
    //====================

    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Pagar Perimeter'])[
                'Kondisi Pagar']['status']
            .toString(),
        column: 2,
        row: 32);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Pagar Perimeter'])[
                'Kondisi Pagar']['jenisKerusakan']
            .toString(),
        column: 3,
        row: 32);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Pagar Perimeter'])[
                'Kondisi Pagar']['levelKerusakan']
            .toString(),
        column: 4,
        row: 32);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Pagar Perimeter'])[
                'Kondisi Pagar']['tindakan']
            .toString(),
        column: 5,
        row: 32);
    await sheet.values.insertValue(
        jsonDecode(printableData[printableData.keys.first]['Pagar Perimeter'])[
                'Kondisi Pagar']['lamaWaktuPerbaikan']
            .toString(),
        column: 6,
        row: 32);
    Uri url = Uri.parse(
        "https://docs.google.com/spreadsheets/d/1yeP_eyq-5HK_PjQWPTU589az4nkcyZePTUoPYjJMz20/edit#gid=1169548849");
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  callSS() async {
    // init GSheets
    final gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id
    ss = await gsheets.spreadsheet(_spreadsheetId);
    saveSS();
  }

  printSS() async {
    // init GSheets
    saveLaporan();
    final gsheets = GSheets(_credprint);
    // fetch spreadsheet by its id
    ssprint = await gsheets.spreadsheet(_printId);
    crySS();
  }

  void setTotalEvent(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total-event', total);
  }

  @override
  Widget build(BuildContext context) {
    const runway = [
      "Permukaan Perkerasan",
      "Konstruksi Perkerasan",
      "Marka",
      "Rambu",
      "Genangan Air"
    ];
    const taxiway = [
      "Permukaan Perkerasan",
      "Konstruksi Perkerasan",
      "Marka",
      "Rambu",
      "Genangan Air"
    ];
    const apron = [
      "Permukaan Perkerasan",
      "Konstruksi Perkerasan",
      "Marka",
      "Rambu",
      "Genangan Air"
    ];
    const runwayStrip = [
      "Permukaan",
      "Rumput/Vegetasi",
    ];
    const drainase = [
      "Konstruksi",
      "Aliran",
    ];
    const pagarPerimeter = ["Kondisi Pagar"];
    getDate();
    updateData();
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(DateTime.parse(date)),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('d MMM yyyy').format(DateTime.parse(date)),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Petugas'),
                      TextFormField(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('Cuaca'),
                      ),
                      TextFormField()
                    ]),
              ),
              Text(
                'Runway',
                //RUNWAY KERUSAKAN================================================
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...taxiway.map((e) {
                        return (_rusakRunway.containsKey(e))
                            ? Column(
                                children: [
                                  Container(
                                      // RUSAK
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text('${e}')),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _rusakRunway.remove(e);
                                                // _runway =
                                                //     jsonEncode(_rusakRunway);
                                                // saveLaporan();
                                                print(_rusakRunway);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Baik',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Rusak',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  color: Colors.white),
                                              color: Color.fromARGB(
                                                  255, 0, 45, 97),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Jenis Kerusakan"),
                                                value: _rusakRunway[e]
                                                    ?['jenisKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: ["Retak Setempat"]
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunway[e]![
                                                            'jenisKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text("Level Kerusakan"),
                                                value: _rusakRunway[e]
                                                    ?['levelKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Ringan",
                                                  "Sedang",
                                                  "Berat"
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunway[e]![
                                                            'levelKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Tindakan"),
                                                value: _rusakRunway[e]
                                                    ?['tindakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Patching",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunway[e]![
                                                        'tindakan'] = newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text(
                                                    "Lama Waktu Perbaikan"),
                                                value: _rusakRunway[e]
                                                    ?['lamaWaktuPerbaikan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "1 hari",
                                                  "2 hari",
                                                  "3 hari",
                                                  "4 hari",
                                                  "5 hari",
                                                  "6 hari",
                                                  "7 hari",
                                                  "8 hari",
                                                  "9 hari",
                                                  "10 hari",
                                                  "11 hari",
                                                  "12 hari",
                                                  "13 hari",
                                                  "14 hari",
                                                  "15 hari",
                                                  "16 hari",
                                                  "17 hari",
                                                  "18 hari",
                                                  "19 hari",
                                                  "20 hari",
                                                  "21 hari",
                                                  "22 hari",
                                                  "23 hari",
                                                  "24 hari",
                                                  "25 hari",
                                                  "26 hari",
                                                  "27 hari",
                                                  "28 hari",
                                                  "29 hari",
                                                  "30 hari",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunway[e]![
                                                            'lamaWaktuPerbaikan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : Container(
                                // GA RUSAK
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${e}')),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Baik',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.yellow,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _rusakRunway[e] = {
                                            "status": "rusak",
                                          };

                                          // saveLaporan();
                                          print(_rusakRunway);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Rusak',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final ImagePicker _picker =
                                            ImagePicker();

                                        _picker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then((XFile? media) {
                                          _rusakPagarPerimeter[e]!['foto'] =
                                              jsonEncode(media);
                                          Fluttertoast.showToast(
                                              msg: "Foto berhasil diunggah.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.white),
                                        color: Color.fromARGB(255, 0, 45, 97),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ));
                      }).toList(),
                    ]),
              ),
              Text(
                'Taxiway',
                //TAXIWAY KERUSAKAN================================================
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...runway.map((e) {
                        return (_rusakTaxiway.containsKey(e))
                            ? Column(
                                children: [
                                  Container(
                                      // RUSAK
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text('${e}')),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _rusakTaxiway.remove(e);

                                                // saveLaporan();
                                                print(_rusakTaxiway);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Baik',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Rusak',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  color: Colors.white),
                                              color: Color.fromARGB(
                                                  255, 0, 45, 97),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Jenis Kerusakan"),
                                                value: _rusakTaxiway[e]
                                                    ?['jenisKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: ["Retak Setempat"]
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakTaxiway[e]![
                                                            'jenisKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text("Level Kerusakan"),
                                                value: _rusakTaxiway[e]
                                                    ?['levelKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Ringan",
                                                  "Sedang",
                                                  "Berat"
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakTaxiway[e]![
                                                            'levelKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Tindakan"),
                                                value: _rusakTaxiway[e]
                                                    ?['tindakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Patching",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakTaxiway[e]![
                                                        'tindakan'] = newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text(
                                                    "Lama Waktu Perbaikan"),
                                                value: _rusakTaxiway[e]
                                                    ?['lamaWaktuPerbaikan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "1 hari",
                                                  "2 hari",
                                                  "3 hari",
                                                  "4 hari",
                                                  "5 hari",
                                                  "6 hari",
                                                  "7 hari",
                                                  "8 hari",
                                                  "9 hari",
                                                  "10 hari",
                                                  "11 hari",
                                                  "12 hari",
                                                  "13 hari",
                                                  "14 hari",
                                                  "15 hari",
                                                  "16 hari",
                                                  "17 hari",
                                                  "18 hari",
                                                  "19 hari",
                                                  "20 hari",
                                                  "21 hari",
                                                  "22 hari",
                                                  "23 hari",
                                                  "24 hari",
                                                  "25 hari",
                                                  "26 hari",
                                                  "27 hari",
                                                  "28 hari",
                                                  "29 hari",
                                                  "30 hari",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakTaxiway[e]![
                                                            'lamaWaktuPerbaikan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : Container(
                                // GA RUSAK
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${e}')),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Baik',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.yellow,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _rusakTaxiway[e] = {
                                            "status": "rusak",
                                          };
                                          // saveLaporan();
                                          print(_rusakTaxiway);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Rusak',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final ImagePicker _picker =
                                            ImagePicker();

                                        _picker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then((XFile? media) {
                                          _rusakPagarPerimeter[e]!['foto'] =
                                              jsonEncode(media);
                                          Fluttertoast.showToast(
                                              msg: "Foto berhasil diunggah.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.white),
                                        color: Color.fromARGB(255, 0, 45, 97),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ));
                      }).toList(),
                    ]),
              ),
              Text(
                'Apron',
                //APRON KERUSAKAN================================================
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...apron.map((e) {
                        return (_rusakApron.containsKey(e))
                            ? Column(
                                children: [
                                  Container(
                                      // RUSAK
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text('${e}')),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _rusakApron.remove(e);

                                                // saveLaporan();
                                                print(_rusakApron);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Baik',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Rusak',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  color: Colors.white),
                                              color: Color.fromARGB(
                                                  255, 0, 45, 97),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Jenis Kerusakan"),
                                                value: _rusakApron[e]
                                                    ?['jenisKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: ["Retak Setempat"]
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakApron[e]![
                                                            'jenisKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text("Level Kerusakan"),
                                                value: _rusakApron[e]
                                                    ?['levelKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Ringan",
                                                  "Sedang",
                                                  "Berat"
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakApron[e]![
                                                            'levelKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Tindakan"),
                                                value: _rusakApron[e]
                                                    ?['tindakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Patching",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakApron[e]![
                                                        'tindakan'] = newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text(
                                                    "Lama Waktu Perbaikan"),
                                                value: _rusakApron[e]
                                                    ?['lamaWaktuPerbaikan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "1 hari",
                                                  "2 hari",
                                                  "3 hari",
                                                  "4 hari",
                                                  "5 hari",
                                                  "6 hari",
                                                  "7 hari",
                                                  "8 hari",
                                                  "9 hari",
                                                  "10 hari",
                                                  "11 hari",
                                                  "12 hari",
                                                  "13 hari",
                                                  "14 hari",
                                                  "15 hari",
                                                  "16 hari",
                                                  "17 hari",
                                                  "18 hari",
                                                  "19 hari",
                                                  "20 hari",
                                                  "21 hari",
                                                  "22 hari",
                                                  "23 hari",
                                                  "24 hari",
                                                  "25 hari",
                                                  "26 hari",
                                                  "27 hari",
                                                  "28 hari",
                                                  "29 hari",
                                                  "30 hari",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakApron[e]![
                                                            'lamaWaktuPerbaikan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : Container(
                                // GA RUSAK
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${e}')),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Baik',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.yellow,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _rusakApron[e] = {
                                            "status": "rusak",
                                          };
                                          // saveLaporan();
                                          print(_rusakApron);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Rusak',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final ImagePicker _picker =
                                            ImagePicker();

                                        _picker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then((XFile? media) {
                                          _rusakPagarPerimeter[e]!['foto'] =
                                              jsonEncode(media);
                                          Fluttertoast.showToast(
                                              msg: "Foto berhasil diunggah.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.white),
                                        color: Color.fromARGB(255, 0, 45, 97),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ));
                      }).toList(),
                    ]),
              ),
              Text(
                'Runway Strip',
                //RUNWAY STRIP KERUSAKAN================================================
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...runwayStrip.map((e) {
                        return (_rusakRunwayStrip.containsKey(e))
                            ? Column(
                                children: [
                                  Container(
                                      // RUSAK
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text('${e}')),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _rusakRunwayStrip.remove(e);

                                                // saveLaporan();
                                                print(_rusakRunwayStrip);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Baik',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Rusak',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  color: Colors.white),
                                              color: Color.fromARGB(
                                                  255, 0, 45, 97),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Jenis Kerusakan"),
                                                value: _rusakRunwayStrip[e]
                                                    ?['jenisKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: ["Retak Setempat"]
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunwayStrip[e]![
                                                            'jenisKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text("Level Kerusakan"),
                                                value: _rusakRunwayStrip[e]
                                                    ?['levelKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Ringan",
                                                  "Sedang",
                                                  "Berat"
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunwayStrip[e]![
                                                            'levelKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Tindakan"),
                                                value: _rusakRunwayStrip[e]
                                                    ?['tindakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Patching",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunwayStrip[e]![
                                                        'tindakan'] = newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text(
                                                    "Lama Waktu Perbaikan"),
                                                value: _rusakRunwayStrip[e]
                                                    ?['lamaWaktuPerbaikan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "1 hari",
                                                  "2 hari",
                                                  "3 hari",
                                                  "4 hari",
                                                  "5 hari",
                                                  "6 hari",
                                                  "7 hari",
                                                  "8 hari",
                                                  "9 hari",
                                                  "10 hari",
                                                  "11 hari",
                                                  "12 hari",
                                                  "13 hari",
                                                  "14 hari",
                                                  "15 hari",
                                                  "16 hari",
                                                  "17 hari",
                                                  "18 hari",
                                                  "19 hari",
                                                  "20 hari",
                                                  "21 hari",
                                                  "22 hari",
                                                  "23 hari",
                                                  "24 hari",
                                                  "25 hari",
                                                  "26 hari",
                                                  "27 hari",
                                                  "28 hari",
                                                  "29 hari",
                                                  "30 hari",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakRunwayStrip[e]![
                                                            'lamaWaktuPerbaikan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : Container(
                                // GA RUSAK
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${e}')),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Baik',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.yellow,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _rusakRunwayStrip[e] = {
                                            "status": "rusak",
                                          };
                                          // saveLaporan();
                                          print(_rusakRunwayStrip);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Rusak',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final ImagePicker _picker =
                                            ImagePicker();

                                        _picker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then((XFile? media) {
                                          _rusakPagarPerimeter[e]!['foto'] =
                                              jsonEncode(media);
                                          Fluttertoast.showToast(
                                              msg: "Foto berhasil diunggah.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.white),
                                        color: Color.fromARGB(255, 0, 45, 97),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ));
                      }).toList(),
                    ]),
              ),
              Text(
                'Drainase',
                //DRAINASE KERUSAKAN================================================
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...drainase.map((e) {
                        return (_rusakDrainase.containsKey(e))
                            ? Column(
                                children: [
                                  Container(
                                      // RUSAK
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text('${e}')),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _rusakDrainase.remove(e);

                                                // saveLaporan();
                                                print(_rusakDrainase);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Baik',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Rusak',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  color: Colors.white),
                                              color: Color.fromARGB(
                                                  255, 0, 45, 97),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Jenis Kerusakan"),
                                                value: _rusakDrainase[e]
                                                    ?['jenisKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: ["Retak Setempat"]
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakDrainase[e]![
                                                            'jenisKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text("Level Kerusakan"),
                                                value: _rusakDrainase[e]
                                                    ?['levelKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Ringan",
                                                  "Sedang",
                                                  "Berat"
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakDrainase[e]![
                                                            'levelKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Tindakan"),
                                                value: _rusakDrainase[e]
                                                    ?['tindakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Patching",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakDrainase[e]![
                                                        'tindakan'] = newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text(
                                                    "Lama Waktu Perbaikan"),
                                                value: _rusakDrainase[e]
                                                    ?['lamaWaktuPerbaikan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "1 hari",
                                                  "2 hari",
                                                  "3 hari",
                                                  "4 hari",
                                                  "5 hari",
                                                  "6 hari",
                                                  "7 hari",
                                                  "8 hari",
                                                  "9 hari",
                                                  "10 hari",
                                                  "11 hari",
                                                  "12 hari",
                                                  "13 hari",
                                                  "14 hari",
                                                  "15 hari",
                                                  "16 hari",
                                                  "17 hari",
                                                  "18 hari",
                                                  "19 hari",
                                                  "20 hari",
                                                  "21 hari",
                                                  "22 hari",
                                                  "23 hari",
                                                  "24 hari",
                                                  "25 hari",
                                                  "26 hari",
                                                  "27 hari",
                                                  "28 hari",
                                                  "29 hari",
                                                  "30 hari",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakDrainase[e]![
                                                            'lamaWaktuPerbaikan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : Container(
                                // GA RUSAK
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${e}')),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Baik',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.yellow,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _rusakDrainase[e] = {
                                            "status": "rusak",
                                          };
                                          // saveLaporan();
                                          print(_rusakDrainase);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Rusak',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final ImagePicker _picker =
                                            ImagePicker();

                                        _picker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then((XFile? media) {
                                          _rusakPagarPerimeter[e]!['foto'] =
                                              jsonEncode(media);
                                          Fluttertoast.showToast(
                                              msg: "Foto berhasil diunggah.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.white),
                                        color: Color.fromARGB(255, 0, 45, 97),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ));
                      }).toList(),
                    ]),
              ),
              Text(
                'Pagar Perimeter',
                //PAGAR PERIMETER KERUSAKAN================================================
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...pagarPerimeter.map((e) {
                        return (_rusakPagarPerimeter.containsKey(e))
                            ? Column(
                                children: [
                                  Container(
                                      // RUSAK
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text('${e}')),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _rusakPagarPerimeter.remove(e);

                                                // saveLaporan();
                                                print(_rusakPagarPerimeter);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Baik',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Text('Rusak',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 30,
                                              width: 80,
                                              child: Icon(
                                                  Icons.add_a_photo_rounded,
                                                  color: Colors.white),
                                              color: Color.fromARGB(
                                                  255, 0, 45, 97),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Jenis Kerusakan"),
                                                value: _rusakPagarPerimeter[e]
                                                    ?['jenisKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: ["Retak Setempat"]
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakPagarPerimeter[e]![
                                                            'jenisKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text("Level Kerusakan"),
                                                value: _rusakPagarPerimeter[e]
                                                    ?['levelKerusakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Ringan",
                                                  "Sedang",
                                                  "Berat"
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakPagarPerimeter[e]![
                                                            'levelKerusakan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton(
                                                hint: Text("Tindakan"),
                                                value: _rusakPagarPerimeter[e]
                                                    ?['tindakan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "Patching",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakPagarPerimeter[e]![
                                                        'tindakan'] = newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                              DropdownButton(
                                                hint: Text(
                                                    "Lama Waktu Perbaikan"),
                                                value: _rusakPagarPerimeter[e]
                                                    ?['lamaWaktuPerbaikan'],
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: [
                                                  "1 hari",
                                                  "2 hari",
                                                  "3 hari",
                                                  "4 hari",
                                                  "5 hari",
                                                  "6 hari",
                                                  "7 hari",
                                                  "8 hari",
                                                  "9 hari",
                                                  "10 hari",
                                                  "11 hari",
                                                  "12 hari",
                                                  "13 hari",
                                                  "14 hari",
                                                  "15 hari",
                                                  "16 hari",
                                                  "17 hari",
                                                  "18 hari",
                                                  "19 hari",
                                                  "20 hari",
                                                  "21 hari",
                                                  "22 hari",
                                                  "23 hari",
                                                  "24 hari",
                                                  "25 hari",
                                                  "26 hari",
                                                  "27 hari",
                                                  "28 hari",
                                                  "29 hari",
                                                  "30 hari",
                                                ].map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _rusakPagarPerimeter[e]![
                                                            'lamaWaktuPerbaikan'] =
                                                        newValue!;
                                                    // saveLaporan();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : Container(
                                // GA RUSAK
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${e}')),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Baik',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.yellow,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _rusakPagarPerimeter[e] = {
                                            "status": "rusak",
                                          };
                                          // saveLaporan();
                                          print(_rusakPagarPerimeter);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Text('Rusak',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final ImagePicker _picker =
                                            ImagePicker();

                                        _picker
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then((XFile? media) {
                                          _rusakPagarPerimeter[e]!['foto'] =
                                              jsonEncode(media);
                                          Fluttertoast.showToast(
                                              msg: "Foto berhasil diunggah.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        height: 30,
                                        width: 80,
                                        child: Icon(Icons.add_a_photo_rounded,
                                            color: Colors.white),
                                        color: Color.fromARGB(255, 0, 45, 97),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ));
                      }).toList(),
                    ]),
              ),
              Container(
                  // Tombol Bawah
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text('')),
                      InkWell(
                        onTap: () {
                          printSS();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: 80,
                          child: Text('Cetak',
                              style: TextStyle(color: Colors.white)),
                          color: Color.fromARGB(255, 0, 45, 97),
                          alignment: Alignment.center,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          callSS();
                          saveLaporan();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: 80,
                          child: Text('Simpan',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.green,
                          alignment: Alignment.center,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: 90,
                          child: Icon(Icons.add_a_photo_rounded,
                              color: Colors.white),
                          color: Colors.transparent,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
