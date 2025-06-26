import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Kurir/history.dart';
import 'package:reusemart_mobile/Kurir/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';

class HomeKurir extends StatefulWidget {
  const HomeKurir({Key? key}) : super(key: key);

  @override
  State<HomeKurir> createState() => _HomeKurirState();
}

class _HomeKurirState extends State<HomeKurir> {
  int _selectedIndex = 0;
  Map<String, dynamic>? pengirimanData;
  bool isLoading = true;

  static const Color darkGreen = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    getPengiriman();
  }

  Future<void> getPengiriman() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final data = await PegawaiClient.getPengiriman(token);
      setState(() {
        pengirimanData = data;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

 Widget _buildBerandaKurir() {
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
        : (pengirimanData == null || pengirimanData!['data'] == null)
            ? const Center(child: Text('Tidak ada data ditemukan'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // === TULISAN TENGAH DI ATAS ===
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Selamat Datang, Kurir!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Daftar barang yang harus diantarkan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // === DAFTAR BARANG ===
                  ...pengirimanData!['data'].map<Widget>((item) {
                    final idAlamatTujuan = item['idAlamat'];
                    final daftarAlamat = item['pembeli']?['alamat'] ?? [];
                    final alamatDikirim = daftarAlamat.firstWhere(
                      (alamat) => alamat['idAlamat'] == idAlamatTujuan,
                      orElse: () => null,
                    );
                    final teksAlamat = alamatDikirim != null
                        ? "${alamatDikirim['alamat']}"
                        : '-';

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
                                const Icon(Icons.receipt_long,
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
                            const SizedBox(height: 10),
                            Text(
                              "Nama Pembeli: ${item['pembeli']?['namaPembeli'] ?? '-'}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Alamat: $teksAlamat"),
                            Text("Status: ${item['status'] ?? '-'}"),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  _updateStatus(item['noNota'] ?? '-'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Pesanan Diterima'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
  );
}


  Future<void> _updateStatus(String noNota) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await PegawaiClient.updateStatus(token, noNota);
      Navigator.pop(context);

      if (result != null && result['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Berhasil')),
        );
        getPengiriman();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result?['message'] ?? 'Gagal')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _getCurrentPage() {
      switch (_selectedIndex) {
        case 0:
          return _buildBerandaKurir(); 
        case 1:
          return HistoryPengiriman();  
        case 2:
          return ProfileKurir();
        default:
          return _buildBerandaKurir();
      }
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _selectedIndex == 2
              ? 'Profil Kurir'
              : _selectedIndex == 1
                  ? 'Riwayat Pengiriman Kurir'
                  : 'Beranda Kurir',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: darkGreen,
        elevation: 2,
      ),
      // body: _pages[_selectedIndex],
      // body: IndexedStack(
      //   index: _selectedIndex,
      //   children: [
      //     _buildBerandaKurir(), // ← panggil ulang setiap build
      //     const HistoryPengiriman(),
      //     const ProfileKurir(),
      //   ],
      // ),
      body: _getCurrentPage(),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: darkGreen,
          indicatorColor: Colors.white.withOpacity(0.2),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            return const IconThemeData(color: Colors.white70);
          }),
        ),
        child: NavigationBar(
          height: 65,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 0) getPengiriman();
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.history), label: 'History'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
