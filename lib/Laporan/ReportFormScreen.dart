import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportFormScreen extends StatefulWidget {
  @override
  _ReportFormScreenState createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  File? _image;
  bool _isUploading = false;

  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeri'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kamera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _image == null) {
      Get.snackbar('Error', 'Please complete all fields and select an image');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('reports/${DateTime.now().toIso8601String()}');
      await storageRef.putFile(_image!);
      final imageUrl = await storageRef.getDownloadURL();

      // Save report data to Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(),
      });

      Get.snackbar('Success', 'Report submitted successfully');
      Get.back(); // Navigate back after submission
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit report: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Isi Laporan',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white), // Panah kembali putih
      backgroundColor: const Color.fromRGBO(83, 127, 232, 1),
    ),
    backgroundColor: Colors.white, // Background halaman putih
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Lengkapi Informasi Laporan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(83, 127, 232, 1),
            ),
          ),
          SizedBox(height: 16),
          _buildInputSection(
            label: 'Judul',
            controller: _titleController,
            hintText: 'Masukkan judul singkat laporan',
          ),
          SizedBox(height: 16),
          _buildInputSection(
            label: 'Deskripsi',
            controller: _descriptionController,
            hintText: 'Deskripsikan masalah yang ingin dilaporkan',
            maxLines: 4,
          ),
          SizedBox(height: 16),
          _buildInputSection(
            label: 'Lokasi',
            controller: _locationController,
            hintText: 'Masukkan lokasi terjadinya masalah',
          ),
          SizedBox(height: 16),
          Text(
            'Foto Bukti',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          _image == null
              ? Text(
                  'No image selected',
                  style: TextStyle(color: Colors.black54),
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _image!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _image = null; // Hapus foto
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _showImageSourceDialog,
            icon: Icon(Icons.add_a_photo, color: Colors.white), // Icon putih
            label: Text('Tambahkan Foto', style: TextStyle(color: Colors.white)), // Teks putih
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(83, 127, 231, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: _isUploading
    ? CircularProgressIndicator()
    : FloatingActionButton(
        onPressed: _submitReport,
        child: Icon(Icons.send, color: Colors.white), // White icon
        backgroundColor: const Color.fromRGBO(83, 127, 231, 1),
        shape: CircleBorder(), // Ensures the button is perfectly round
        elevation: 0, // Removes the shadow
      ),
  );
}

  Widget _buildInputSection({
  required String label,
  required TextEditingController controller,
  required String hintText,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      SizedBox(height: 8),
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black), // Border hitam default
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: const Color.fromRGBO(83, 127, 232, 1)), // Border biru saat fokus
          ),
          filled: true,
          fillColor: Colors.white, // Background putih
        ),
      ),
    ],
  );
}


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
