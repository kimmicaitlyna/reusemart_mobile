import 'package:flutter/material.dart';

class HomePembeli extends StatefulWidget {
  const HomePembeli({Key? key}) : super(key: key);

  @override
  State<HomePembeli> createState() => _HomePembeliState();
}

class _HomePembeliState extends State<HomePembeli> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Example navigation handling — update based on your actual app structure
    if (index == 0) {
      // Stay on Home
    } else if (index == 1) {
      // Navigate to Notifikasi page if exists
    } else if (index == 2) {
      // Navigate to History page if exists
    } else if (index == 3) {
      // Navigate to Profil page if exists
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda Pembeli',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 151, 9),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Selamat datang, Pembeli!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 25, 151, 9),
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            return const TextStyle(color: Colors.white);
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            return const IconThemeData(color: Colors.white);
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
              icon: Icon(Icons.message),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
