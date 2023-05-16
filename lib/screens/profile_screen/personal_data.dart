import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bentz_stocks/constants.dart';
import 'package:bentz_stocks/providers/auth.dart';
import 'package:bentz_stocks/widgets/custom_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../widgets/loading.dart';

List<double> parseCoordinates(String value) {
  if (value == null) return [];
  return value.split(', ').map((e) => double.parse(e)).toList();
}

class PersonalData extends StatefulWidget {
  static const routeName = 'personal-data';

  const PersonalData({Key key}) : super(key: key);

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  String name, address, addressDetails, phone;
  List<double> addressCoordinates;

  Future<void> getData() async {
    User user = Provider.of<Auth>(context, listen: false).getUser();
    name = user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 12.0),
              child: const Loading(),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return PersonalDataWidget(
                name: name,
                address: address,
                addressDetails: addressDetails,
                addressCoordinates: addressCoordinates,
                phone: phone,
              );
            }
        }
      },
    );
  }
}

class PersonalDataWidget extends StatefulWidget {
  const PersonalDataWidget({
    Key key,
    this.name,
    this.address,
    this.phone,
    this.addressDetails,
    this.addressCoordinates,
  }) : super(key: key);

  final String name;
  final String address;
  final String addressDetails;
  final List<double> addressCoordinates;
  final String phone;

  @override
  State<PersonalDataWidget> createState() => _PersonalDataWidgetState();
}

class _PersonalDataWidgetState extends State<PersonalDataWidget> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _addressDetails = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  List<double> coordinates;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _name.text = widget.name;
    _address.text = widget.address;
    _addressDetails.text = widget.addressDetails;
    coordinates = widget.addressCoordinates;
    _phoneNumber.text = widget.phone;
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _addressDetails.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  Future<void> _changeData() async {
    // if (!_formKey.currentState.validate()) {
    //   // Invalid!
    //   return;
    // }
    // _formKey.currentState.save();

    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Updating...');
    await dialog.show();

    FocusManager.instance.primaryFocus?.unfocus();
    User user = Provider.of<Auth>(context, listen: false).getUser();
    // final userId = user.uid;
    // final String idToken =
    //     await Provider.of<Auth>(context, listen: false).refreshGetToken();
    // final url = Uri.parse('$database/usersDetails/$userId.json?auth=$idToken');
    // await http.patch(
    //   url,
    //   body: json.encode({
    //     'address': {
    //       'name': _address.text,
    //       'details': _addressDetails.text,
    //       'coordinates': '${coordinates[0]}, ${coordinates[1]}',
    //     },
    //     'phoneNumber': _phoneNumber.text,
    //   }),
    // );
    await user.updateDisplayName(_name.text);
    await dialog.hide();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 45,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: const Text(
            'Profilul meu',
            style: TextStyle(color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 0),
                child: Column(
                  children: [
                    InputField(
                      label: 'Nume și prenume',
                      icon: Icons.perm_identity_outlined,
                      inputController: _name,
                      textInputType: TextInputType.name,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Expanded(
                    //       child: InputField(
                    //         label: 'Adresă de livrare',
                    //         icon: Icons.location_city_outlined,
                    //         inputController: _address,
                    //         textInputType: TextInputType.streetAddress,
                    //       ),
                    //     ),
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(10),
                    //       child: Material(
                    //         color: Colors.white,
                    //         child: InkWell(
                    //           onTap: () {},
                    //           child: Container(
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 15,
                    //               vertical: 13,
                    //             ),
                    //             child: Icon(
                    //               Icons.arrow_forward_ios,
                    //               size: 20,
                    //               color: Theme.of(context).primaryColor,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //   ],
                    // ),
                    // InputField(
                    //   label: 'Detailii livrare',
                    //   icon: Icons.location_city_outlined,
                    //   inputController: _addressDetails,
                    //   textInputType: TextInputType.text,
                    // ),
                    // InputField(
                    //   label: 'Număr de telefon',
                    //   icon: Icons.phone_outlined,
                    //   inputController: _phoneNumber,
                    //   textInputType: TextInputType.phone,
                    // ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Salvează',
                color: kPrimaryColor,
                tap: () {
                  _changeData();
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController inputController;
  final TextInputType textInputType;
  final String label;
  final IconData icon;

  const InputField({
    Key key,
    @required this.inputController,
    @required this.textInputType,
    @required this.label,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = kPrimaryColor;
    const accentColor = kAccentColor;
    const backgroundColor = Colors.white;
    const errorColor = Color(0xffEF4444);

    return Container(
      // height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1),
          ),
        ],
      ),
      child: TextFormField(
        enabled: label != 'Adresă de livrare',
        controller: inputController,
        onChanged: (value) {},
        keyboardType: textInputType,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        maxLines: null,
        cursorColor: primaryColor,
        validator: (value) {
          if (label == 'Detailii livrare') {
            return null;
          }
          if (value.isEmpty) {
            return 'Va rugam introduceti o valoare!';
          }
          if (label == 'Număr de telefon') {
            if (value.length < 10 ||
                value.length > 13 ||
                value.contains(new RegExp(r'[a-z]')) ||
                value.contains(new RegExp(r'[A-Z]'))) {
              return 'Va rugam introduceti un numar de telefon valid!';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: const TextStyle(
            color: primaryColor,
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: primaryColor),
          hoverColor: Colors.green,
          filled: true,
          fillColor: backgroundColor,
          hintText: '',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          errorStyle: const TextStyle(color: errorColor),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }
}
