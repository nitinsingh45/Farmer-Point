import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Mustard extends StatefulWidget {
  const Mustard({Key? key}) : super(key: key);

  @override
  State<Mustard> createState() => _MustardState();
}

class _MustardState extends State<Mustard> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerUrea = 0.0;
  double fertilizerSSP = 0.0;
  double fertilizerMOP = 0.0;
  double growingDays = 0.0;
  String mustardPrice = 'Fetching...'; // Variable to hold mustard price

  @override
  void initState() {
    super.initState();
    fetchMustardPrice(); // Fetch price when the app starts
  }

  // Function to fetch mustard price
  Future<void> fetchMustardPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/mustard/uttar-pradesh/basti';

    String price = await fetchCropPrice(url);

    setState(() {
      mustardPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 2.25; // 2-2.5 kg of seed per acre

      // Fertilizer requirements based on given data
      fertilizerUrea = landSize * 55; // for Toria, update as needed
      fertilizerSSP = landSize * 50; // for Toria, update as needed
      fertilizerMOP = 0; // Apply K dose only when soil shows deficiency
      growingDays = 125;
      // Adjust the requirements based on the crop type
      if (_isRayaOrGobhiSarson) {
        fertilizerUrea = landSize * 90;
        fertilizerSSP = landSize * 75;
        fertilizerMOP = landSize * 10;
      } else if (_isRainfedRaya) {
        fertilizerUrea = landSize * 33;
        fertilizerSSP = landSize * 50;
        fertilizerMOP = 0;
      }
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  // Helper to determine crop type
  bool get _isRayaOrGobhiSarson => false; // Implement your logic here
  bool get _isRainfedRaya => false; // Implement your logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Mustard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/mustard.png',
              fit: BoxFit.cover,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Mustard Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: alluvial loam (जलोढ़ दोमट)',
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
                fetchMustardPrice(); // Fetch price when calculate button is pressed
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
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Mustard Seed Price: $mustardPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
