import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:reusemart_mobile/Login/sebelumLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Hunter Profile Widget - Only shows profile if idJabatan == "6"
class ProfileHunter extends StatefulWidget {
  final VoidCallback? onLogout;
  const ProfileHunter({Key? key, this.onLogout}) : super(key: key);

  @override
  State<ProfileHunter> createState() => _ProfileHunterState();
}

class _ProfileHunterState extends State<ProfileHunter> {
  bool isLoading = false;
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  Future<void> _getProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final data = await PegawaiClient.getData(token);

      setState(() {
        // Only show if idJabatan == "6"
        if (data != null && data['idJabatan'] == "6") {
          profileData = data;
        } else {
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : profileData == null
                    ? const Text('Data tidak tersedia atau bukan Hunter')
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            _buildProfilePicture(),
                            const SizedBox(height: 5),
                            _buildProfileField('ID Pegawai', profileData?['idPegawai'], Icons.badge_outlined),
                            _buildProfileField('Username', profileData?['username'], Icons.person),
                            _buildProfileField('Tanggal Lahir', profileData?['tanggalLahir'], Icons.calendar_month),
                            _buildProfileField('Komisi', profileData?['dompet']?['saldo']?.toString(), Icons.monetization_on),
                            const SizedBox(height: 5),
                            _buildLogoutButton(),
                          ],
                        ),
                      ),
          ),
        ),
      )
    );
  }

  // Profile picture from Laravel public folder

  Widget _buildProfilePicture() {
    // Replace with your server's IP/domain and image path
    const imageUrl = 'http://192.168.139.186:8000/k19.jpg';

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage('lib/assets/pp.png'),
                // backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${profileData?['namaPegawai'] ?? 'Loading...'}',
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            const Text(
              'Hunter', // Jabatan Hunter
              style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String title, String? value, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 112, 189, 114),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2E7D32),
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

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token tidak ditemukan')),
            );
            return;
          }

          final isLogout = await PegawaiClient.logout(token);
          if (isLogout == true) {
            await prefs.remove('token');
            if (widget.onLogout != null) {
              widget.onLogout!(); // Trigger logout callback
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SebelumLogin()),
              );
            }
          } else {
            print("Gagal logout");
          }
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}