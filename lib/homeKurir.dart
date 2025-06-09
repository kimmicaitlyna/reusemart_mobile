import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:reusemart_mobile/Kurir/history.dart';
import 'package:reusemart_mobile/Kurir/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeKurir extends StatefulWidget {
  const HomeKurir({Key? key}) : super(key: key);

  @override
  State<HomeKurir> createState() => _HomeKurirState();
}

class _HomeKurirState extends State<HomeKurir> {
  int _selectedIndex = 0;
  Map<String, dynamic>? pengirimanData;
  bool isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HomeKurir()),
      // );
    } else if (index == 1) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MessagesView()),
    // );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPengiriman()),
      );
    }
    else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileKurir()),
      );
    }
  }

  @override
  void initState() {
      super.initState();
      getPengiriman();
  }

   Future<void> getPengiriman() async {
        setState(() {
            isLoading = true; // set loading true saat mulai fetch
        });

        try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');

            if (token == null) {
                throw Exception('Token tidak ditemukan');
            }

            final data = await PegawaiClient.getPengiriman(token);
            print('Response data: $data');

            setState(() {
                if (data != null) {
                    pengirimanData = data; 
                }else{
                    pengirimanData = null;
                }
                isLoading = false;
            });
        } catch (e) {
            setState(() {
                isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load profile: $e')),
            );
        }
    }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Kurir',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 255, 255, 255),
          )
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, 
        backgroundColor: Color.fromARGB(255, 25, 151, 9)

      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 25, 151, 9), // latar belakang
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold);
            }
            return const TextStyle(color: Color.fromARGB(255, 255, 255, 255));
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Color.fromARGB(255, 255, 255, 255));
            }
            return const IconThemeData(color: Color.fromARGB(255, 255, 255, 255));
          }),
        ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : (pengirimanData == null || pengirimanData!['data'] == null)
        ? const Center(child: Text('Tidak ada data ditemukan'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengirimanData!['data'].length,
            itemBuilder: (context, index) {
              final item = pengirimanData!['data'][index];

              /////////////alamatttt///////////
              final idAlamatTujuan = item['idAlamat'];
              final daftarAlamat = item['pembeli']?['alamat'] ?? [];

              final alamatDikirim = daftarAlamat.firstWhere(
                (alamat) => alamat['idAlamat'] == idAlamatTujuan,
                orElse: () => null,
              );

              final teksAlamat = alamatDikirim != null
                  ? "${alamatDikirim['alamat']}"
                  : '-';

              /////////////nama barang///////////
              List<dynamic> detailList = item['detail_transaksi_pembelian'] ?? [];
                String namaBarang = detailList.isNotEmpty
                    ? detailList.map((detail) => detail['barang']['namaBarang']).join(', ')
                    : '-';

              ///////////cardddddd//////////////
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
                      Text("${item['noNota'] ?? '-'} || $namaBarang", 
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Nama Pembeli: ${item['pembeli']?['namaPembeli'] ?? '-'}",
                      style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text("Alamat: ${teksAlamat ?? '-'}"),
                      Text("Status: ${item['status'] ?? '-'}"),

                ////////////// Tombol update
              ElevatedButton(
                onPressed: () async {
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
                    final result = await PegawaiClient.updateStatus(token, item['noNota']);
                    Navigator.pop(context); 

                    if (result != null && result['status'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'] ?? 'Update status berhasil')),
                      );
                      // Refresh data
                      getPengiriman();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result?['message'] ?? 'Gagal update status')),
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Pesanan Diterima'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 25, 151, 9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

                    ],
                  ),
                ),
              );
            }
          ),
    );
  }
}
