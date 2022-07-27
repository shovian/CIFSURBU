import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:ta/main.dart';

/// Your google auth credentials
///
/// how to get credentials - https://medium.com/@a.marenkov/how-to-get-credentials-for-google-sheets-456b7e88c430
const _credentials =
    r'''
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

/// Your spreadsheet id
///
/// It can be found in the link to your spreadsheet -
/// link looks like so https://docs.google.com/spreadsheets/d/YOUR_SPREADSHEET_ID/edit#gid=0
/// [YOUR_SPREADSHEET_ID] in the path is the id your need
const _spreadsheetId = '1Ijd_Ot2u4FKdNpoHoxrEv4pY5x3McVY3Ptnvibt5Fqg';
var ss;
callSS() async {
  // init GSheets
  final gsheets = GSheets(_credentials);
  // fetch spreadsheet by its id
  ss = await gsheets.spreadsheet(_spreadsheetId);
}

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final List<String> textFieldsValue = [];
  @override
  Widget build(BuildContext context) {
    callSS();
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.amber,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
          // ),
          child: Center(
            child: Wrap(children: [
              Container(
                width: 220,
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    // margin: EdgeInsets.all(10),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Checklist Inspeksi Rutin Harian Kantor Unit Pelayanan Bandar Udara',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              margin: EdgeInsets.all(10),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'email'),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  textFieldsValue.add(value);
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'password'),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  textFieldsValue.add(value);
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    String _user = textFieldsValue.elementAt(0);
                                    String _pass = textFieldsValue.elementAt(1);
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.

                                    var sheet = ss.worksheetByTitle('user');
                                    final _userColumn =
                                        await sheet.values.column(1);
                                    final _passColumn =
                                        await sheet.values.column(2);
                                    if (_userColumn.contains(_user)) {
                                      final _index = _userColumn.indexOf(_user);
                                      print(_index);
                                      if (_passColumn.elementAt(_index) ==
                                          _pass) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Login dengan user $_user berhasil!')),
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyHomePage(
                                                    title: 'Tugas Akhir',
                                                    user: _user,
                                                  )),
                                        );
                                      }
                                    }
                                  }
                                  textFieldsValue.clear();
                                },
                                child: const Text('Login'),
                              ),
                            ),
                            // Add TextFormFields and ElevatedButton here.
                          ],
                        ),
                      )),
                    )),
              )
            ]),
          ) // Foreground widget here
          ),
    );
  }
}
