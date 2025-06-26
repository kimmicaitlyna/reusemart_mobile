import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reusemart_mobile/Login/Login.dart';

class SebelumLogin extends StatefulWidget {
  const SebelumLogin({Key? key}) : super(key: key);

  @override
  State<SebelumLogin> createState() => SebelumLoginState();
}

class KeuntunganInfo {
  final String title;
  final String subtitle; // Subteks ditambahkan
  final IconData icon;

  KeuntunganInfo({required this.title, required this.subtitle, required this.icon});
}

class SebelumLoginState extends State<SebelumLogin> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool hide = false;
  bool _showFullContent = false;
  final List<KeuntunganInfo> keuntunganList = [
    KeuntunganInfo(title: 'Kualitas Terjamin', subtitle: 'Barang yang tersedia telah lulus QC oleh gudang kami!', icon: Icons.diamond_outlined),
    KeuntunganInfo(title: 'Belanja Dengan Mudah', subtitle: 'Jelajah marketplace tanpa perlu membuat akun', icon: Icons.shopping_cart_checkout),
    KeuntunganInfo(title: 'Manfaatkan Kembali', subtitle: 'ubah barang bekas anda menjadi kebaikan', icon: Icons.add_box_outlined),
    KeuntunganInfo(title: 'Untuk Komunitas', subtitle: 'Membantu Komunitas dan jadilah humanitarian', icon: Icons.local_activity_outlined),
  ];

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
          Navigator.pushReplacement(
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
  void dispose() {
    _scaleController.dispose();
    super.dispose();
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
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: _showFullContent ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                           
                             FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: Text(
                                "Keuntungan Reusemart",
                                style: TextStyle(
                                  color: Colors.white,
                                  height: 1.2,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 180, //subteks
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: keuntunganList.length,
                                itemBuilder: (context, index) {
                                  final item = keuntunganList[index];
                                  return FadeInUp(
                                    duration: Duration(milliseconds: 1400 + (index * 100)),
                                    child: Container(
                                      width: 150, //subteks
                                      margin: EdgeInsets.only(right: 15),
                                      child: Card(
                                        color: Colors.white.withOpacity(0.1),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: BorderSide(color: Colors.white.withOpacity(0.2))
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(item.icon, color: Colors.greenAccent, size: 40),
                                              SizedBox(height: 10),
                                              Text(
                                                item.title,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              
                                              Text(
                                                item.subtitle,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 60),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FeatureSection(
                                  color: Color.fromARGB(255, 91, 215, 133),
                                  imagePath: 'lib/assets/bg-showcase-1.jpg',
                                  title: 'Temukan, Beli, Sampai!',
                                  description: 'Jelajahi berbagai barang bekas dengan mudah, dan beli dengan aman serta nyaman. Dari menemukan barang bekas berkualitas hingga proses pembelian yang lancar, kami memastikan pengalaman berbelanja Anda memuaskan.',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1700),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FeatureSection(
                                  color: Colors.white,
                                  imagePath: 'lib/assets/bg-showcase-2.jpg', 
                                  title: 'Barang Lama Bisa Bercerita',
                                  description: 'Daripada menumpuk kenangan di gudang, yuk berdayakan kembali barang-barang Anda. Berikan mereka cerita baru di tangan pemilik yang baru dan dapatkan keuntungan lebih.',
                                  textFirst: false,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FeatureSection(
                                  color: Color.fromARGB(255, 91, 215, 133),
                                  imagePath: 'lib/assets/bg-showcase-3.jpg', 
                                  title: 'Berkontribusi untuk sesama',
                                  description: 'Apabila barangmu tidak dapat menemukan pemilik baru, tenang saja, Reusemart akan memastikan agar barangmu membantu panti asuhan, organisasi masyarakat, dan komunitas lainya!',
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showFullContent = true;
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: _showFullContent ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Center(
                                child: Bounce(
                                  infinite: true,
                                  from: 10,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class FeatureSection extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final String description;
  final bool textFirst;

  const FeatureSection({
    Key? key,
    required this.color,
    required this.imagePath,
    required this.title,
    required this.description,
    this.textFirst = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = color == Colors.white ? Colors.black : Colors.white;


    final textWidget = Expanded(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );


    final imageWidget = Expanded(
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
            ),
          );
        },
      ),
    );


    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: textFirst ? [textWidget, imageWidget] : [imageWidget, textWidget],
            ),
          );
        } else {
        
          return Column(
            children: [
            
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                color: color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(description, style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 14, height: 1.5)),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[300], child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey[600])));
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
