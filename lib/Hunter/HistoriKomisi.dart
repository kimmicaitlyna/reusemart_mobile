import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriKomisi extends StatefulWidget {
  const HistoriKomisi({Key? key}) : super(key: key);

  @override
  State<HistoriKomisi> createState() => _HistoriKomisiState();
}

class _HistoriKomisiState extends State<HistoriKomisi> {
  List<dynamic> histori = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistori();
  }

  Future<void> fetchHistori() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Get token like in profile

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

      // Call PegawaiClient to get histori komisi
      final data = await PegawaiClient.getHistoriKomisiHunter(token);
      setState(() {
        histori = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : histori.isEmpty
            ? const Center(child: Text('Tidak ada histori komisi.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: histori.length,
                itemBuilder: (context, index) {
                  final item = histori[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item['noNota']} | ${item['namaBarang']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF009688),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Id Transaksi Penitipan : ${item['idTransaksiPenitipan']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "No. Nota                : ${item['noNota']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Komisi Hunter           : ${item['komisiHunter'] ?? '-'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}