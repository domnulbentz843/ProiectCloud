import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'T&C + GDPR',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                  'Vă rugăm să rețineți că o parte semnificativă a acestei lucrări se bazează pe experiența personală.\n'),
              Text(
                  'Inexactitățile și omisiunile nu sunt responsabilitatea autorului. Această aplicație este oferită exclusiv în scop informativ și fără garanții de niciun fel.\n'),
              Text(
                  'Materialul, informațiile, tehnicile, metodele și datele din „Solution software for fundamental analysis of blue chip stocks” nu trebuie interpretate ca un sfat de investiții sau o sugestie de cumpărare sau vânzare de valori mobiliare.\n'),
              Text(
                  'În plus, accesând această aplicație, sunteți de acord să-l țineți pe autor fără vină și să îl scutiți de orice responsabilitate pentru orice pierdere (moneară sau de altă natură), daune (monetare sau de altă natură) sau prejudiciu (monetar sau de altă natură) pe care le puteți suferi.\n'),
              Text(
                  'Autorul nu își asumă nicio responsabilitate și nu este responsabil pentru nicio pierdere financiară sau alte daune suferite ca urmare a bazei pe materialul, informațiile, tehnicile, metodele sau datele incluse. Cititorul își asumă toate costurile și riscurile asociate cu orice decizie de investiție și/sau tranzacționare cu acțiuni. Tranzacționarea zilnică a acțiunilor penny implică un grad ridicat de risc.\n'),
              Text(
                  'Ar trebui să utilizați acest material la propria discreție și risc. Toate mărcile comerciale, mărcile de servicii, denumirile de produse și caracteristicile identificate sunt considerate a fi proprietatea proprietarilor respectivi și sunt utilizate numai în scopuri de identificare.\n'),
              Text(
                  'Această aplicație este dedicată celor care doresc să scape de căutarea nesfârșită a bogăției în care este prinsă majoritatea lumii. Apreciez efortul tău și sper să fii un comerciant uimitor.\n'),
            ],
          ),
        ),
      ),
    );
  }
}
