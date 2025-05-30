// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:reusemart_mobile/Login/loginPegawai.dart';
// import 'package:reusemart_mobile/Login/loginPengguna.dart';

// class SebelumLogin extends StatefulWidget {
//   const SebelumLogin({Key? key}) : super(key: key);

//   @override
//   State<SebelumLogin> createState() => SebelumLoginState();
// }

// class SebelumLoginState extends State<SebelumLogin> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         body:SafeArea(
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   'lib/assets/logoReUseMart.png',
//                   width: 150),
//                 SizedBox(height: 60),
//                 TextButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 91, 215, 133)),
//                     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                   ),
//                   onPressed: () {
//                      Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               const LoginPengguna()));
//                   },
//                   child: Text('Login Pengguna'),
//                 ),
//                 SizedBox(height: 16),
//                 TextButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 91, 215, 133)),
//                     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               const LoginPegawai()));
//                   },
//                   child: Text('Login Pegawai'),
//                 )
//               ],
//             ),
//           ),
//         )
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reusemart_mobile/Login/Login.dart';

class SebelumLogin extends StatefulWidget {
  const SebelumLogin({Key? key}) : super(key: key);

  @override
  State<SebelumLogin> createState() => SebelumLoginState();
}

class SebelumLoginState extends State<SebelumLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body:SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/assets/logoReUseMart.png',
                  width: 150),
                SizedBox(height: 60),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 91, 215, 133)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Login()));
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}