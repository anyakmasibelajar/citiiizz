import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Akun/LoginScreen.dart';
import 'package:myapp/Controller/HomeController.dart';

class ProfileScreen extends StatelessWidget {
  final HomeController homeController =
      Get.find<HomeController>(); // Mengambil instance HomeController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Obx(() => Text(
                  'Username: ${homeController.username.value}',
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(height: 20),
            Obx(() => Text(
                  'Saldo: Rp ${homeController.balance.value}',
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _showEditProfileDialog(context); // Panggil dialog edit profil
              },
              child: const Text('Edit Profil'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman login dan hapus semua halaman sebelumnya
                Get.offAll(() => LoginScreen()); // Ganti LoginScreen dengan nama kelas Anda untuk halaman login
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController editController = TextEditingController();
    editController.text = homeController
        .username.value; // Set nilai awal dari TextEditingController

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: 'Nama Pengguna',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                homeController.username.value =
                    editController.text; // Perbarui username
                Get.back(); // Tutup dialog
                Get.snackbar('Sukses',
                    'Nama profil berhasil diubah!'); // Tampilkan snackbar
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}
