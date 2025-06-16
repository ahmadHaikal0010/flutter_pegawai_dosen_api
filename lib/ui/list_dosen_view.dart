import 'package:flutter/material.dart';
import 'package:flutter_pegawai_dosen_api/model/model_dosen.dart';
import 'package:http/http.dart' as http;

class ListDosenView extends StatefulWidget {
  const ListDosenView({super.key});

  @override
  State<ListDosenView> createState() => _ListDosenViewState();
}

class _ListDosenViewState extends State<ListDosenView> {
  late Future<List<ModelDosen>?> futureDosens;

  Future<List<ModelDosen>?> fetchDosens() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.56.1:8000/api/dosen'),
      );

      if (response.statusCode == 200) {
        return modelDosenFromJson(response.body);
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      // Tampilkan pesan error jika gagal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    futureDosens = fetchDosens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Dosen')),
      body: FutureBuilder<List<ModelDosen>?>(
        future: futureDosens,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat data'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Data dosen kosong'));
          } else {
            final dosens = snapshot.data!;
            return ListView.builder(
              itemCount: dosens.length,
              itemBuilder: (context, index) {
                final dosen = dosens[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(dosen.namaLengkap[0].toUpperCase()),
                    ),
                    title: Text(dosen.namaLengkap),
                    subtitle: Text('NIP: ${dosen.nip}\nEmail: ${dosen.email}'),
                    isThreeLine: true,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
