import 'package:farmerpoint/api/price_api.dart';
import 'package:flutter/material.dart';

class Jowar extends StatefulWidget {
  const Jowar({Key? key}) : super(key: key);

  @override
  State<Jowar> createState() => _JowarState();
}

class _JowarState extends State<Jowar> {
  final TextEditingController _landSizeController = TextEditingController();
  double seedRequired = 0.0;
  double fertilizerNitrogen = 0.0;
  double fertilizerPhosphorus = 0.0;
  double fertilizerPotassium = 0.0;
  double fertilizerSulfur = 0.0;
  double growingDays = 0.0;
  String jowarPrice = 'Fetching...';

  @override
  void initState() {
    super.initState();
    fetchJowarPrice();
  }

  Future<void> fetchJowarPrice() async {
    String url =
        'https://www.commodityonline.com/mandiprices/jowar-sorghum/karnataka/bangalore';
    String price = await fetchCropPrice(url);
    setState(() {
      jowarPrice = price;
    });
  }

  void _calculateRequirements() {
    setState(() {
      double landSize = double.tryParse(_landSizeController.text) ?? 0.0;

      // Seed requirement (kg/acre)
      seedRequired = landSize * 9;

      // Updated fertilizer requirements based on new data
      fertilizerNitrogen = landSize *
          112; // 112 kg/acre (1.12 pounds per bushel for 100 bushels)
      fertilizerPhosphorus =
          landSize * 20; // 20 kg/acre based on recommendations
      fertilizerPotassium = landSize * 30; // 30 kg/acre
      fertilizerSulfur =
          landSize * (fertilizerNitrogen / 15); // Keeping N:S ratio at 15:1

      // Growing days for jowar to mature
      growingDays = 110;
    });

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Jowar'),
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
                'assets/jowar.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Jowar Crop Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Suitable soil: Well-drained, fertile soil with a pH between 6.5 and 7.5. Apply lime if pH is below 5.6.',
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
                fetchJowarPrice();
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
            if (fertilizerPhosphorus > 0)
              Text(
                  'Phosphorus Required: ${fertilizerPhosphorus.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerPotassium > 0)
              Text(
                  'Potassium Required: ${fertilizerPotassium.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (fertilizerSulfur > 0)
              Text('Sulfur Required: ${fertilizerSulfur.toStringAsFixed(2)} kg',
                  style: TextStyle(fontSize: 18)),
            if (growingDays > 0)
              Text('Days to maturity: ${growingDays.toStringAsFixed(0)} days',
                  style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Jowar Seed Price: $jowarPrice',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
