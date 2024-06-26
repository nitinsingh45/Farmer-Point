import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Barley extends StatefulWidget {
  const Barley({Key? key}) : super(key: key);

  @override
  State<Barley> createState() => _BarleyState();
}

class _BarleyState extends State<Barley> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerNitrogen = 0.0;
  double fertilizerPhosphorus = 0.0;
  double fertilizerPotassium = 0.0;
  double growingDays = 0.0;
  String barleyPrice = 'Fetching...'; // Variable to hold barley price

  @override
  void initState() {
    super.initState();
    fetchBarleyPrice(); // Fetch price when the app starts
  }

  // Function to fetch barley price
  Future<void> fetchBarleyPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/barley-jau/uttar-pradesh/raibareilly'; // Replace with actual API endpoint

    String price = await fetchCropPrice(url);

    setState(() {
      barleyPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 8; // Assuming 8 kg of seed per acre for barley

      // Fertilizer requirements based on barley data
      // Adjust according to barley's nutrient requirements
      fertilizerNitrogen = landSize * 26; // kg of nitrogen per ton of grain
      fertilizerPhosphorus = landSize * 11; // kg of phosphorus per ton of grain
      fertilizerPotassium = landSize * 24; // kg of potassium per ton of grain

      // Growing days for barley to mature
      growingDays = 80; // Adjusted for barley's growing season
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Barley'),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/barley.png', // Replace with barley image asset
              fit: BoxFit.cover,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Barley Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: loam', // Adjust soil type if needed
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
                fetchBarleyPrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (seedRequired > 0)
              Text('Seed Required: ${seedRequired.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerNitrogen > 0)
              Text(
                  'Nitrogen Fertilizer Required: ${fertilizerNitrogen.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerPhosphorus > 0)
              Text(
                  'Phosphorus Fertilizer Required: ${fertilizerPhosphorus.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerPotassium > 0)
              Text(
                  'Potassium Fertilizer Required: ${fertilizerPotassium.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Barley Price: $barleyPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
