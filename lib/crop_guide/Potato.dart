import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Potato extends StatefulWidget {
  const Potato({Key? key}) : super(key: key);

  @override
  State<Potato> createState() => _PotatoState();
}

class _PotatoState extends State<Potato> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerUrea = 0.0;
  double fertilizerSSP = 0.0;
  double fertilizerMOP = 0.0;
  double nutrientNitrogen = 0.0;
  double nutrientPhosphorus = 0.0;
  double nutrientPotash = 0.0;
  double growingDays = 0.0;
  String potatoPrice = 'Fetching...'; // Variable to hold potato price

  @override
  void initState() {
    super.initState();
    fetchPotatoPrice(); // Fetch price when the app starts
  }

  // Function to fetch potato price
  Future<void> fetchPotatoPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/potato/uttar-pradesh/agra';
    String price = await fetchCropPrice(url);
    setState(() {
      potatoPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (qtl/acre) based on tuber size
      seedRequired =
          landSize * 1000; // Assuming medium size tuber for calculation

      // Fertilizer requirements based on the provided data
      fertilizerUrea = landSize * 165; // Urea in kg/acre
      fertilizerSSP = landSize * 155; // SSP in kg/acre
      fertilizerMOP = landSize * 40; // MOP in kg/acre

      // Nutrient requirements based on the provided data
      nutrientNitrogen = landSize * 75; // Nitrogen in kg/acre
      nutrientPhosphorus = landSize * 25; // Phosphorus in kg/acre
      nutrientPotash = landSize * 25; // Potash in kg/acre

      // Growing days for potato to mature
      growingDays = 90; // Average of 90 days for potato to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Potato'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              child: Image.asset(
                'assets/Potato.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Potato Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Well-drained sandy loam',
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
                fetchPotatoPrice(); // Fetch price when calculate button is pressed
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
            if (fertilizerSSP > 0)
              Text('SSP Required: ${fertilizerSSP.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerMOP > 0)
              Text('MOP Required: ${fertilizerMOP.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (nutrientNitrogen > 0)
              Text(
                  'Nitrogen Required: ${nutrientNitrogen.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (nutrientPhosphorus > 0)
              Text(
                  'Phosphorus Required: ${nutrientPhosphorus.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (nutrientPotash > 0)
              Text('Potash Required: ${nutrientPotash.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Potato Seed Price: $potatoPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
