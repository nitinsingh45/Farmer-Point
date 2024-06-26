import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:io';

Future<String> fetchCropPrice(String url) async {
  try {
    print('Fetching URL: $url');
    var response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      var priceElement =
          document.querySelector('.sm_device_price > table > tbody > tr ');

      if (priceElement != null) {
        var priceText = priceElement.text.trim();
        var priceParts = priceText.split('\n').map((e) => e.trim()).toList();
        return priceParts
            .join(' | '); // Join parts into a single line separated by '|'
      } else {
        return 'Price not found';
      }
    } else {
      return 'Failed to fetch price';
    }
  } on SocketException catch (e) {
    return 'Error: Failed to connect to the server. Please check your internet connection.';
  } catch (e) {
    return 'Error: $e';
  }
}
