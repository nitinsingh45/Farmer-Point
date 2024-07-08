import 'package:farmerpoint/crop_guide/bajra.dart';
import 'package:farmerpoint/crop_guide/barley.dart';
import 'package:farmerpoint/crop_guide/cabbage.dart';
import 'package:farmerpoint/crop_guide/cotton.dart';
import 'package:farmerpoint/crop_guide/jowar.dart';
import 'package:farmerpoint/crop_guide/maize.dart';
import 'package:farmerpoint/crop_guide/mustard.dart';
import 'package:farmerpoint/crop_guide/Potato.dart';
import 'package:farmerpoint/crop_guide/onion.dart';
import 'package:farmerpoint/crop_guide/rice.dart';
import 'package:farmerpoint/crop_guide/sugarcane.dart';
import 'package:farmerpoint/crop_guide/wheat.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';

class Guide extends StatefulWidget {
  @override
  _GuideState createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  final List<Map<String, String>> crops = [
    {'image': 'assets/maize.png', 'name': 'Maize (Kharif)'},
    {'image': 'assets/jowar.png', 'name': 'Jowar'},
    {'image': 'assets/rice.png', 'name': 'Rice'},
    {'image': 'assets/cotton.png', 'name': 'Cotton'},
    {'image': 'assets/wheat.png', 'name': 'Wheat'},
    {'image': 'assets/barley.png', 'name': 'Barley'},
    {'image': 'assets/bajra.png', 'name': 'Bajra'},
    {'image': 'assets/mustard.png', 'name': 'Mustard'},
    {'image': 'assets/Potato.png', 'name': 'Potato'},
    {'image': 'assets/onion.png', 'name': 'Onion'},
    {'image': 'assets/cabbage.png', 'name': 'Cabbage'},
    {'image': 'assets/sugarcane.png', 'name': 'Sugarcane'},
    // Add more items as needed
  ];

  List<Map<String, String>> filteredCrops = []; // Filtered list to display
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCrops = crops; // Initialize filteredCrops with all crops initially
  }

  void filterCrops(String query) {
    List<Map<String, String>> _filteredCrops = [];
    _filteredCrops.addAll(crops);

    if (query.isNotEmpty) {
      _filteredCrops.retainWhere(
          (crop) => crop['name']!.toLowerCase().contains(query.toLowerCase()));
    }

    setState(() {
      filteredCrops = _filteredCrops;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, 'phone', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Select Crop'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterCrops(value);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintText: 'Search here',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredCrops.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the respective crop guide when tapped
                      switch (filteredCrops[index]['name']) {
                        case 'Maize (Kharif)':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Maize()),
                          );
                          break;
                        case 'Jowar':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Jowar()),
                          );
                          break;
                        case 'Rice':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Rice()),
                          );
                          break;
                        case 'Cotton':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Cotton()),
                          );
                          break;
                        case 'Wheat':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Wheat()),
                          );
                          break;
                        case 'Barley':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Barley()),
                          );
                          break;
                        case 'Bajra':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Bajra()),
                          );
                          break;
                        case 'Mustard':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Mustard()),
                          );
                          break;
                        case 'Potato':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Potato()),
                          );
                          break;
                        case 'Onion':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Onion()),
                          );
                          break;
                        case 'Cabbage':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Cabbage()),
                          );
                          break;
                        case 'Sugarcane':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Sugarcane()),
                          );
                          break;
                        // Add more cases as needed
                        default:
                          break;
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage(filteredCrops[index]['image']!),
                        ),
                        SizedBox(height: 4),
                        Text(
                          filteredCrops[index]['name']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
