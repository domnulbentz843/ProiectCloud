import 'package:bentz_stocks/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../analysis/fundamental_analys_screen.dart';

class SearchStocks extends StatefulWidget {
  const SearchStocks({Key key}) : super(key: key);

  @override
  State<SearchStocks> createState() => _SearchStocksState();
}

class _SearchStocksState extends State<SearchStocks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor, kAccentColor],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Cautare stockuri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 500,
            height: 500,
            child: Lottie.asset('assets/lottie/search_stock.json'),
          ),
        ),
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<Map<String, String>> searchTerms = [
    {
      "name": "Apple",
      "symbol": "aapl",
    },
    {
      "name": "Tesla",
      "symbol": "tsla",
    },
    {
      "name": "OriZOOM VIDEO COMMUNICATIONS-A",
      "symbol": "ZM",
    },
    {
      "name": "ROKU INC",
      "symbol": "ROKU",
    },
    {
      "name": "CRISPR THERAPEUTICS AG",
      "symbol": "CRSP",
    },
    {
      "name": "EXACT SCIENCES CORP",
      "symbol": "EXAS",
    },
    {
      "name": "TELADOC HEALTH INC",
      "symbol": "TDOC",
    },
    {
      "name": "INTELLIA THERAPEUTICS INC",
      "symbol": "NTLA",
    },
    {
      "name": "UIPATH INC - CLASS A",
      "symbol": "PATH",
    },
    {
      "name": "BLOCK INC",
      "symbol": "SQ",
    },
    {
      "name": "BEAM THERAPEUTICS INC",
      "symbol": "BEAM",
    },
    {
      "name": "ROBLOX CORP -CLASS A",
      "symbol": "RBLX",
    },
    {
      "name": "SHOPIFY INC - CLASS A",
      "symbol": "SHOP",
    },
    {
      "name": "NVIDIA CORP",
      "symbol": "NVDA",
    },
    {
      "name": "SPOTIFY TECHNOLOGY SA",
      "symbol": "SPOT",
    },
    {
      "name": "Microsoft Corporation",
      "symbol": "MSFT",
    },
    {
      "name": "Amazon.com Inc.",
      "symbol": "AMZN",
    },
    {
      "name": "Alphabet Inc. Class A",
      "symbol": "GOOGL",
    },
    {
      "name": "Alphabet Inc. Class C",
      "symbol": "GOOG",
    },
    {
      "name": "Johnson & Johnson",
      "symbol": "JNJ",
    },
    {
      "name": "Procter & Gamble Company",
      "symbol": "PG",
    },
    {
      "name": "Visa Inc. Class A",
      "symbol": "V",
    },
    {
      "name": "JPMorgan Chase & Co.",
      "symbol": "JPM",
    },
    {
      "name": "Pfizer Inc.",
      "symbol": "PFE",
    },
    {
      "name": "Coca-Cola Company",
      "symbol": "KO",
    },
    {
      "name": "NIKE Inc. Class B",
      "symbol": "NKE",
    },
    {
      "name": "Advanced Micro Devices Inc.",
      "symbol": "AMD",
    },
    {
      "name": "Oracle Corporation",
      "symbol": "ORCL",
    },
    {
      "name": "Starbucks Corporation",
      "symbol": "SBUX",
    },
    {
      "name": "Netflix Inc.",
      "symbol": "NFLX",
    },
    {
      "name": "Ford Motor Company",
      "symbol": "F",
    },
    {
      "name": "General Motors Company",
      "symbol": "GM",
    },
    {
      "name": "Marriott International Inc. Class A",
      "symbol": "MAR",
    },
    {
      "name": "Ralph Lauren Corporation Class A",
      "symbol": "	RL",
    },
  ];

  // first overwrite to
  // clear the search text
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, String>> matchQuery = [];
    for (var element in searchTerms) {
      if (element["name"].toLowerCase().contains(query.toLowerCase()) ||
          element["symbol"].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: () {
            print('rezultate');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FundamentalAnalys(
                  from: 'searchStocks',
                  symbol: result['symbol'],
                  name: result["name"],
                ),
              ),
            );
          },
          leading: Icon(Icons.stacked_bar_chart),
          title: Text(
            result["name"] + " // // " + result["symbol"],
          ),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, String>> matchQuery = [];
    for (var element in searchTerms) {
      if (element["name"].toLowerCase().contains(query.toLowerCase()) ||
          element["symbol"].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: () {
            print('sugestii');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FundamentalAnalys(
                  from: 'searchStocks',
                  symbol: result['symbol'],
                  name: result["name"],
                ),
              ),
            );
          },
          leading: Icon(Icons.stacked_bar_chart),
          title: Row(
            children: [
              // Icon(Icons.stacked_bar_chart),
              Expanded(child: Text(result["name"] + " // " + result["symbol"])),
            ],
          ),
        );
      },
    );
  }
}

class SearchInputFb2 extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;

  const SearchInputFb2({
    @required this.searchController,
    @required this.hintText,
    Key key,
  }) : super(key: key);

  final primaryColor = kPrimaryColor;
  final secondaryColor = kAccentColor;
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        textAlign: TextAlign.center,
        onChanged: (value) {},
        style: TextStyle(fontSize: 14, color: accentColor),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 20, color: accentColor),
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(color: accentColor),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 20.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
