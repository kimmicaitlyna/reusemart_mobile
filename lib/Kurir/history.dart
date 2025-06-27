import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HistoryPengiriman extends StatefulWidget {
  const HistoryPengiriman({super.key});

  @override
  State<HistoryPengiriman> createState() => _HistoryPengirimanState();
}

class _HistoryPengirimanState extends State<HistoryPengiriman> {
  bool isLoading = false;
  Map<String, dynamic>? historyData;

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final data = await PegawaiClient.getHistoryKurir(token);

      setState(() {
        historyData = (data != null && data['status'] == true) ? data : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List historyList = historyData?['data'] ?? [];
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
          : historyList.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada riwayat pengiriman.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];

                    List<dynamic> detailList =
                        item['detail_transaksi_pembelian'] ?? [];
                    String namaBarang = detailList.isNotEmpty
                        ? detailList
                            .map((detail) =>
                                detail['barang']['namaBarang'] ?? '-')
                            .join(', ')
                        : '-';

                    return Container(
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
                                const Icon(Icons.local_shipping,
                                    color: Color(0xFF2E7D32)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${item['noNota'] ?? '-'} • $namaBarang",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Total Harga: ${currencyFormatter.format(int.tryParse('${item['totalHarga']}') ?? 0)}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Tanggal Pembelian: ${formatDateString(item['tanggalWaktuPembelian'])}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Tanggal Pengiriman: ${formatDateString(item['tanggalPengirimanPengambilan'])}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
