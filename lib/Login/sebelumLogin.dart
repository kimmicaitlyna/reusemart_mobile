import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reusemart_mobile/Client/UmumClient.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:reusemart_mobile/Login/login.dart';

class SebelumLogin extends StatefulWidget {
  const SebelumLogin({Key? key}) : super(key: key);

  @override
  State<SebelumLogin> createState() => SebelumLoginState();
}

class SebelumLoginState extends State<SebelumLogin> with TickerProviderStateMixin {
  List<dynamic> barangList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await UmumClient.ShowUmumBarang();
    setState(() {
      barangList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda',
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
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    child: GridView.builder(
                      key: const ValueKey('grid'),
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: barangList.length,
                      itemBuilder: (context, index) {
                        final barang = barangList[index];
                        final images = barang['images'] as List<dynamic>;
                        final imageUrl = images.isNotEmpty
                            ? 'http://192.168.139.186:8000/${images[0]}'
                            : 'http://192.168.139.186:8000/k19.jpg';
                        final namaBarang = barang['namaBarang'] ?? '';
                        final hargaBarang = barang['hargaBarang'] ?? '';
                        final kategori = barang['kategori'] ?? '';
                        final beratBarang = barang['beratBarang'] ?? '';
                        final periodeGaransi = barang['periodeGaransi'] ?? '-';
                        final garansiBarang = barang['garansiBarang'] ?? 0;
                        bool showGaransi = false;

                        if (garansiBarang == 1 && periodeGaransi != null && periodeGaransi != '-') {
                          try {
                            final expiry = DateTime.tryParse(periodeGaransi);
                            if (expiry != null && expiry.isAfter(DateTime.now())) {
                              showGaransi = true;
                            }
                          } catch (_) {}
                        }

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final List<String> imageList = [];
                                for (var img in barang['images']) {
                                  if (img != null && img.toString().isNotEmpty) {
                                    imageList.add('http://192.168.139.186:8000/$img');
                                  }
                                }
                                return Dialog(
                                  insetPadding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            children: [
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                  height: 250,
                                                  enableInfiniteScroll: false,
                                                  viewportFraction: 1.0,
                                                ),
                                                items: imageList.isNotEmpty
                                                    ? imageList.map((imgUrl) {
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: Image.network(
                                                            imgUrl,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                            height: 250,
                                                          ),
                                                        );
                                                      }).toList()
                                                    : [
                                                        Container(
                                                          height: 250,
                                                          color: const Color(0xFFE0E0E0),
                                                          child: const Center(
                                                            child: Text(
                                                              'carousel\nImages',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF009688),
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 32,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                              ),
                                              if (showGaransi)
                                                Positioned(
                                                  bottom: 16,
                                                  right: 16,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    child: const Text(
                                                      'Bergaransi',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 18),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              namaBarang,
                                              style: const TextStyle(
                                                color: Color(0xFF009688),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Rp $hargaBarang',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'kategori : $kategori',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Berat barang : kg $beratBarang',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Periode barang : $periodeGaransi',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF009688),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Login()));
                                              },
                                              child: const Text(
                                                'Beli Sekarang !',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 190,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        color: const Color(0xFFE0E0E0),
                                        border: Border.all(
                                            color: const Color(0xFF009688), width: 2),
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Center(
                                          child: Text(
                                            'images[0]',
                                            style: TextStyle(
                                              color: Color(0xFF009688),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (showGaransi)
                                      Positioned(
                                        bottom: 16,
                                        right: 16,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Text(
                                            'Bergaransi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 14, bottom: 2),
                                  child: Text(
                                    namaBarang,
                                    style: const TextStyle(
                                      color: Color(0xFF009688),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
                                  child: Text(
                                    'Rp $hargaBarang',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                                  child: Text(
                                    'kategori : $kategori',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                                  child: Text(
                                    'Berat barang : kg $beratBarang',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                                  child: Text(
                                    'Periode barang : $periodeGaransi',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}