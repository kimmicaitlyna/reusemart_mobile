// import 'package:flutter/material.dart';
// // import 'package:reusemart_mobile/Pembeli/history.dart';
// import 'package:reusemart_mobile/Pembeli/history.dart';
// import 'package:reusemart_mobile/Pembeli/profile.dart';
// class HomePembeli extends StatefulWidget {
//   const HomePembeli({Key? key}) : super(key: key);

//   @override
//   State<HomePembeli> createState() => _HomePembeliState();
// }

// class _HomePembeliState extends State<HomePembeli> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     // Example navigation handling — update based on your actual app structure
//     if (index == 0) {
//       // Stay on Home
//     } else if (index == 1) {
//       // Navigate to Notifikasi page if exists
//     } else if (index == 2) {
//       // Navigate to History page if exists
//     } else if (index == 3) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ProfilePembeli()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Beranda Pembeli',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 25, 151, 9),
//         automaticallyImplyLeading: false,
//       ),
//       body: const Center(
//         child: Text(
//           'Selamat datang, Pembeli!',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationBarTheme(
//         data: NavigationBarThemeData(
//           backgroundColor: const Color.fromARGB(255, 25, 151, 9),
//           indicatorColor: Colors.transparent,
//           labelTextStyle: MaterialStateProperty.resolveWith((states) {
//             return const TextStyle(color: Colors.white);
//           }),
//           iconTheme: MaterialStateProperty.resolveWith((states) {
//             return const IconThemeData(color: Colors.white);
//           }),
//         ),
//         child: NavigationBar(
//           selectedIndex: _selectedIndex,
//           onDestinationSelected: _onItemTapped,
//           destinations: const [
//             NavigationDestination(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.notifications),
//               label: 'Notifikasi',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.message),
//               label: 'History',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.person),
//               label: 'Profil',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Pembeli/history.dart';
import 'package:reusemart_mobile/Pembeli/profile.dart';

class HomePembeli extends StatefulWidget {
  const HomePembeli({Key? key}) : super(key: key);

  @override
  State<HomePembeli> createState() => _HomePembeliState();
}

class _HomePembeliState extends State<HomePembeli> {
  int _selectedIndex = 0;

  static const Color darkGreen = Color(0xFF2E7D32);

  final List<Widget> _pages = <Widget>[
    Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_bag, size: 100, color: Color(0xFF4CAF50)),
          const SizedBox(height: 20),
          const Text(
            'Selamat datang, Pembeli!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"Jangan lewatkan barang bekualitas dengan harga miring!"',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
                color: Colors.green[900],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    const HistoryPembelian(),
    const ProfilePembeli(),
  ];

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
                ? 'Profil Pembeli'
                : _selectedIndex == 1
                    ? 'Riwayat Pembelian'
                    : 'Beranda Pembeli',
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
        body: _pages[_selectedIndex],
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
