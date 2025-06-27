import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
  return Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
    child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : histori.isEmpty
            ? Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Tidak ada histori komisi.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: histori.length,
                  itemBuilder: (context, index) {
                    final item = histori[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Center(
                                child: Text(
                                  "Detail Komisi",
                                  style: TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetail("ID Transaksi Penitipan", item['idTransaksiPenitipan']),
                                    _buildDetail("No. Nota Pembelian", item['noNota']),
                                    _buildDetail("Nama Barang", item['namaBarang']),
                                    _buildDetail("Harga Barang", currencyFormatter.format(int.tryParse(item['hargaBarang'] ?? 0))),
                                    _buildDetail("Komisi Hunter (5%)", currencyFormatter.format(int.tryParse(item['komisiHunter'] ?? 0))),

                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tutup", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.receipt_long, color: Color(0xFF2E7D32)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${item['noNota']} • ${item['namaBarang']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDetail("ID Transaksi Penitipan", item['idTransaksiPenitipan']),
                              _buildDetail("No. Nota", item['noNota']),
                              _buildDetail("Komisi Hunter", currencyFormatter.format(item['komisiHunter'] ?? 0)),

                            ],
                          ),
                        ),
                      ),
                    );
                  }

                ),
              )
  );
}


  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}