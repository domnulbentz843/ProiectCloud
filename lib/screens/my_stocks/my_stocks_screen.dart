import 'package:bentz_stocks/constants.dart';
import 'package:bentz_stocks/main.dart';
import 'package:bentz_stocks/screens/analysis/fundamental_analys_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../providers/auth.dart';

class MyStocks extends StatefulWidget {
  const MyStocks({Key key}) : super(key: key);

  @override
  State<MyStocks> createState() => _MyStocksState();
}

class _MyStocksState extends State<MyStocks> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    if (user == null) {
      return const Center(child: Text('user nu este autentificat'));
    }
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child('usersDetails/${user.uid}/stocks')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            final extractedData = snapshot.data.snapshot.value;
            print(extractedData);

            List<Map<String, dynamic>> myStocks = [];
            if (extractedData != null) {
              extractedData.forEach((stockId, stockData) {
                myStocks.add({
                  'name': stockData['name'],
                  'symbol': stockData['symbol'],
                });
              });
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  if (myStocks.isEmpty)
                    const Center(child: Text('no stocks'))
                  else
                    ...myStocks.map(
                      (e) => Column(
                        children: [
                          StockCard(
                            name: (e['name'] as String).toTitleCase(),
                            ticker: (e['symbol'] as String).toUpperCase(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FundamentalAnalys(
                                    from: 'myStocks',
                                    symbol: (e['symbol'] as String),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.redAccent),
              ),
            );
          }
        });
  }
}

class StockCard extends StatelessWidget {
  const StockCard({
    Key key,
    this.ticker,
    this.name,
    this.onTap,
  }) : super(key: key);

  final String ticker;
  final String name;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kPrimaryColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.2, 0.8],
                        colors: [
                          kPrimaryColor,
                          kAccentColor,
                        ],
                      ),
                    ),
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
                    child: Center(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.2, 0.8],
                        colors: [
                          kAccentColor,
                          kPrimaryColor,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
