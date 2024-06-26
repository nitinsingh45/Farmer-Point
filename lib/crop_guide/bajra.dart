import 'package:flutter/material.dart';

class Bajra extends StatefulWidget {
  const Bajra({Key? key}) : super(key: key);

  @override
  State<Bajra> createState() => _BajraState();
}

class _BajraState extends State<Bajra> {
  final TextEditingController _landSizeController = TextEditingController();
  double compostRequired = 0.0;
  double nitrogenDose = 0.0;
  double phosphorusDose = 0.0;
  double potassiumDose = 0.0;
  double growingDays = 0.0;
  String bajraPrice = 'Fetching...'; // Variable to hold bajra price

  @override
  void initState() {
    super.initState();
    fetchBajraPrice(); // Fetch price when the app starts
  }

  // Function to fetch bajra price
  Future<void> fetchBajraPrice() async {
    // Replace with your actual URL to fetch bajra price
    String url =
        'https://www.commodityonline.com/mandiprices/bajra/rajasthan/jaipur';

    String price = await fetchCropPrice(url);

    setState(() {
      bajraPrice = price;
    });
  }

  // Mock function to fetch crop price (replace with actual implementation)
  Future<String> fetchCropPrice(String url) async {
    // Implement your HTTP request logic here to fetch bajra price
    await Future.delayed(Duration(seconds: 2)); // Simulating a delay

    // Return a mock price for demonstration
    return '80 INR/kg';
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Compost or farm yard manure requirement (tonnes/acre)
      compostRequired = landSize * 5; // 5 tonnes per acre

      // Fertilizer requirements based on provided data and recommendations
      // Adjust these calculations based on specific agricultural recommendations
      nitrogenDose = landSize * 25; // Half dose of nitrogen (kg/acre)
      phosphorusDose = landSize * 100; // Full dose of phosphorus (kg/acre)
      potassiumDose = landSize * 100; // Full dose of potassium (kg/acre)

      // Set the growing days for bajra
      growingDays = 90; // Typically 90 days for bajra to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Bajra (Pearl Millet)'),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/bajra.png', // Replace with your actual image asset path
              fit: BoxFit.cover,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Bajra Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Sandy and shallow black soil',
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
                fetchBajraPrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (compostRequired > 0)
              Text(
                  'Compost Required: ${compostRequired.toStringAsFixed(2)} tonnes',
                  style: TextStyle(fontSize: 18)),
            if (nitrogenDose > 0)
              Text(
                  'Nitrogen Dose Required: ${nitrogenDose.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (phosphorusDose > 0)
              Text(
                  'Phosphorus Dose Required: ${phosphorusDose.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (potassiumDose > 0)
              Text(
                  'Potassium Dose Required: ${potassiumDose.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Bajra Price: $bajraPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
