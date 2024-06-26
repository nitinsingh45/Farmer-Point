import 'package:flutter/material.dart';
import 'package:farmerpoint/api/price_api.dart';

class Wheat extends StatefulWidget {
  const Wheat({Key? key}) : super(key: key);

  @override
  State<Wheat> createState() => _WheatState();
}

class _WheatState extends State<Wheat> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerUrea = 0.0;
  double fertilizerDAP = 0.0;
  double fertilizerMOP = 0.0;
  double fertilizerZinc = 0.0;
  double growingDays = 0.0;
  String wheatPrice = 'Fetching...'; // Variable to hold wheat price
  List<String> irrigationSchedule = []; // List to hold irrigation schedule

  @override
  void initState() {
    super.initState();
    fetchWheatPrice(); // Fetch price when the app starts
  }

  // Function to fetch wheat price
  Future<void> fetchWheatPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/wheat/karnataka/bangalore';

    String price = await fetchCropPrice(url);

    setState(() {
      wheatPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 100; // 100 kg of seed per acre for wheat

      // Fertilizer requirements based on IIMR data for wheat
      fertilizerUrea = landSize * 50; // 50 kg/acre of Urea for wheat
      fertilizerDAP = landSize * 25; // 25 kg/acre of DAP for wheat
      fertilizerMOP = landSize * 12; // 12 kg/acre of MOP for wheat
      fertilizerZinc = landSize * 5; // 5 kg/acre of Zinc for wheat

      // Growing days for wheat to mature
      growingDays = 120; // Typically 120 days for wheat to mature

      // Calculate irrigation schedule based on growing days
      if (growingDays > 0) {
        irrigationSchedule.clear();
        irrigationSchedule
            .add('1st Irrigation: After sowing, within 3-4 weeks');
        irrigationSchedule.add('2nd Irrigation: After 40-45 days of sowing');
        irrigationSchedule.add('3rd Irrigation: After 60-65 days of sowing');
        irrigationSchedule.add('4th Irrigation: After 80-85 days of sowing');
        irrigationSchedule.add('5th Irrigation: After 100-105 days of sowing');
        irrigationSchedule.add('6th Irrigation: After 105-120 days of sowing');
      }
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Wheat'),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/wheat.png',
              fit: BoxFit.cover,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Wheat Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: loamy soil (लाहिन मिट्टी)',
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
                fetchWheatPrice(); // Fetch price when calculate button is pressed
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
                'Wheat Seed Price: $wheatPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
            if (irrigationSchedule.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: irrigationSchedule
                    .map((cycle) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            cycle,
                            style: TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
