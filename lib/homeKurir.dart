import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Kurir/history.dart';
import 'package:reusemart_mobile/Kurir/profile.dart';


class HomeKurir extends StatefulWidget {
  const HomeKurir({Key? key}) : super(key: key);

  @override
  State<HomeKurir> createState() => _HomeKurirState();
}

class _HomeKurirState extends State<HomeKurir> {
  int _selectedIndex = 0;

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
      body: const Center(
        child: Text(
          'Selamat datang, Kurir!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 0, 0, 0),
          ),
          
        ),
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
