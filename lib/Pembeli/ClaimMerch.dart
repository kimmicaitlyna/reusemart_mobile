import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/merchClient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClaimMerchPage extends StatefulWidget {
  final String idPembeli;
  final int poin;
  const ClaimMerchPage({super.key, required this.idPembeli, required this.poin});

  @override
  State<ClaimMerchPage> createState() => _ClaimMerchPageState();
}

class _ClaimMerchPageState extends State<ClaimMerchPage> {
  late Future<List<Map<String, dynamic>>> _merchFuture;

  @override
  void initState() {
    super.initState();
    _merchFuture = MerchClient.showMerch();
  }

  Future<void> _claimMerchandise(Map<String, dynamic> merch) async {
    if (widget.poin < (merch['harga'] ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poin kamu tidak cukup untuk klaim merchandise ini!')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(
            'Kamu akan klaim merchandise "${merch['nama']}" dengan ${merch['harga']} poin. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Klaim!'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final body = {
      "idPegawai": null,
      "idMerchandise": merch['idMerchandise'],
      "idPembeli": widget.idPembeli,
      "tanggalAmbil": null
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.139.186:8000/api/claim-merchandise'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil klaim merchandise!')),
        );
        setState(() {
          _merchFuture = MerchClient.showMerch();
        });
      } else {
        final msg = response.body.contains('tidak cukup')
            ? 'Poin kamu tidak cukup!'
            : 'Gagal klaim merchandise!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  String _getImageForMerch(String id) {
    if (id == "M1") {
      return 'http://192.168.139.186:8000/penMerch.jpg';
    } else if (id == "M2") {
      return 'http://192.168.139.186:8000/stikerMerch.jpg';
    } else if (id == "M3") {
      return 'http://192.168.139.186:8000/mugMerch.jpg';
    } else if (id == "M4") {
      return 'http://192.168.139.186:8000/topiMerch.jpg';
    } else if (id == "M5") {
      return 'http://192.168.139.186:8000/tumblerMerch.jpg';
    } else if (id == "M6") {
      return 'http://192.168.139.186:8000/kaosMerch.jpg';
    } else if (id == "M7") {
      return 'http://192.168.139.186:8000/jamMerch.jpg';
    } else if (id == "M8") {
      return 'http://192.168.139.186:8000/tasMech.jpg';
    } else if (id == "M9") {
      return 'http://192.168.139.186:8000/payungMerch.jpg';
    } else {
      return 'http://192.168.139.186:8000/k19.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Merchandise'),
        backgroundColor: const Color(0xFF009688),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _merchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada merchandise tersedia.'));
          }
          final merchList = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: merchList.length,
            itemBuilder: (context, index) {
              final merch = merchList[index];
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Image.network(
                            _getImageForMerch(merch['idMerchandise']),
                            fit: BoxFit.contain,
                            height: 60,
                            errorBuilder: (c, e, s) => const Text(
                              'images[0]',
                              style: TextStyle(
                                color: Color(0xFF009688),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        merch['nama'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF009688),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'harga: ${merch['harga']} poin',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'stock : ${merch['jumlahSatuan']}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009688),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _claimMerchandise(merch),
                          child: const Text(
                            'Claim Merchandise !',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}