import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';
import 'coin_data.dart';
import 'coin_data.dart';
import 'coin_data.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'EUR';
  String rate = '?';
  Map<String, String> rates =
      cryptoList.fold({}, (Map<String, String> rates, String crypto) {
    rates[crypto] = '?';
    return rates;
  });

  DropdownButton getAndroidDropDown() {
    return DropdownButton(
      value: selectedCurrency,
      items: currenciesList
          .map((currency) => DropdownMenuItem(
                child: Text(currency),
                value: currency,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getRates();
        });
      },
    );
  }

  CupertinoPicker getIOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = currenciesList[index];
          getRates();
        });
      },
      children: currenciesList.map((currency) => Text(currency)).toList(),
      scrollController: FixedExtentScrollController(
          initialItem: currenciesList.indexOf(selectedCurrency)),
    );
  }

  void getRates() async {
    CoinData coinData = new CoinData();
    rates.forEach((String initialCurrency, String previousRate) async {
      try {
        var exchangeRateData =
            await coinData.getCoinData(initialCurrency, selectedCurrency);
        setState(() {
          rates[initialCurrency] = exchangeRateData["rate"].toStringAsFixed(0);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  List<PriceElement> getPriceElements() {
    return cryptoList
        .map((crypto) => PriceElement(
            rate: rates[crypto],
            initialCurrency: crypto,
            selectedCurrency: selectedCurrency))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    getRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getPriceElements(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}

class PriceElement extends StatelessWidget {
  const PriceElement({
    Key key,
    @required this.rate,
    @required this.initialCurrency,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String rate;
  final String initialCurrency;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $initialCurrency = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
