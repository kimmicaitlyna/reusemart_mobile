import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/PembeliClient.dart';
import 'package:reusemart_mobile/Pembeli/history.dart';
import 'package:reusemart_mobile/Login/sebelumLogin.dart';
import 'package:reusemart_mobile/homePembeli.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePembeli extends StatefulWidget {
  const ProfilePembeli({super.key});

  @override
  State<ProfilePembeli> createState() => _ProfilePembeliState();
}

class _ProfilePembeliState extends State<ProfilePembeli> {
    bool isLoading = false;
    Map<String, dynamic>? profileData;
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePembeli()),
        );
      } else if (index == 1) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const MessagesView()),
      // );
      } else if (index == 2) {

      }
      else if (index == 3) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const ProfilePembeli()),
        // );
      }
    }

    @override
    void initState() {
        super.initState();
        _getProfileData();
    }

    Future<void> _getProfileData() async {
        setState(() {
            isLoading = true; // set loading true saat mulai fetch
        });

        try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');

            if (token == null) {
                throw Exception('Token tidak ditemukan');
            }

            final data = await PembeliClient.getData(token);
            print('Response data: $data');

            setState(() {
                if (data != null) {
                    profileData = data; 
                }else{
                    profileData = null;
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Profile',
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : profileData == null
                  ? const Text('Data tidak tersedia')
                  : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            _buildProfilePicture(),
                            const SizedBox(height: 20),
                            _buildProfileField('Poin', profileData?['poin'].toString(), Icons.star_border),
                            _buildProfileField('Username', profileData?['username'], Icons.person),
                            
                            const SizedBox(height: 20),
                    
                            ],
                        ),
                    )
        ),
      ),
    );
  }

    Widget _buildProfilePicture() {
        return Padding(
            padding: const EdgeInsets.only(top:5),
            child: Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    CircleAvatar(
                        radius: 80.0,
                        backgroundImage: AssetImage('lib/assets/pp.png'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        '${profileData?['namaPembeli'] }',
                        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                        '${profileData?['email'] ?? 'Loading...'}',
                        style: const TextStyle(fontSize: 16.0),
                    ),
                ],
                ),
            ),
        );
    }

    Widget _buildProfileField(String title, String? value, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 25, 151, 9),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(iconData, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}