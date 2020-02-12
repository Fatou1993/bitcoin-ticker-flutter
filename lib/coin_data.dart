import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const COIN_API_URL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<dynamic> getCoinData(
      String initialCurrency, String selectedCurrency) async {
    http.Response response = await http.get(
        "$COIN_API_URL/$initialCurrency/$selectedCurrency",
        headers: {"X-CoinAPI-Key": "A83CA6FB-713B-4888-B3B5-92C84D0236BD"});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Failed to get rates");
    }
  }
}
