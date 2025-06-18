import 'package:flutter/material.dart';
import 'package:reusemart_mobile/Client/pegawaiClient.dart';
import 'package:reusemart_mobile/Client/penitipClient.dart';
import 'package:reusemart_mobile/Client/pembeliClient.dart';
import 'package:reusemart_mobile/Login/sebelumLogin.dart';
import 'package:reusemart_mobile/homeHunter.dart';
import 'package:reusemart_mobile/homeKurir.dart';
import 'package:reusemart_mobile/homePenitip.dart';
import 'package:reusemart_mobile/homePembeli.dart';
import 'package:reusemart_mobile/push_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedRole;

  Future<String?> getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }


  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (selectedRole == null) {
      showSnackBar('Silakan pilih tipe login');
      return;
    }

    String? fcmToken = await getFcmToken();

    if (selectedRole == 'pegawai') {
      final responseData = await PegawaiClient.login(username, password);
      if (responseData != null && responseData['status'] == true && responseData['data']['token'] != null) {
        final token = responseData['data']['token'];
        final idJabatan = responseData['data']['pegawai']['idJabatan'].toString();

        if (fcmToken != null) {
          print('Sending FCM Token to the backend: $fcmToken');
          await PegawaiClient.registerFcmToken(token, fcmToken); 
        }
        
        if (idJabatan == "4") {
          await _saveToken(token);
          await PushNotifications.subscribeToUserTopic('kurir');
          showSnackBar('Login berhasil!');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeKurir()));
        } else if (idJabatan == "6") {
          await _saveToken(token);
          await PushNotifications.subscribeToUserTopic('hunter');
          showSnackBar('Login berhasil!');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeHunter()));
        } else {
          showSnackBar('Jabatan tidak dikenali');
        }
        return;
      }
    } else if (selectedRole == 'pembeli') {
      final responseData = await PembeliClient.login(username, password);
      if (responseData != null && responseData['data']['token'] != null) {
        final token = responseData['data']['token'];
        print('Sending FCM Token to the backend: $fcmToken');
        if (fcmToken != null) {
          print('Sending FCM Token to the backend: $fcmToken');
          await PembeliClient.registerFcmToken(token, fcmToken);
        }

        await _saveToken(token);
        await PushNotifications.subscribeToUserTopic('pembeli');
        showSnackBar('Login berhasil!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePembeli()));
        return;
      }
    } else if (selectedRole == 'penitip') {
      final responseData = await PenitipClient.login(username, password);
      if (responseData != null && responseData['penitip']['token'] != null) {
        final token = responseData['penitip']['token'];
        
        if (fcmToken != null) {
          await PenitipClient.registerFcmToken(token, fcmToken);
        }

        await _saveToken(token);
        await PushNotifications.subscribeToUserTopic('penitip');
        showSnackBar('Login berhasil!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePenitip()));
        return;
      }
    }
    showLoginErrorDialog();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showLoginErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: const Text(
          'Username atau password salah. Silakan cek kembali.',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Coba Lagi')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SebelumLogin())),
          icon: const Icon(Icons.navigate_before, size: 30, color: Colors.black),
        ),
        title: const Text('Login', style: TextStyle(fontSize: 26, color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Username tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Password tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: const Text("Pilih Jenis Login"),
                  items: const [
                    DropdownMenuItem(value: 'pegawai', child: Text('Pegawai')),
                    DropdownMenuItem(value: 'pembeli', child: Text('Pembeli')),
                    DropdownMenuItem(value: 'penitip', child: Text('Penitip')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.people, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                  ),
                  validator: (value) => value == null ? "Jenis login harus dipilih" : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 215, 133),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}