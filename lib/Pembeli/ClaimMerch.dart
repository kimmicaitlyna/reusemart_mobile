// import 'package:flutter/material.dart';
// import 'package:reusemart_mobile/Client/merchClient.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ClaimMerchPage extends StatefulWidget {
//   final String idPembeli;
//   final int poin;
//   const ClaimMerchPage({super.key, required this.idPembeli, required this.poin});

//   @override
//   State<ClaimMerchPage> createState() => _ClaimMerchPageState();
// }

// class _ClaimMerchPageState extends State<ClaimMerchPage> {
//   late Future<List<Map<String, dynamic>>> _merchFuture;

//   @override
//   void initState() {
//     super.initState();
//     _merchFuture = MerchClient.showMerch();
//   }

//   Future<void> _claimMerchandise(Map<String, dynamic> merch) async {
//     if (widget.poin < (merch['harga'] ?? 0)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Poin kamu tidak cukup untuk klaim merchandise ini!')),
//       );
//       return;
//     }

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Konfirmasi'),
//         content: Text(
//           'Kamu akan klaim merchandise "${merch['nama']}" dengan ${merch['harga']} poin. Lanjutkan?',
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya, Klaim!')),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     final body = {
//       "idPegawai": null,
//       "idMerchandise": merch['idMerchandise'],
//       "idPembeli": widget.idPembeli,
//       "tanggalAmbil": null
//     };

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.255.121:8000/api/store/claim'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );
//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Berhasil klaim merchandise!')),
//         );
//         setState(() {
//           _merchFuture = MerchClient.showMerch();
//         });
//       } else {
//         final msg = response.body.contains('tidak cukup')
//             ? 'Poin kamu tidak cukup!'
//             : 'Gagal klaim merchandise!';
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Terjadi kesalahan: $e')),
//       );
//     }
//   }

//   String _getImageForMerch(String id) {
//     return 'http://192.168.255.121:8000/${{
//       "M1": "penMerch.jpg",
//       "M2": "stikerMerch.jpg",
//       "M3": "mugMerch.jpg",
//       "M4": "topiMerch.jpg",
//       "M5": "tumblerMerch.jpg",
//       "M6": "kaosMerch.jpg",
//       "M7": "jamMerch.jpg",
//       "M8": "tasMech.jpg",
//       "M9": "payungMerch.jpg",
//     }[id] ?? "k19.jpg"}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: const Text('Claim Merchandise'),
//           backgroundColor: const Color(0xFF2E7D32),
//           centerTitle: true,
//         ),
//         body: FutureBuilder<List<Map<String, dynamic>>>(
//           future: _merchFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('Tidak ada merchandise tersedia.'));
//             }

//             final merchList = snapshot.data!;
//             return GridView.builder(
//               padding: const EdgeInsets.all(16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.7,
//               ),
//               itemCount: merchList.length,
//               itemBuilder: (context, index) {
//                 final merch = merchList[index];
//                 return Card(
//                   elevation: 6,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 90,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFE0E0E0),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Center(
//                                 child: Image.network(
//                                   _getImageForMerch(merch['idMerchandise']),
//                                   fit: BoxFit.contain,
//                                   height: 60,
//                                   errorBuilder: (c, e, s) => const Text(
//                                     'Gagal load',
//                                     style: TextStyle(
//                                       color: Color(0xFF2E7D32),
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               merch['nama'] ?? '',
//                               style: const TextStyle(
//                                 color: Color(0xFF2E7D32),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Harga: ${merch['harga']} poin',
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                               ),
//                             ),
//                             Text(
//                               'Stok: ${merch['jumlahSatuan']}',
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2E7D32),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             onPressed: () => _claimMerchandise(merch),
//                             child: const Text(
//                               'Claim Merchandise!',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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
  final String baseUrl = 'http://192.168.255.121:8000/';

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
        Uri.parse('http://192.168.255.121:8000/api/store/claim'),
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
    switch (id) {
      case "M1":
        return '${baseUrl}penMerch.jpg';
      case "M2":
        return '${baseUrl}stikerMerch.jpg';
      case "M3":
        return '${baseUrl}mugMerch.jpg';
      case "M4":
        return '${baseUrl}topiMerch.jpg';
      case "M5":
        return '${baseUrl}tumblerMerch.jpg';
      case "M6":
        return '${baseUrl}kaosMerch.jpg';
      case "M7":
        return '${baseUrl}jamMerch.jpg';
      case "M8":
        return '${baseUrl}tasMech.jpg';
      case "M9":
        return '${baseUrl}payungMerch.jpg';
      default:
        return '${baseUrl}k19.jpg';
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
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.7, // More vertical space for responsiveness
            ),
            itemCount: merchList.length,
            itemBuilder: (context, index) {
              final merch = merchList[index];
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 4,
                        child: SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _getImageForMerch(merch['idMerchandise']),
                              fit: BoxFit.cover,
                              height: 160,
                              errorBuilder: (c, e, s) => const Center(
                                child: Text(
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
                        ),
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              merch['nama'] ?? '',
                              style: const TextStyle(
                                color: Color(0xFF009688),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'harga: ${merch['harga']} poin',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'stock : ${merch['jumlahSatuan']}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009688),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => _claimMerchandise(merch),
                          child: const Text(
                            'Claim Merchandise !',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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