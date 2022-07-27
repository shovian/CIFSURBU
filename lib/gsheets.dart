import 'package:gsheets/gsheets.dart';

/// Your google auth credentials
///
/// how to get credentials - https://medium.com/@a.marenkov/how-to-get-credentials-for-google-sheets-456b7e88c430
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

/// Your spreadsheet id
///
/// It can be found in the link to your spreadsheet -
/// link looks like so https://docs.google.com/spreadsheets/d/YOUR_SPREADSHEET_ID/edit#gid=0
/// [YOUR_SPREADSHEET_ID] in the path is the id your need
const _spreadsheetId = '1Ijd_Ot2u4FKdNpoHoxrEv4pY5x3McVY3Ptnvibt5Fqg';

void main() async {
  // init GSheets
  final gsheets = GSheets(_credentials);
  // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(_spreadsheetId);

  print(ss.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));

  // get worksheet by its title
  var sheet = ss.worksheetByTitle('example');
  // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet('example');

  // update cell at 'B2' by inserting string 'new'
  await sheet.values.insertValue('new', column: 2, row: 2);
  // prints 'new'
  print(await sheet.values.value(column: 2, row: 2));
  // get cell at 'B2' as Cell object
  final row = await sheet.values.column(1);
  final celal = row.indexOf('1');

  print('AAAAAA');
  print(celal);
  final cell = await sheet.cells.cell(column: 2, row: 2);
  // prints 'new'
  print(cell.value);
  // update cell at 'B2' by inserting 'new2'
  await cell.post('new2');
  // prints 'new2'
  print(cell.value);
  // also prints 'new2'
  print(await sheet.values.value(column: 2, row: 2));

  // insert list in row #1
  final firstRow = ['index', 'letter', 'number', 'label'];
  await sheet.values.insertRow(1, firstRow);
  // prints [index, letter, number, label]
  print(await sheet.values.row(1));

  // insert list in column 'A', starting from row #2
  final firstColumn = ['0', '1', '2', '3', '4'];
  await sheet.values.insertColumn(1, firstColumn, fromRow: 2);
  // prints [0, 1, 2, 3, 4, 5]
  print(await sheet.values.column(1, fromRow: 2));

  // insert list into column named 'letter'
  final secondColumn = ['a', 'b', 'c', 'd', 'e'];
  await sheet.values.insertColumnByKey('letter', secondColumn);
  // prints [a, b, c, d, e, f]
  print(await sheet.values.columnByKey('letter'));

  // insert map values into column 'C' mapping their keys to column 'A'
  // order of map entries does not matter
  final thirdColumn = {
    '0': '1',
    '1': '2',
    '2': '3',
    '3': '4',
    '4': '5',
  };
  await sheet.values.map.insertColumn(3, thirdColumn, mapTo: 1);
  // prints {index: number, 0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6}
  print(await sheet.values.map.column(3));

  // insert map values into column named 'label' mapping their keys to column
  // named 'letter'
  // order of map entries does not matter
  final fourthColumn = {
    'a': 'a1',
    'b': 'b2',
    'c': 'c3',
    'd': 'd4',
    'e': 'e5',
  };
  await sheet.values.map.insertColumnByKey(
    'label',
    fourthColumn,
    mapTo: 'letter',
  );
  // prints {a: a1, b: b2, c: c3, d: d4, e: e5, f: f6}
  print(await sheet.values.map.columnByKey('label', mapTo: 'letter'));

  // appends map values as new row at the end mapping their keys to row #1
  // order of map entries does not matter
  final secondRow = {
    'index': '5',
    'letter': 'f',
    'number': '6',
    'label': 'f6',
  };
  await sheet.values.map.appendRow(secondRow);
  // prints {index: 5, letter: f, number: 6, label: f6}
  print(await sheet.values.map.lastRow());

  // get first row as List of Cell objects
  final cellsRow = await sheet.cells.row(1);
  // update each cell's value by adding char '_' at the beginning
  cellsRow.forEach((cell) => cell.value = '_${cell.value}');
  // actually updating sheets cells
  await sheet.cells.insert(cellsRow);
  // prints [_index, _letter, _number, _label]
  print(await sheet.values.row(1));
}
