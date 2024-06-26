import 'package:flutter/material.dart';
import 'package:farmerpoint/api/price_api.dart';

class Cotton extends StatefulWidget {
  const Cotton({Key? key}) : super(key: key);

  @override
  State<Cotton> createState() => _CottonState();
}

class _CottonState extends State<Cotton> {
  final TextEditingController _landSizeController = TextEditingController();
  double fertilizer201010Sowing = 0.0;
  double fertilizer201010Flowering = 0.0;
  double ammoniumNitrate = 0.0;
  double npk0460 = 0.0;
  double npk0050 = 0.0;
  double foliarKNO3 = 0.0;
  double growingDays = 0.0;
  String cottonPrice = 'Fetching...'; // Variable to hold cotton price

  // Nutrient requirements per acre per day (converted from kg/ha/day to kg/acre/day)
  final List<Map<String, dynamic>> nutrientRequirements = [
    {"interval": "1-10", "N": 0.04, "P2O5": 0.00, "K2O": 0.05},
    {"interval": "11-20", "N": 0.08, "P2O5": 0.04, "K2O": 0.05},
    {"interval": "21-30", "N": 0.08, "P2O5": 0.04, "K2O": 0.15},
    {"interval": "31-40", "N": 0.20, "P2O5": 0.09, "K2O": 0.24},
    {"interval": "41-50", "N": 0.40, "P2O5": 0.09, "K2O": 0.24},
    {"interval": "51-60", "N": 0.81, "P2O5": 0.28, "K2O": 0.98},
    {"interval": "61-70", "N": 1.01, "P2O5": 0.37, "K2O": 1.22},
    {"interval": "71-80", "N": 1.82, "P2O5": 0.83, "K2O": 2.93},
    {"interval": "81-90", "N": 1.29, "P2O5": 0.47, "K2O": 0.98},
    {"interval": "91-100", "N": 1.34, "P2O5": 0.51, "K2O": 0.98},
    {"interval": "101-110", "N": 2.02, "P2O5": 0.97, "K2O": 1.22},
    {"interval": "111-120", "N": 0.20, "P2O5": 0.19, "K2O": 0.00},
    {"interval": "121-130", "N": 0.12, "P2O5": 0.09, "K2O": 0.00},
    {"interval": "131-150", "N": 0.03, "P2O5": 0.06, "K2O": 0.00},
  ];

  @override
  void initState() {
    super.initState();
    fetchCottonPrice(); // Fetch price when the app starts
  }

  // Function to fetch cotton price
  Future<void> fetchCottonPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/cotton-seed/karnataka/gadag';

    String price = await fetchCropPrice(url);

    setState(() {
      cottonPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      double totalN = 0.0;
      double totalP2O5 = 0.0;
      double totalK2O = 0.0;

      for (var interval in nutrientRequirements) {
        totalN += interval["N"]! *
            interval["interval"]
                .split('-')
                .map(int.parse)
                .reduce((a, b) => b - a + 1);
        totalP2O5 += interval["P2O5"]! *
            interval["interval"]
                .split('-')
                .map(int.parse)
                .reduce((a, b) => b - a + 1);
        totalK2O += interval["K2O"]! *
            interval["interval"]
                .split('-')
                .map(int.parse)
                .reduce((a, b) => b - a + 1);
      }

      // Total nutrients required for the given land size
      totalN *= landSize;
      totalP2O5 *= landSize;
      totalK2O *= landSize;

      // For simplicity, we will use totalN, totalP2O5, and totalK2O for displaying purposes
      // You can further break down these into individual day requirements if needed

      fertilizer201010Sowing = totalN;
      fertilizer201010Flowering = totalP2O5;
      ammoniumNitrate = totalK2O;

      // Growing days for cotton to mature
      growingDays = 150; // Typically 150 days for cotton to mature
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Cotton'),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/cotton.png', // Make sure to update this image path
              fit: BoxFit.cover,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Cotton Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Black soil',
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
                fetchCottonPrice(); // Fetch price when calculate button is pressed
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            if (fertilizer201010Sowing > 0)
              Text(
                  'Total Nitrogen Required: ${fertilizer201010Sowing.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizer201010Flowering > 0)
              Text(
                  'Total Phosphorus Required: ${fertilizer201010Flowering.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (ammoniumNitrate > 0)
              Text(
                  'Total Potassium Required: ${ammoniumNitrate.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Cotton Price: $cottonPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Nutrient Requirements Table (Kg/Acre/Day)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Time Interval (days)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('N (Kg/Acre/Day)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('P2O5 (Kg/Acre/Day)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('K2O (Kg/Acre/Day)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
                for (var interval in nutrientRequirements)
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(interval["interval"].toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(interval["N"].toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(interval["P2O5"].toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(interval["K2O"].toString()),
                    ),
                  ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
