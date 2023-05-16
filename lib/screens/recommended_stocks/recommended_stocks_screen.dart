import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../widgets/loading.dart';
import '../analysis/fundamental_analys_screen.dart';

class RecommendedStocks extends StatefulWidget {
  const RecommendedStocks({Key key}) : super(key: key);

  @override
  State<RecommendedStocks> createState() => _RecommendedStocksState();
}

class _RecommendedStocksState extends State<RecommendedStocks> {
  List<Map<String, dynamic>> gainers = [];
  List<Map<String, dynamic>> losers = [];

  Future<void> getData(BuildContext context) async {
    const key = "941c820cf780e0f1184678e5ccd8d1b7";
    const apiKey = "?apikey=$key";
    String url1, url2;
    Uri uri1, uri2;

    // https://financialmodelingprep.com/api/v3/stock_market/gainers?apikey=YOUR_API_KEY
    url1 = "https://financialmodelingprep.com/api/v3/stock_market/gainers";
    uri1 = Uri.parse(url1 + apiKey);

    // https://financialmodelingprep.com/api/v3/stock_market/losers?apikey=YOUR_API_KEY
    url2 = "https://financialmodelingprep.com/api/v3/stock_market/losers";
    uri2 = Uri.parse(url2 + apiKey);

    final response1 = await http.get(uri1);
    final extractedData1 = json.decode(response1.body) as List<dynamic>;
    extractedData1.forEach((e) => gainers.add(e));
    gainers = gainers.take(10).toList();

    final response2 = await http.get(uri2);
    final extractedData2 = json.decode(response2.body) as List<dynamic>;
    extractedData2.forEach((e) => losers.add(e));
    losers = losers.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Loading();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    ...gainers.map(
                      (e) => Column(
                        children: [
                          StockCardd(
                            name: e['name'],
                            ticker: e['symbol'],
                            price: e['price'],
                            change: e['change'],
                            changesPercentage: e['changesPercentage'],
                            status: 'gainer',
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    ...losers.map(
                      (e) => Column(
                        children: [
                          StockCardd(
                            name: e['name'],
                            ticker: e['symbol'],
                            price: e['price'],
                            change: e['change'],
                            changesPercentage:
                                double.parse(e['changesPercentage'].toString()),
                            status: 'loser',
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
        }
      },
    );
  }
}

class StockCardd extends StatelessWidget {
  const StockCardd({
    Key key,
    this.ticker,
    this.name,
    this.onTap,
    this.price,
    this.change,
    this.changesPercentage,
    this.status,
  }) : super(key: key);

  final String ticker;
  final String name;
  final Function onTap;

  final double price;
  final double change;
  final double changesPercentage;

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FundamentalAnalys(
                    from: 'recommendedStocks',
                    symbol: ticker,
                    name: name,
                  ),
                ),
              );
            },
            child: Container(
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      color: kPrimaryColor,
                      child: Center(
                        child: Text(
                          ticker,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            change >= 0
                                ? '${price.toStringAsFixed(2)} (+${change.toStringAsFixed(2)})'
                                : '${price.toStringAsFixed(2)} (${change.toStringAsFixed(2)})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: status == 'gainer' ? kGreenColor : kRedColor,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Icon(
                              status == 'gainer'
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              changesPercentage >= 0
                                  ? '${changesPercentage.toStringAsFixed(2)}%'
                                  : '${(changesPercentage * -1).toStringAsFixed(2)}%',
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
