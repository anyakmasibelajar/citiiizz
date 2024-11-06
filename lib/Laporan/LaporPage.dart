import 'package:flutter/material.dart';
import 'package:myapp/Laporan/AddLaporanPage.dart';
import 'package:myapp/Laporan/Laporan.dart';

class LaporPage extends StatefulWidget {
  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  final List<Laporan> laporanList = [
    Laporan(
      kategori: 'Arus Lalu Lintas',
      deskripsi: 'macet parah, sudah 1 jam ga gerak sama sekali',
      lokasi: 'Menteng',
      waktu: 'Baru saja',
      status: 'Menunggu',
    ),
    Laporan(
      kategori: 'Perizinan, Ketertiban, Ketentraman',
      deskripsi: 'Bangunan Jl. Maju Bersama no 7 melanggar pergub...',
      lokasi: 'Pasar Minggu',
      waktu: '1 menit yang lalu',
      status: 'Menunggu',
    ),
    Laporan(
      kategori: 'Coretan Liar',
      deskripsi: 'Dinding ruko depan rumah saya jadi terlihat tidak estetik',
      lokasi: 'Tanjung Barat',
      waktu: '1 menit yang lalu',
      status: 'Menunggu',
    ),
  ];

  List<Laporan> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList = laporanList;
    searchController.addListener(_filterLaporan);
  }

  void _filterLaporan() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = laporanList
          .where((laporan) =>
              laporan.deskripsi.toLowerCase().contains(query) ||
              laporan.kategori.toLowerCase().contains(query) ||
              laporan.lokasi.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterLaporan);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
  title: Text(
    'Laporan Warga',
    style: TextStyle(
      fontWeight: FontWeight.bold, // Make the title bold
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set background color to blue
  actions: [
    TextButton(
      onPressed: () {},
      child: Text(
        'Laporan Saya',
        style: TextStyle(color: Colors.blue), // Make the text white
      ),
    ),
  ],
),

      body: Column(
        children: [
          Padding(
  padding: EdgeInsets.all(16.0),
  child: TextField(
    controller: searchController,
    decoration: InputDecoration(
      hintText: 'Cari laporan',
      prefixIcon: Icon(Icons.search, color: Colors.blue), // Change icon color to blue
      filled: true, // Fill the box with a color
      fillColor: Color.fromARGB(255, 235, 246, 255), // Set the background color to light grey
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.blue), // Border color when idle
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue border when focused
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.blue, width: 1.0), // Blue border when enabled
      ),
    ),
  ),
),


          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final laporan = filteredList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                        'https://via.placeholder.com/50'), // Ganti dengan gambar laporan jika tersedia
                    title: Text(laporan.deskripsi),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${laporan.kategori} - ${laporan.lokasi}'),
                        Text(laporan.waktu),
                      ],
                    ),
                    trailing: Icon(Icons.bookmark_border),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLaporanPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
