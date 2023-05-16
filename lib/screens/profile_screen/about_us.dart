import 'package:bentz_stocks/main.dart';
import 'package:flutter/material.dart';
import 'package:bentz_stocks/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  static const routeName = 'about-us';

  const AboutUs({Key key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Cine sunt eu?',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        toolbarHeight: 45,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      'assets/logo/bentz_profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'BENTZ TEODOR-ALEXANDRU',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                child: Text(
                  'Academia de Studii Economice București',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  'CIBERNETICĂ, STATISTICĂ ŞI INFORMATICĂ ECONOMICĂ'
                      .toTitleCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  'Specializarea: SIMPRE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 13,
                  top: 10,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        await launch("tel://0745376364");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.call, color: kPrimaryColor),
                            SizedBox(width: 10),
                            Text('0745 376 364'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityChoose extends StatelessWidget {
  const CityChoose({
    Key key,
    this.text,
    this.selected,
  }) : super(key: key);

  final String text;
  final String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150,
      height: 75,
      decoration: BoxDecoration(
        border: selected == text
            ? Border.all(
                color: kPrimaryColor,
                width: 1.5,
              )
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop(text);
            },
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
