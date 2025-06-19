import 'package:flutter/material.dart';
import 'package:flutter_pegawai_dosen_api/model/model_dosen.dart';
import 'package:flutter_pegawai_dosen_api/ui/edit_dosen_view.dart';
import 'package:flutter_pegawai_dosen_api/ui/tambah_dosen_view.dart';
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

  Future<void> deleteDosen(int no) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.56.1:8000/api/dosen/$no'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Data berhasil dihapus')));
        setState(() {
          futureDosens = fetchDosens();
        });
      } else {
        throw Exception('Gagal menghapus data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
      appBar: AppBar(
        title: const Text('List Dosen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<ModelDosen>?>(
        future: futureDosens,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data dosen'));
          }

          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureDosens = fetchDosens();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(
                8,
              ), // <-- tambahkan padding jika sebelumnya pakai
              physics:
                  const AlwaysScrollableScrollPhysics(), // wajib agar bisa di-refresh walau datanya sedikit
              itemCount: data.length,
              itemBuilder: (context, index) {
                final dosen = data[index];
                return Card(
                  // contoh styling: kamu bisa ganti dengan ListTile biasa jika mau
                  child: ListTile(
                    title: Text(
                      dosen.namaLengkap,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NIP: ${dosen.nip}"),
                        Text("Email: ${dosen.email}"),
                        Text("Telp: ${dosen.noTelepon}"),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditDosenView(dosen: dosen.toJson()),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text('Hapus Dosen'),
                              content: const Text(
                                'Yakin ingin menghapus dosen ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    deleteDosen(
                                      dosen.no,
                                    ); // pastikan ModelDosen punya field id
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahDosenView()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Tambah Dosen',
      ),
    );
  }
}
