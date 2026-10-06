import 'package:flutter/material.dart';

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Real Estate',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.abc),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Registration',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Serch',
                hintStyle: const TextStyle(
                  color: Color(0xFFB6D8EA),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFFB6D8EA),
                ),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // TextView
          /*  const Text(
            'Real Estate Home',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ), */
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 5,
              bottom: 5,
            ),
            child: const Text(
              'Shope by Categories',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryItem('Tarot'),
                categoryItem('Rudraksha'),
                categoryItem('Gemstone'),
                categoryItem('Jewellery'),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: PageView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey,
                  ),
                  child: const Center(
                    child: Text(
                      'Banner 1',
                      style: TextStyle(
                          backgroundColor: Color(0xFFB6D8EA), fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey),
                  child: const Center(
                    child: Text(
                      'Banner 2',
                      style:
                          TextStyle(backgroundColor: Colors.blue, fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey),
                  child: const Center(
                    child: Text(
                      "Banner 3",
                      style: TextStyle(
                        backgroundColor: Colors.brown,
                        fontSize: 24,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Row(
              children: [
                Container(
                  height: 5,
                  width: 25,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  height: 5,
                  width: 25,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  height: 5,
                  width: 25,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                )
              ],
            ),
          ),

// Recommended for you
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 5,
              bottom: 5,
            ),
            child: const Text(
              'Recommended for you',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),

// Horizontal grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // Main Card
              // =========================
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // Product Image
                      // =========================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/tarotcard.png',
                          width: 180,
                          height: 239,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // =========================
                      // Product Name
                      // =========================
                      const SizedBox(
                        width: 180,
                        child: Text(
                          'The Illuminated Tarot: 78 Cards for Divination '
                          '(The Illuminated Art Series)',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF006497),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // =========================
                      // Rating
                      // =========================
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const Icon(
                            Icons.star_half,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const Icon(
                            Icons.star_border,
                            size: 18,
                            color: Colors.orange,
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // =========================
                      // Price + Discount
                      // =========================
                      Row(
                        children: [
                          // Rupee + Price
                          const Icon(
                            Icons.currency_rupee,
                            size: 16,
                            color: Color(0xFF006497),
                          ),

                          const Text(
                            '1,250',
                            style: TextStyle(
                              color: Color(0xFF006497),
                            ),
                          ),

                          const SizedBox(width: 5),

                          // Strike price
                          const Text(
                            '1,500',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),

                          const SizedBox(width: 5),

                          // 16%
                          const Text(
                            '16%',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 2),

                          // OFF
                          const Text(
                            'OFF',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

// Main vertical LinearLayout
          Column(
            children: [
              // =========================
              // Main CardView
              // =========================
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // Image CardView
                      // =========================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/evileyforrelationship.png',
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // =========================
                      // Product Name
                      // =========================
                      const SizedBox(
                        width: 180,
                        child: Text(
                          'EvilEye for Relationship',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF006497),
                          ),
                        ),
                      ),

                      const SizedBox(height: 3),

                      // =========================
                      // Rating
                      // =========================
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star_half,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star_border,
                              size: 18,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3),

                      // =========================
                      // Price + Strike Price
                      // =========================
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Rupee icon
                            const Icon(
                              Icons.currency_rupee,
                              size: 16,
                              color: Color(0xFF006497),
                            ),

                            // Price
                            const Text(
                              '1,250',
                              style: TextStyle(
                                color: Color(0xFF006497),
                              ),
                            ),

                            const SizedBox(width: 5),

                            // Strike price
                            const Text(
                              '1,500',
                              style: TextStyle(
                                color: Color(0xFF41403C),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

// Main vertical LinearLayout
          Column(
            children: [
              // =========================
              // Main CardView
              // =========================
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // Image CardView
                      // =========================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/evileyforrelationship.png',
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // =========================
                      // Product Name
                      // =========================
                      const SizedBox(
                        width: 180,
                        child: Text(
                          'EvilEye for Relationship',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF006497),
                          ),
                        ),
                      ),

                      const SizedBox(height: 3),

                      // =========================
                      // Rating
                      // =========================
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star_half,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const Icon(
                              Icons.star_border,
                              size: 18,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3),

                      // =========================
                      // Price + Strike Price
                      // =========================
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Rupee icon
                            const Icon(
                              Icons.currency_rupee,
                              size: 16,
                              color: Color(0xFF006497),
                            ),

                            // Price
                            const Text(
                              '1,250',
                              style: TextStyle(
                                color: Color(0xFF006497),
                              ),
                            ),

                            const SizedBox(width: 5),

                            // Strike price
                            const Text(
                              '1,500',
                              style: TextStyle(
                                color: Color(0xFF41403C),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }

  Widget categoryItem(String s) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        child: Center(
          child: Text(
            s,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
