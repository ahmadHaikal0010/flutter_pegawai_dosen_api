import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahDosenView extends StatefulWidget {
  const TambahDosenView({super.key});

  @override
  State<TambahDosenView> createState() => _TambahDosenViewState();
}

class _TambahDosenViewState extends State<TambahDosenView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  Future<void> simpanDosen() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.56.1:8000/api/dosen'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "nip": nipController.text,
            "nama_lengkap": namaController.text,
            "no_telepon": teleponController.text,
            "email": emailController.text,
            "alamat": alamatController.text,
          }),
        );

        if (response.statusCode == 201) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil ditambahkan')),
          );
          Navigator.pop(context); // kembali ke list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal tambah data (${response.statusCode})'),
            ),
          );
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Dosen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator: (value) => value!.isEmpty ? 'NIP wajib diisi' : null,
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator:
                    (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
                validator:
                    (value) => value!.isEmpty ? 'No telepon wajib diisi' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) => value!.isEmpty ? 'Email wajib diisi' : null,
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator:
                    (value) => value!.isEmpty ? 'Alamat wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpanDosen,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
