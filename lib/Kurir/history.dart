import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:reusemart_mobile/Kurir/profile.dart';
import 'package:reusemart_mobile/homeKurir.dart';
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
  int _selectedIndex = 0;

  String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeKurir()),
      );
    }  else if (index == 1) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HistoryPengiriman()),
      // );
    }
    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileKurir()),
      );
    }
  }

  @override
  void initState() {
      super.initState();
      getHistory();
  }

  Future<void> getHistory() async {
    setState(() {
        isLoading = true; // set loading true saat mulai fetch
    });

    try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        if (token == null) {
            throw Exception('Token tidak ditemukan');
        }

        final data = await PegawaiClient.getHistoryKurir(token);
        print('Response data: $data');

        setState(() {
          if (data != null && data['status'] == true) {
            historyData = data;
            isLoading = false;
          } else {
            historyData = null;
            isLoading = false;
          }
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
    List historyList = historyData?['data'] ?? [];
    final DateFormat dateFormatter = DateFormat('dd MMM yyyy');
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History Pengiriman',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 255, 255, 255),
              )),
          centerTitle: true,
          automaticallyImplyLeading: false, 
          backgroundColor: Color.fromARGB(255, 25, 151, 9),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 25, 151, 9), // latar belakang
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
        : (historyData == null || historyData!['data'] == null)
            ? const Center(child: Text('Tidak ada data ditemukan'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: historyData!['data'].length,
                itemBuilder: (context, index) {
                  final item = historyList[index];

                  /////////////nama barang///////////
                  List<dynamic> detailList = item['detail_transaksi_pembelian'] ?? [];
                    String namaBarang = detailList.isNotEmpty
                        ? detailList.map((detail) => detail['barang']['namaBarang']).join(', ')
                        : '-';

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
                          
                          Text("${item['noNota'] ?? '-'}" " || $namaBarang" , 
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("Total Harga: ${currencyFormatter.format(item['totalHarga'] ?? 0)}"),
                          Text("Tanggal Pembelian: ${formatDateString(item['tanggalWaktuPembelian'])}"),
                          Text("Tanggal Pengiriman: ${formatDateString(item['tanggalPengirimanPengambilan'])}"),

                        ],
                      ),
                    ),
                  );
                }
              ),
      )
    );
  }
}