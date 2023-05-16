import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bentz_stocks/screens/profile_screen/profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'auth_screen/login_screen.dart';
import 'my_stocks/my_stocks_screen.dart';
import 'recommended_stocks/recommended_stocks_screen.dart';
import 'search_stocks/search_stocks_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  User user;

  @override
  void initState() {
    user = Provider.of<Auth>(context, listen: false).getUser();

    _pages = [
      {
        'page': const RecommendedStocks(),
        'icon': Icons.trending_up_rounded,
        'label': 'Recomandari',
        'title': 'Recomandari',
      },
      {
        'page': const SearchStocks(),
        'icon': Icons.search_rounded,
        'label': 'Cautare',
        'title': 'Cautare',
      },
      {
        'page': const MyStocks(),
        'icon': Icons.account_balance_wallet_rounded,
        'label': 'Portofoliu',
        'title': 'Portofoliu',
      },
      {
        'page': const ProfileScreen(),
        'icon': Icons.person_rounded,
        'label': 'Contul meu',
        'title': 'Contul meu',
      }
    ];

    super.initState();
  }

  void _selectPage(int index) {
    final userr = Provider.of<Auth>(context, listen: false).getUser();
    if (index == 3 && userr == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar bottomBar = BottomNavigationBar(
      currentIndex: _selectedPageIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
      iconSize: 24,
      selectedIconTheme: const IconThemeData(size: 30),
      onTap: _selectPage,
      items: _pages
          .map(
            (e) => BottomNavigationBarItem(
              label: e['label'],
              icon: Icon(e['icon']),
            ),
          )
          .toList(),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          _pages[_selectedPageIndex]['title'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: bottomBar,
    );
  }
}
