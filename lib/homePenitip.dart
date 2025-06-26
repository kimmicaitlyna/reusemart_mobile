// import 'package:flutter/material.dart';
// import 'package:reusemart_mobile/Penitip/history.dart';
// import 'package:reusemart_mobile/Penitip/profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:reusemart_mobile/Client/penitipClient.dart';

// class HomePenitip extends StatefulWidget {
//   const HomePenitip({Key? key}) : super(key: key);

//   @override
//   State<HomePenitip> createState() => _HomePenitipState();
// }

// class _HomePenitipState extends State<HomePenitip> {
//   int _selectedIndex = 0;
//   bool isLoading = false;
//   Map<String, dynamic>? topSellerData;


//   static const Color darkGreen = Color(0xFF2E7D32);

//   void initState() {
//     super.initState();
//     loadTopSeller();
//   }

//   Future<void> loadTopSeller() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');

//       if (token == null) {
//         throw Exception('Token tidak ditemukan');
//       }

//       final data = await PenitipClient.cekTopSellerBulanIni(token, prefs.getString('idPenitip') ?? '');

//       setState(() {
//         topSellerData  = (data != null && data['status'] == true) ? data : null;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal memuat data: $e')),
//       );
//     }
//   }

//   final List<Widget> _pages = <Widget>[
//     Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.sell, size: 100, color: Color(0xFF4CAF50)),
//           const SizedBox(height: 20),
//           const Text(
//             'Selamat datang, Penitip!',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.symmetric(horizontal: 30),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               '"Titip barangmu, raup keuntungan, jadilah Top Seller bulan ini!"',
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontSize: 16,
//                 color: Colors.green[900],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     ),
//     const HistoryPenitipan(),
//     const ProfilePenitip(),
//   ];

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
//           title: Text(
//             _selectedIndex == 2
//                 ? 'Profil Penitip'
//                 : _selectedIndex == 1
//                     ? 'Riwayat Penitipan'
//                     : 'Beranda Penitip',
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//           backgroundColor: darkGreen,
//           elevation: 2,
//         ),
//         body: _pages[_selectedIndex],
//         bottomNavigationBar: NavigationBarTheme(
//           data: NavigationBarThemeData(
//             backgroundColor: darkGreen,
//             indicatorColor: Colors.white.withOpacity(0.2),
//             labelTextStyle: MaterialStateProperty.resolveWith((states) {
//               return const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               );
//             }),
//             iconTheme: MaterialStateProperty.resolveWith((states) {
//               if (states.contains(MaterialState.selected)) {
//                 return const IconThemeData(color: Colors.white);
//               }
//               return const IconThemeData(color: Colors.white70);
//             }),
//           ),
//           child: NavigationBar(
//             height: 65,
//             selectedIndex: _selectedIndex,
//             onDestinationSelected: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             destinations: const [
//               NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
//               NavigationDestination(icon: Icon(Icons.history), label: 'History'),
//               NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Penitip/history.dart';
import 'package:reusemart_mobile/Penitip/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reusemart_mobile/Client/penitipClient.dart';

class HomePenitip extends StatefulWidget {
  const HomePenitip({Key? key}) : super(key: key);

  @override
  State<HomePenitip> createState() => _HomePenitipState();
}

class _HomePenitipState extends State<HomePenitip> {
  int _selectedIndex = 0;
  bool isLoading = false;
  Map<String, dynamic>? topSellerData;

  static const Color darkGreen = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    loadTopSeller();
  }

  Future<void> loadTopSeller() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final idPenitip = prefs.getString('idPenitip') ?? '';

      if (token == null || idPenitip.isEmpty) {
        throw Exception('Token atau ID Penitip tidak ditemukan');
      }

      final data = await PenitipClient.cekTopSellerBulanIni(token, idPenitip);

      setState(() {
        topSellerData = (data != null && data['status'] == true) ? data : null;
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

  List<Widget> get pages => <Widget>[
        _buildHomePage(),
        const HistoryPenitipan(),
        const ProfilePenitip(),
      ];

Widget _buildHomePage() {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (topSellerData?['isTopSeller'] == true)
          Card(
            elevation: 6,
            color: Colors.amber[700],
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.emoji_events, color: Colors.white, size: 30),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Selamat! Kamu adalah Top Seller bulan ini 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        const Icon(Icons.sell, size: 100, color: Color(0xFF4CAF50)),
        const SizedBox(height: 20),
        const Text(
          'Selamat datang, Penitip!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Text(
            '"Titip barangmu, raup keuntungan, dan rebut gelar Top Seller bulan ini!"',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 17,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _selectedIndex == 2
                ? 'Profil Penitip'
                : _selectedIndex == 1
                    ? 'Riwayat Penitipan'
                    : 'Beranda Penitip',
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
        body: pages[_selectedIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: darkGreen,
            indicatorColor: Colors.white.withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              return const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              );
            }),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              return IconThemeData(
                color: states.contains(MaterialState.selected)
                    ? Colors.white
                    : Colors.white70,
              );
            }),
          ),
          child: NavigationBar(
            height: 65,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.history), label: 'History'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}
