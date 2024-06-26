import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Maize extends StatefulWidget {
  const Maize({Key? key}) : super(key: key);

  @override
  State<Maize> createState() => _MaizeState();
}

class _MaizeState extends State<Maize> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerUrea = 0.0;
  double fertilizerDAP = 0.0;
  double fertilizerMOP = 0.0;
  double fertilizerZinc = 0.0;
  double growingDays = 0.0;
  String maizePrice = 'Fetching...'; // Variable to hold maize price

  @override
  void initState() {
    super.initState();
    fetchMaizePrice(); // Fetch price when the app starts
  }

  // Function to fetch maize price
  Future<void> fetchMaizePrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/maize/karnataka/bangalore';

    String price = await fetchCropPrice(url);

    setState(() {
      maizePrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 8; // 8 kg of seed per acre

      // Fertilizer requirements based on IIMR data
      fertilizerUrea = landSize * 33; // 33 kg/acre for long duration hybrids
      fertilizerDAP = landSize * 55; // 55 kg/acre for long duration hybrids
      fertilizerMOP = landSize * 160; // 160 kg/acre for long duration hybrids
      fertilizerZinc =
          landSize * 10; // 10 kg/acre ZnSO4.7H2O for long duration hybrids

      // Growing days for maize to mature
      growingDays = 120; // Typically 120 days for maize to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Maize'),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/maize.png',
              fit: BoxFit.cover,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Maize Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: sandy loam (बलुई दोमट मिट्टी)',
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
                fetchMaizePrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (seedRequired > 0)
              Text('Seed Required: ${seedRequired.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerUrea > 0)
              Text('Urea Required: ${fertilizerUrea.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerDAP > 0)
              Text('DAP Required: ${fertilizerDAP.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerMOP > 0)
              Text('MOP Required: ${fertilizerMOP.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerZinc > 0)
              Text('Zinc Required: ${fertilizerZinc.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Maize Seed Price: $maizePrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
