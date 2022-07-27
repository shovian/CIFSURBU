import 'package:flutter/material.dart';

class Notif extends StatefulWidget {
  const Notif({Key? key}) : super(key: key);

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    const _notif = {
      0: {'namaLaporan': 'Resignation', 'timestamp': '25 menit lalu'},
      1: {'namaLaporan': 'Waduk Tawas', 'timestamp': '25 menit lalu'}
    };
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          // children: <Widget>[
          //   ListTile(
          //     title: Text('Laporan XXXX Telah Diterima'),
          //     subtitle: Text('25 menit yang lalu'),
          //   ),
          //   ListTile(
          //     title: Text('Laporan XXXX Telah Diterima'),
          //     subtitle: Text('25 menit yang lalu'),
          //   ),
          //   ListTile(
          //     title: Text('Laporan XXXX Telah Diterima'),
          //     subtitle: Text('25 menit yang lalu'),
          //   ),
          //   ListTile(
          //     title: Text('Laporan XXXX Telah Diterima'),
          //     subtitle: Text('25 menit yang lalu'),
          //   ),
          // ],
          children: _notif.entries.map((entry) {
            var ek = entry.value['namaLaporan'];
            var w = ListTile(
              title: Text('Laporan $ek Telah Diterima'),
              subtitle: Text('25 menit yang lalu'),
              onTap: () {},
            );
            return w;
          }).toList()),
    );
  }
}
