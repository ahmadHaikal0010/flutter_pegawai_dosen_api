import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDosenView extends StatefulWidget {
  final Map<String, dynamic> dosen;
  const EditDosenView({super.key, required this.dosen});

  @override
  State<EditDosenView> createState() => _EditDosenViewState();
}

class _EditDosenViewState extends State<EditDosenView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nipController;
  late TextEditingController namaController;
  late TextEditingController teleponController;
  late TextEditingController emailController;
  late TextEditingController alamatController;

  @override
  void initState() {
    super.initState();
    nipController = TextEditingController(text: widget.dosen['nip']);
    namaController = TextEditingController(text: widget.dosen['nama_lengkap']);
    teleponController = TextEditingController(text: widget.dosen['no_telepon']);
    emailController = TextEditingController(text: widget.dosen['email']);
    alamatController = TextEditingController(text: widget.dosen['alamat']);
  }

  Future<void> editDosen() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.put(
          Uri.parse('http://192.168.56.1:8000/api/dosen/${widget.dosen['no']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "nip": nipController.text,
            "nama_lengkap": namaController.text,
            "no_telepon": teleponController.text,
            "email": emailController.text,
            "alamat": alamatController.text,
          }),
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil dirubah')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal rubah data (${response.statusCode})'),
            ),
          );
          debugPrint("Response: ${response.body}");
        }
      } catch (e) {
        debugPrint("Error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Dosen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'NIP wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nama wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'No. Telepon wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Email wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Alamat wajib diisi'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: editDosen, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
