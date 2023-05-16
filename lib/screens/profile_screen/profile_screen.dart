import 'package:bentz_stocks/screens/auth_screen/login_screen.dart';
import 'package:bentz_stocks/screens/profile_screen/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bentz_stocks/providers/auth.dart';
import 'package:bentz_stocks/screens/profile_screen/about_us.dart';
import 'package:bentz_stocks/screens/profile_screen/personal_data.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        MenuButton(
          text: 'Profilul meu',
          avatar: Icons.account_circle_outlined,
          ending: Icons.arrow_forward_ios,
          tap: () {
            final user = Provider.of<User>(context, listen: false);
            if (user == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalData(),
                ),
              );
            }
          },
        ),
        MenuButton(
          text: 'Cine sunt eu?',
          avatar: Icons.people_outline,
          ending: Icons.arrow_forward_ios,
          tap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutUs(),
              ),
            );
          },
        ),
        MenuButton(
          text: 'T&C + GDPR',
          avatar: Icons.library_books_outlined,
          ending: Icons.arrow_forward_ios,
          tap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsAndConditions(),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        MenuButton2(
          text: 'Deconectare',
          avatar: Icons.logout,
          ending: Icons.arrow_forward_ios,
          tap: () async {
            await context.read<Auth>().signOut();
          },
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
    this.text,
    this.avatar,
    this.ending,
    this.tap,
  }) : super(key: key);

  final String text;
  final IconData avatar;
  final IconData ending;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: tap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(avatar, size: 30, color: kAccentColor),
                      const SizedBox(width: 15),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(ending, size: 28, color: kAccentColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton2 extends StatelessWidget {
  const MenuButton2({
    Key key,
    this.text,
    this.avatar,
    this.ending,
    this.tap,
  }) : super(key: key);

  final String text;
  final IconData avatar;
  final IconData ending;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: tap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(avatar, size: 30, color: kAccentColor),
                  const SizedBox(width: 15),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
