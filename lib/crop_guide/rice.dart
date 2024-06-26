import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Rice extends StatefulWidget {
  const Rice({Key? key}) : super(key: key);

  @override
  State<Rice> createState() => _RiceState();
}

class _RiceState extends State<Rice> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerNitrogenPreflood = 0.0;
  double fertilizerNitrogenMidseason = 0.0;
  double growingDays = 0.0;
  String ricePrice = 'Fetching...'; // Variable to hold rice price

  @override
  void initState() {
    super.initState();
    fetchRicePrice(); // Fetch price when the app starts
  }

  // Function to fetch rice price
  Future<void> fetchRicePrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/rice/karnataka/bangalore';
    String price = await fetchCropPrice(url);
    setState(() {
      ricePrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 20; // Adjust as per standard seed rate for rice

      // Fertilizer requirements based on the provided data
      fertilizerNitrogenPreflood =
          landSize * 90; // 90 pounds of nitrogen per acre preflood
      fertilizerNitrogenMidseason =
          landSize * 45; // 45 pounds of nitrogen per acre midseason

      // Growing days for rice to mature
      growingDays = 150; // Average of 150 days for rice to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Rice'),
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
                'assets/rice.png', // Assuming there is an image asset named rice.png
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Rice Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Clay or Clay loams',
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
                fetchRicePrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (seedRequired > 0)
              Text('Seed Required: ${seedRequired.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerNitrogenPreflood > 0)
              Text(
                  'Nitrogen Required (Preflood): ${fertilizerNitrogenPreflood.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerNitrogenMidseason > 0)
              Text(
                  'Nitrogen Required (Midseason): ${fertilizerNitrogenMidseason.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Rice Seed Price: $ricePrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
