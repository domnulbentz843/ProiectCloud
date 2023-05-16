import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:bentz_stocks/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/auth.dart';
import '../../widgets/loading.dart';

class FundamentalAnalys extends StatefulWidget {
  const FundamentalAnalys({
    Key key,
    @required this.symbol,
    this.name,
    this.from = "stocks",
  }) : super(key: key);

  final String from;
  final String symbol;
  final String name;

  @override
  State<FundamentalAnalys> createState() => _FundamentalAnalysState();
}

class _FundamentalAnalysState extends State<FundamentalAnalys> {
  Text marketCapConclusion(String value) {
    double oneMillion = 1000000;
    double oneBillion = 1000000000;

    double parse;
    if (value.contains("E")) {
      // print(value);
      num n = num.parse(value.split('E')[0] + "E+" + value.split('E')[1]);
      // print(n);
      final convert = double.parse(n.toString());
      // print(convert);
      parse = convert;
    } else {
      parse = double.parse(value);
    }

    print(parse);
    if (parse < 300 * oneMillion) {
      return const Text(
        'Market Capitalisation MICRO / Growth Room MEGA',
        style: TextStyle(color: kAccentColor),
      );
    } else if (parse >= 300 * oneMillion && parse <= 2 * oneBillion) {
      return const Text(
        'Market Capitalisation SMALL / Growth Room LARGE',
        style: TextStyle(color: kAccentColor),
      );
    } else if (parse > 2 * oneBillion && parse <= 10 * oneBillion) {
      return const Text(
        'Market Capitalisation SMALL / Growth Room LARGE',
        style: TextStyle(color: kAccentColor),
      );
    } else if (parse > 10 * oneBillion && parse <= 200 * oneBillion) {
      return const Text(
        'Market Capitalisation SMALL / Growth Room LARGE',
        style: TextStyle(color: kAccentColor),
      );
    } else if (parse > 200 * oneBillion) {
      return const Text(
        'Market Capitalisation MEGA / Growth Room MICRO',
        style: TextStyle(color: kAccentColor),
      );
    } else {
      return const Text('error');
    }
  }

  Text priceEarningsRatioTTMConclusion(double value) {
    if (value < 50) {
      return const Text(
        'mic => profit MARE',
        style: TextStyle(color: kGreenColor),
      ); // verde
    } else if (value >= 50 && value <= 100) {
      return const Text(
        'mediu => profit MEDIU',
        style: TextStyle(color: kYellowColor),
      ); // galben
    } else if (value >= 100) {
      return const Text(
        'mare => profit MIC',
        style: TextStyle(color: kRedColor),
      ); // rosu
    } else {
      return const Text('error');
    }
  }

  Text priceToBookRatioTTMConclusion(double value) {
    value = value / 3;
    if (value <= 1.5) {
      return const Text(
        'stock undervalued',
        style: TextStyle(color: kGreenColor),
      ); // verde
    } else if (value > 1.5 && value <= 5) {
      return const Text(
        'stock ok',
        style: TextStyle(color: kYellowColor),
      ); // galben
    } else if (value > 5) {
      return const Text(
        'stock overvalued',
        style: TextStyle(color: kRedColor),
      ); // rosu
    } else {
      return const Text('error');
    }
  }

  Text priceEarningsRatioTTM2Conclusion(double value) {
    if (value >= 1) {
      return const Text(
        'stock este ok',
        style: TextStyle(color: kGreenColor),
      ); // verde
    } else if (value < 1) {
      return const Text(
        'stock nu este ok',
        style: TextStyle(color: kRedColor),
      ); // rosu
    } else {
      return const Text('error');
    }
  }

  Text returnOnInvestedCapitalConclusion(double value) {
    if (value >= 1.01) {
      return const Text(
        'stock este ok',
        style: TextStyle(color: kGreenColor),
      );
    } else if (value < 1.01) {
      return const Text(
        'stock nu este ok',
        style: TextStyle(color: kRedColor),
      );
    } else {
      return const Text('error');
    }
  }

  Text relativeStrengthIndexConclusion(double value) {
    if (value >= 7) {
      return const Text(
        'stock este overbought - entry point',
        style: TextStyle(color: kGreenColor),
      );
    } else if (value < 3) {
      return const Text(
        'stock este oversold - nu este entry point',
        style: TextStyle(color: kRedColor),
      );
    } else {
      return const Text('moment neutru pentru intrari / iesiri');
    }
  }

  Map<String, dynamic> companyRatingApi = {};
  Map<String, dynamic> stockFinancialScoreApi = {};
  Map<String, dynamic> companyFinancialRatiosApi = {};
  Map<String, dynamic> dailyOpenCloseApi = {};

  Future<void> getData(BuildContext context) async {
    final symbolUpp = widget.symbol.toUpperCase();
    const key = "bbf44bb05aad1bb8362187e28cd17b19";
    const key2 = "UKLy4TpYcS4wIYWH4fa2kwEKO6cbXVl1";
    const apiKey = "?apikey=$key";
    const apiKey1 = "apikey=$key";
    const apiKey2 = "&apiKey=$key2";
    final symbolElement = "?symbol=${widget.symbol.toUpperCase()}";
    String url1, url2, url3, url4;
    Uri uri1, uri2, uri3, uri4;

    url1 = "https://financialmodelingprep.com/api/v3/rating/";
    uri1 = Uri.parse(url1 + symbolUpp + apiKey);

    url2 = "https://financialmodelingprep.com/api/v4/score";
    uri2 = Uri.parse(url2 + symbolElement + '&' + apiKey1);

    url3 = "https://financialmodelingprep.com/api/v3/ratios-ttm/";
    uri3 = Uri.parse(url3 + symbolUpp + apiKey);

    const Duration oneDay = Duration(days: 2);
    const String formatData = 'yyyy-MM-dd';
    const String adjustedLink = '?adjusted=true';
    final date = DateFormat(formatData).format(DateTime.now().subtract(oneDay));
    url4 = "https://api.polygon.io/v1/open-close/";
    uri4 = Uri.parse(url4 + symbolUpp + "/" + date + adjustedLink + apiKey2);

    final response1 = await http.get(uri1);
    final extractedData1 = json.decode(response1.body) as List<dynamic>;
    if (extractedData1.toString() == "[]") {
      print('ceva');
    } else {
      print(extractedData1[0]);
      companyRatingApi = extractedData1[0];
    }

    final response2 = await http.get(uri2);
    final extractedData2 = json.decode(response2.body);
    print(extractedData2);
    if (extractedData2.toString() == "[]") {
      print('ceva');
    } else {
      // print(extractedData2[0].toString());
      stockFinancialScoreApi = extractedData2[0];
    }

    final response3 = await http.get(uri3);
    final extractedData3 = json.decode(response3.body);
    print(extractedData3[0].toString());
    companyFinancialRatiosApi = extractedData3[0];

    final response4 = await http.get(uri4);
    final extractedData4 = json.decode(response4.body);
    print(extractedData4);
    dailyOpenCloseApi = extractedData4;
  }

  Future<void> addStockToDatabase({@required User user}) async {
    ProgressDialog dialog = ProgressDialog(context, isDismissible: false);
    dialog.style(message: 'Adaugare stock...');
    await dialog.show();

    final userId = user.uid;
    String _idToken =
        await Provider.of<Auth>(context, listen: false).refreshGetToken();

    final url =
        Uri.parse('$database/usersDetails/$userId/stocks.json?auth=$_idToken');
    await http.post(
      url,
      body: json.encode({
        'name': widget.name,
        'symbol': widget.symbol,
        'added_at': DateTime.now().toIso8601String(),
      }),
    );

    await dialog.hide();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.symbol.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        toolbarHeight: 45,
      ),
      body: FutureBuilder(
        future: getData(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loading();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Type1(
                                  text1: 'Data',
                                  value1: companyRatingApi['date'] ?? '-',
                                  text2: 'Pret',
                                  value2: dailyOpenCloseApi["preMarket"] != null
                                      ? '${dailyOpenCloseApi["preMarket"]} USD'
                                      : '-',
                                ),
                                const SizedBox(height: 10),
                                Type2(
                                  text1: 'Rating',
                                  value1: companyRatingApi['rating'] ?? '-',
                                  text2: 'Scor rating',
                                  value2:
                                      companyRatingApi['ratingScore'] != null
                                          ? companyRatingApi['ratingScore']
                                              .toStringAsFixed(0)
                                          : '-',
                                  text3: 'Recomandare',
                                  value3: companyRatingApi[
                                          'ratingRecommendation'] ??
                                      '-',
                                ),
                                const SizedBox(height: 20),
                                ////
                                const Text(
                                  'Analiza fundamentala',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      if (stockFinancialScoreApi['marketCap'] !=
                                          null)
                                        Type3(
                                          text: 'Market Cap',
                                          value: stockFinancialScoreApi[
                                              'marketCap'],
                                          conclusion: marketCapConclusion(
                                              stockFinancialScoreApi[
                                                  'marketCap']),
                                        )
                                      else
                                        const Type3(
                                          text: 'Market Cap',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (companyFinancialRatiosApi[
                                              'peRatioTTM'] !=
                                          null)
                                        Type3(
                                          text: 'Price to Earnings',
                                          value: companyFinancialRatiosApi[
                                                  'peRatioTTM']
                                              .toStringAsFixed(6),
                                          conclusion:
                                              priceEarningsRatioTTMConclusion(
                                                  companyFinancialRatiosApi[
                                                      'peRatioTTM']),
                                        )
                                      else
                                        const Type3(
                                          text: 'Price to Earnings',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (companyFinancialRatiosApi[
                                              'pegRatioTTM'] !=
                                          null)
                                        Type3(
                                          text: 'Price to Book Ratio',
                                          value: companyFinancialRatiosApi[
                                                  'pegRatioTTM']
                                              .toStringAsFixed(6),
                                          conclusion:
                                              priceToBookRatioTTMConclusion(
                                                  companyFinancialRatiosApi[
                                                      'pegRatioTTM']),
                                        )
                                      else
                                        const Type3(
                                          text: 'Price to Book Ratio',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (companyFinancialRatiosApi[
                                              'priceEarningsToGrowthRatioTTM'] !=
                                          null)
                                        Type3(
                                          text: 'Earning per Share',
                                          value: companyFinancialRatiosApi[
                                                  'priceEarningsToGrowthRatioTTM']
                                              .toStringAsFixed(6),
                                          conclusion:
                                              priceEarningsRatioTTM2Conclusion(
                                                  companyFinancialRatiosApi[
                                                      'priceEarningsToGrowthRatioTTM']),
                                        )
                                      else
                                        const Type3(
                                          text: 'Earning per Share',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (companyFinancialRatiosApi[
                                              'returnOnEquityTTM'] !=
                                          null)
                                        Type3(
                                          text: 'Return on Invested Capital',
                                          value: companyFinancialRatiosApi[
                                                  'returnOnEquityTTM']
                                              .toStringAsFixed(6),
                                          conclusion:
                                              returnOnInvestedCapitalConclusion(
                                                  companyFinancialRatiosApi[
                                                      'returnOnEquityTTM']),
                                        )
                                      else
                                        const Type3(
                                          text: 'Return on Invested Capital',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (stockFinancialScoreApi[
                                              'piotroskiScore'] !=
                                          null)
                                        Type3(
                                          text: 'Relative Strength Index',
                                          value: stockFinancialScoreApi[
                                                  'piotroskiScore']
                                              .toStringAsFixed(6),
                                          conclusion:
                                              relativeStrengthIndexConclusion(
                                                  double.parse(
                                                      stockFinancialScoreApi[
                                                              'piotroskiScore']
                                                          .toString())),
                                        )
                                      else
                                        const Type3(
                                          text: 'Relative Strength Index',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      if (stockFinancialScoreApi[
                                              'workingCapital'] !=
                                          null)
                                        Type3(
                                          text: 'Working Capital',
                                          value: stockFinancialScoreApi[
                                              'workingCapital'],
                                          conclusion: null,
                                        )
                                      else
                                        const Type3(
                                          text: 'Working Capital',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (stockFinancialScoreApi[
                                              'totalAssets'] !=
                                          null)
                                        Type3(
                                          text: 'Total Assets',
                                          value: stockFinancialScoreApi[
                                              'totalAssets'],
                                          conclusion: null,
                                        )
                                      else
                                        const Type3(
                                          text: 'Total Assets',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (stockFinancialScoreApi[
                                              'totalLiabilities'] !=
                                          null)
                                        Type3(
                                          text: 'Total Liabilities',
                                          value: stockFinancialScoreApi[
                                              'totalLiabilities'],
                                          conclusion: null,
                                        )
                                      else
                                        const Type3(
                                          text: 'Total Liabilities',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      const Divider(height: 1),
                                      if (stockFinancialScoreApi['revenue'] !=
                                          null)
                                        Type3(
                                          text: 'Revenue',
                                          value:
                                              stockFinancialScoreApi['revenue'],
                                          conclusion: null,
                                        )
                                      else
                                        const Type3(
                                          text: 'Revenue',
                                          value: 'Not available',
                                          conclusion: Text(
                                            'not available',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (widget.from != 'myStocks')
                        if (user != null)
                          ButtonAddToPortfolio(
                            text: 'Adaugă în portofoliu',
                            onTap: () async {
                              print('hei');
                              await addStockToDatabase(user: user);
                            },
                          ),
                      const SizedBox(height: 35),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

class Type1 extends StatelessWidget {
  const Type1({
    Key key,
    this.text1,
    this.value1,
    this.text2,
    this.value2,
  }) : super(key: key);

  final String text1;
  final String value1;
  final String text2;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RowType(text: text1, value: value1),
        RowType(text: text2, value: value2),
      ],
    );
  }
}

class Type2 extends StatelessWidget {
  const Type2({
    Key key,
    this.text1,
    this.value1,
    this.text2,
    this.value2,
    this.text3,
    this.value3,
  }) : super(key: key);

  final String text1;
  final String value1;
  final String text2;
  final String value2;
  final String text3;
  final String value3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColumnType(text: text1, value: value1),
        ColumnType(text: text2, value: value2),
        ColumnType(text: text3, value: value3),
      ],
    );
  }
}

class Type3 extends StatelessWidget {
  const Type3({
    Key key,
    this.text,
    this.value,
    this.conclusion,
  }) : super(key: key);

  final String text;
  final String value;
  final Text conclusion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text),
              const SizedBox(width: 15),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          if (conclusion != null) conclusion,
        ],
      ),
    );
  }
}

class RowType extends StatelessWidget {
  const RowType({Key key, this.text, this.value}) : super(key: key);

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(value),
        ),
      ],
    );
  }
}

class ColumnType extends StatelessWidget {
  const ColumnType({Key key, this.text, this.value}) : super(key: key);

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class ButtonAddToPortfolio extends StatelessWidget {
  const ButtonAddToPortfolio({Key key, this.text, this.onTap})
      : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
