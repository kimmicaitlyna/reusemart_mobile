import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Hunter/profile.dart';
import 'package:reusemart_mobile/Hunter/HistoriKomisi.dart';

class HomeHunter extends StatefulWidget {
  const HomeHunter({Key? key}) : super(key: key);

  @override
  State<HomeHunter> createState() => _HomeHunterState();
}

class _HomeHunterState extends State<HomeHunter> {
  int _selectedIndex = 0;

  static const Color darkGreen = Color(0xFF2E7D32);  

  final List<Widget> _pages = <Widget>[
    Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_people, size: 100, color: Color(0xFF4CAF50)),
          const SizedBox(height: 20),
          const Text(
            'Selamat datang, Hunter!',
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
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"Semangat terus, Hunter! Komisi besar menantimu!"',
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
    const HistoriKomisi(),
    const ProfileHunter(),
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
        backgroundColor: Colors.transparent, // Supaya gradient terlihat
        appBar: AppBar(
          title: Text(
            _selectedIndex == 2
                ? 'Profil Hunter'
                : _selectedIndex == 1
                    ? 'Riwayat Komisi'
                    : 'Beranda Hunter',
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

