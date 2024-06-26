import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Sugarcane extends StatefulWidget {
  const Sugarcane({Key? key}) : super(key: key);

  @override
  State<Sugarcane> createState() => _SugarcaneState();
}

class _SugarcaneState extends State<Sugarcane> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerNitrogen = 0.0;
  double fertilizerPhosphorous = 0.0;
  double fertilizerPotash = 0.0;
  double growingDays = 0.0;
  String sugarcanePrice = 'Fetching...';

  @override
  void initState() {
    super.initState();
    fetchSugarcanePrice(); // Fetch price when the app starts
  }

  // Function to fetch sugarcane price
  Future<void> fetchSugarcanePrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/sugarcane/chattisgarh/rajpur';
    String price = await fetchCropPrice(url);
    setState(() {
      sugarcanePrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      seedRequired = landSize * 18000;

      // Fertilizer requirements based on the provided data
      fertilizerNitrogen = landSize * 100; // Recommended nitrogen in kg/ha
      fertilizerPhosphorous = landSize * 60; // Recommended P2O5 in kg/ha
      fertilizerPotash = landSize * 225; // Recommended K2O in kg/ha

      // Growing days for sugarcane to mature
      growingDays = 365; // Sugarcane is a 12-month crop on average
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Sugarcane'),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              child: Image.asset(
                'assets/sugarcane.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Sugarcane Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Well-drained loamy soils',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextField(
              controller: _landSizeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter land size in acres',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _calculateRequirements();
                fetchSugarcanePrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (seedRequired > 0)
              Text('Plants Required: ${seedRequired.toStringAsFixed(2)} ',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerNitrogen > 0)
              Text(
                  'Nitrogen Required: ${fertilizerNitrogen.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerPhosphorous > 0)
              Text(
                  'Phosphorous Required: ${fertilizerPhosphorous.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerPotash > 0)
              Text('Potash Required: ${fertilizerPotash.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Sugarcane Price: $sugarcanePrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to fetch crop price from API (mock function)
