import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reusemart_mobile/Login/Login.dart';

class SebelumLogin extends StatefulWidget {
  const SebelumLogin({Key? key}) : super(key: key);

  @override
  State<SebelumLogin> createState() => SebelumLoginState();
}

class SebelumLoginState extends State<SebelumLogin> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool hide = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 30.0,
    ).animate(_scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const Login(),
            ),
          );
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/logoReUseMart.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, // Start from the top of the screen
                  end: Alignment.topCenter, // End at the bottom of the screen
                  colors: [
                    Colors.black.withOpacity(0.8),  // Lighter top
                    Colors.black.withOpacity(0.7), // Darker bottom
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Selamat Datang di ReUseMart",
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.2,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Barang Lama, Cerita Baru",
                        style: TextStyle(color: Colors.grey.shade300, fontSize: 22),
                      ),
                    ),
                    SizedBox(height: 60),
                    InkWell(
                      onTap: () {
                        setState(() {
                          hide = true;
                        });
                        _scaleController.forward();
                      },
                      child: AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) => Transform.scale(
                          scale: _scaleAnimation.value,
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 91, 215, 133),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: hide == false
                                    ? Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1700),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "Telusuri Barang",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
