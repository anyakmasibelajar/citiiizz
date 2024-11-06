import 'package:flutter/material.dart';

class AddLaporanPage extends StatefulWidget {
  @override
  _AddLaporanPageState createState() => _AddLaporanPageState();
}

class _AddLaporanPageState extends State<AddLaporanPage> {
  final _kategoriController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _kategoriController,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lokasiController,
              decoration: InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan laporan baru di sini
              },
              child: Text('Laporkan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _kategoriController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }
}
