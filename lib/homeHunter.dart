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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = const Center(
          child: Text(
            'Selamat datang, Hunter!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(221, 0, 0, 0),
            ),
          ),
        );
        break;
              case 2: // History tab
        bodyContent = const HistoriKomisi();
        break;
      case 3:
        bodyContent = ProfileHunter(
          onLogout: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        );
        break;
      default:
        bodyContent = const Center(
          child: Text(
            'Fitur belum tersedia',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda Hunter',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 25, 151, 9),
      ),
      body: bodyContent,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 25, 151, 9),
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold);
            }
            return const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255));
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            return const IconThemeData(
                color: Color.fromARGB(255, 255, 255, 255));
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
    );
  }
}