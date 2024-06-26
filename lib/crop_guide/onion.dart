import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Onion extends StatefulWidget {
  const Onion({Key? key}) : super(key: key);

  @override
  State<Onion> createState() => _OnionState();
}

class _OnionState extends State<Onion> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerNitrogen = 0.0;
  double fertilizerPhosphorous = 0.0;
  double fertilizerPotash = 0.0;
  double growingDays = 0.0;
  String onionPrice = 'Fetching...'; // Variable to hold onion price

  @override
  void initState() {
    super.initState();
    fetchOnionPrice(); // Fetch price when the app starts
  }

  // Function to fetch onion price
  Future<void> fetchOnionPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/onion/karnataka/bangalore';
    String price = await fetchCropPrice(url);
    setState(() {
      onionPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 3.5; // Average seed rate for onion

      // Fertilizer requirements based on the provided data
      fertilizerNitrogen = landSize * 70; // 60-80 kg nitrogen per acre
      fertilizerPhosphorous = landSize * 28; // 24-32 kg phosphorous per acre
      fertilizerPotash = landSize * 24; // 24 kg potash per acre

      // Growing days for onion to mature
      growingDays = 120; // Average of 3-4 months for onion to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Onion'),
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
                'assets/onion.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Onion Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Loamy soils with good drainage',
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
                fetchOnionPrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (seedRequired > 0)
              Text('Seed Required: ${seedRequired.toStringAsFixed(2)} kg',
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
                'Onion Seed Price: $onionPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
