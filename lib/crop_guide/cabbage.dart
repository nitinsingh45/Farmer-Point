import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Cabbage extends StatefulWidget {
  const Cabbage({Key? key}) : super(key: key);

  @override
  State<Cabbage> createState() => _CabbageState();
}

class _CabbageState extends State<Cabbage> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerNitrogen = 0.0;
  double fertilizerPhosphorous = 0.0;
  double fertilizerPotash = 0.0;
  double growingDays = 0.0;
  String cabbagePrice = 'Fetching...'; // Variable to hold cabbage price

  @override
  void initState() {
    super.initState();
    fetchCabbagePrice(); // Fetch price when the app starts
  }

  // Function to fetch cabbage price
  Future<void> fetchCabbagePrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/cabbage/uttar-pradesh/gorakhpur';
    String price = await fetchCropPrice(url);
    setState(() {
      cabbagePrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (grams/acre)
      seedRequired = landSize * 225; // Seed rate 200-250 gm per acre

      // Fertilizer requirements based on the provided data
      fertilizerNitrogen = 50; // Initial value, adjusted below
      fertilizerPhosphorous = 25; // Initial value, adjusted below
      fertilizerPotash = 25; // Initial value, adjusted below

      // Adjust fertilizer quantities based on nutrient requirement
      fertilizerNitrogen = landSize * 50;
      fertilizerPhosphorous = landSize * 25;
      fertilizerPotash = landSize * 25;

      // Growing days for cabbage to mature
      growingDays = 90; // Average of 90 days for cabbage to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Cabbage'),
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
                'assets/cabbage.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Cabbage Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Sandy loams',
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
                fetchCabbagePrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (seedRequired > 0)
              Text('Seed Required: ${seedRequired.toStringAsFixed(2)} grams',
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
                'Cabbage Seed Price: $cabbagePrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
