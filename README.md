Bentz Teodor-Alexandru
SIMPRE, 1119
Proiect Cloud Computing - Bentz Stocks

Link video YouTube: https://youtu.be/KpRG0gkRmpM
Link .apk aplicatie Android: https://drive.google.com/file/d/1qMIpLSwa36x3cmAczfe4o54xgrPnXaH3/view?usp=sharing

Cuprins:
1. Introducere
2. Descriere problemă (0,25p)
3. Descriere API (0,25p)
4. Flux de date (0,25p)
5. Capturi ecran aplicație (0,25p)
6. Referințe

----------

1. 	Bentz Stocks este o aplicație mobilă care oferă utilizatorilor săi informații și analize în sfera investițiilor în acțiuni. Aceasta îi ajută pe utilizatori să ia decizii informate în ceea ce privește investițiile lor, oferindu-le acces la analize fundamentale ale acțiunilor, recomandări și informații despre evoluția pieței. Beneficiile acestei aplicații includ posibilitatea de a urmări portofoliul personal de acțiuni, de a căuta și analiza acțiuni, precum și de a primi recomandări personalizate. De asemenea, utilizatorii pot accesa termenii și condițiile de utilizare a aplicației, precum și informații despre creatorul acesteia. Prin intermediul Bentz Stocks, utilizatorii pot obține o mai bună înțelegere a pieței de acțiuni și pot lua decizii mai bine informate în ceea ce privește investițiile lor.

Aplicația prezentată are ca scop facilitarea procesului de investiții pentru utilizatorii săi. Într-o lume în care investițiile sunt din ce în ce mai importante, dar și mai complexe, această aplicație vine în ajutorul celor care doresc să investească în mod inteligent și eficient. 

Prin intermediul acestei aplicații, utilizatorii pot crea un cont de utilizator și pot introduce datele personale legate de cont, cum ar fi numele, prenumele, email-ul și parola. Sistemul va verifica corectitudinea acestora și va confirma sau îl va ruga să își reintroducă datele corecte. 

Aplicația are cinci clase, care permit utilizatorilor să acceseze informații legate de stocuri, să efectueze modificări asupra instanțelor celorlalte clase, să vizualizeze portofoliul de stocuri și să primească recomandări legate de anumite stocuri "hype". 

Utilizatorii pot solicita diferite aspecte legate de domeniul investițiilor, pentru a se documenta și pentru a-și atinge obiectivele. Prin intermediul interacțiunii cu aplicația, utilizatorii pot gestiona și vizualiza portofoliul de stocuri, iar aplicația le oferă îndrumare în sfera stockurilor, prin intermediul unor analize, care pe baza informațiilor transmise de utilizator, îi va facilita acestuia atingerea obiectivelor dorite. 

Într-o lume în care investițiile sunt din ce în ce mai importante, dar și mai complexe, această aplicație vine în ajutorul celor care doresc să investească în mod inteligent și eficient. Prin intermediul acestei aplicații, utilizatorii pot avea acces la informații actualizate și la recomandări legate de anumite stocuri, ceea ce le permite să ia decizii informate și să-și maximizeze profiturile. În plus, aplicația este ușor de utilizat și poate fi accesată de pe orice dispozitiv mobil, ceea ce o face foarte convenabilă pentru utilizatorii săi.


2. 	Conform informațiilor prezentate în context, integrarea cu API-ul de finance a fost realizată prin utilizarea API-urilor din Company Financial Ratios din cadrul Financial Modeling prep. Aceste API-uri au furnizat date statistico-economice și funcții matematice necesare pentru analiza fundamentală a unui stock. Astfel, aplicația a putut analiza din toate punctele de vedere un stock și a conturat o analiză detaliată.

Pentru a utiliza API-urile din Company Financial Ratios, dezvoltatorii aplicației au trebuit să se înregistreze și să obțină un API key. Acesta a fost utilizat pentru a face apeluri la API-uri și a obține datele necesare pentru analiza stocurilor. Integrarea cu API-ul de finance a fost esențială pentru funcționarea aplicației și pentru a oferi utilizatorilor informații relevante și actualizate despre stocurile pe care doresc să le investească.
Firebase – baza de date folosita 
Firebase este un serviciu gestionat de Google care oferă asistență și ajutor sistemelor informatice care au nevoie de o locație sigură de stocare a datelor. Acest serviciu utilizează date în timp real și nu necesită interogări speciale către server ori de câte ori clientul dorește să recupereze datele stocate; mai degrabă, datele sunt accesibile în mod constant la nivel de utilizator. Cu toate acestea, baza de date nu este relațională, nu comunică cu componentele învecinate și are o structură arborescentă care stochează obiecte JSON ca date. 
Am folosit Firebase Realtime Database, o bază de date non-relațională, pentru a stoca datele introduse de utilizator. Acest sistem este practic o bază de date bazată pe cloud care salvează datele aplicației ca obiecte JSON. Sincronizarea în timp real permite utilizatorilor să acceseze automat, să modifice, să elimine sau să insereze date în timp ce au acces la cele mai recente modificări. 
Combinarea acestor caracteristici și tehnologii mi-a permis să definesc o soluție software ce are la bază sistem informatic, într-o manieră simplă și logică. 

API și secvențe de cod
Pentru furnizarea de date statistico-economice și a funcțiilor matematice folosite, am apelat APIuri din Company Financial Ratios din cadrul Financial Modeling prep. Cu ajutorul lor am putut analiza din toate punctele de vedere un stock pentru a contura o analiză fundamentală. O analiză folosește majoritatea indicatorilor din tabelul de analiză de stocuri:

Tabel indici economico-statistico-matematici pentru AAPL
![photo_1](https://i.ibb.co/F35xCHt/Picture-1.png)
 
Pentru a înțelege raționamentul unei analize fundamentale, voi simplifica prin lucru tabelar algoritmul din spatele aplicației mele:

Analiză fundamentală în Excel din spatele logicii aplicației
![photo_2](https://i.ibb.co/C5HzfxL/Picture-2.png)

În continuare voi prezenta codul aferent analizei fundamentale, partea de structuri decizionale pe baza returnului dat de api la requesturile mele de date. Se poate observa cum aplicația alege concluzia potrivită și colorează instanța vizuală corespunzător pentru fiecare indice analizat:
  
```
  Text marketCapConclusion(String value) {
    int oneMillion = 1000000;
    int oneBillion = 1000000000;

    int parse = int.parse(value);

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

  // Functia care apeleaza toate api-urile de care am nevoie in analiza fundamentala
  Future<void> getData(BuildContext context) async {
    final symbolUpp = widget.symbol.toUpperCase();
    const key = "api123";
    const key2 = "api123";
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

    // exemplu preluare raspuns pentru primul call de api
    final response1 = await http.get(uri1);
    final extractedData1 = json.decode(response1.body) as List<dynamic>;
    if (extractedData1.toString() == "[]") {
      print('ceva');
    } else {
      print(extractedData1[0]);
      companyRatingApi = extractedData1[0];
    }
}
```

De asemenea, mai jos se poate observa și bucata de cod aferentă unei instanțe de recomandare de stock, din pagina „Recomandări”:

```

@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          ...mostGainersStocks.map(
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
          ...mostLosersStocks.map(
            (e) => Column(
              children: [
                StockCardd(
                  name: e['name'],
                  ticker: e['symbol'],
                  price: e['price'],
                  change: e['change'],
                  changesPercentage: e['changesPercentage'],
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
  
```


În imaginea 1 din Anexa 1  este reprezentată fereastra de înregistrare a contului în aplicația „Bentz Stocks”. Se pot observa 3 casete text ce trebuie completate de utilizator și un buton ce trebuie apăsat pentru ca aplicația să îi proceseze datele de conectare și să le salveze în baza de date Firebase. De asemenea, în partea central de jos, se observă și posibilitatea de conectare, dacă userul are deja un cont creat.

În imaginea 2 din Anexa 1  este reprezentată fereastra de autentificare a utilizatorului în aplicația „Bentz Stocks”. Se pot observa 2 casete text ce trebuie completate de utilizator și un buton ce trebuie apăsat pentru ca aplicația să îi proceseze datele de conectare. De asemenea, în partea central de jos, se observă și posibilitatea de înregistrare, dacă userul nu are un cont creat. În ultimul rând, sub butonul mov de autentificare există și opțiunea de „Ai uitat parola?” pe care utilizatorul o poate accesa în cazul pierderii credențialelor de logare.
În imaginea 3 din Anexa 1 este afișată pagina „Cine sunt eu?” regăsită ca buton în imaginea 5 din Anexa 1. Aici se află o poză cu mine, creatorul aplicației, numele meu, facultatea absolvită și modalitate de contact prin număr de telefon.

În imaginea 4 din Anexa 1 este afișată pagina „Termeni și condiții + GDPR” regăsită ca buton în imaginea 5 din Anexa 1. Aici se află  termenii și condițiile utilizări aplicației care mă absolvă de orice pierdere bănească a utilizatorilor care au folosit soluția mea software în analizele lor de piață.
În imaginea 5 din Anexa 1 este afișat meniul „Contul meu” de unde utilizatorul are acces la profilul său și paginile „Cine sunt eu?” și ”T&C + GDPR”. De asemenea, tot de aici se poate si deloga prin butonul central. Pentru a ajunge în acest meniu, utilizatorul trebuie să selecteze din josul aplicației a IV-a opțiune și ultima, cea de lângă marginea din dreapta jos a ecranului, intitulată „Contul meu”.

În imaginea 6 din Anexa 1 este afișat meniul de „Portofoliu” unde utilizator și-a adăugat stockurile favorite pentru a le urmări mai ușor. Aici este afișată o instanță cu fiecare acțiune ce cuprinde tickerul ei, numele și o opțiune de a genera o nouă analiză fundamentală pentru a vedea evoluția stockului. Când utilizatorul dă click pe una din comenzile din dreapta instanțelor, aplicația va afișa o analiză fundamentală a stockului ce va arăta exact ca în Imaginea 10 din Anexa 1, dar cu indicii updatați pentru momentul clickului.
În imaginea 7 din Anexa 1 este afișat meniul de „Căutare” de stockuri și o instanță de tip GIF ce ilustrează creșterea unor stocuri și criptomonezi. Din acest meniu utilizatorul poate căuta tickerul oricărei acțiuni de tipul blue chip. Când userul da click pe butonul de „search”, va fi redirecționat către imaginea 8 din Anexa 1.

În imaginea 8 din Anexa 1 sunt afișate căutările anterioare de stockuri și oferă posibilitatea utilizatorului să tasteze un ticker nou pentru a-l analiza fundamental. Când acesta va da click pe tickerul căutat și găsit, va fi redirecționat spre analiza sa fundamentală, adică instanța observabilă în imaginea 10 din anexa 1.

În imaginea 9 din Anexa 1 sunt afișate recomandările aplicației în legătură cu idei de stockuri care au crescut cel mai mult sau au scăzut cel mai mult în ultimele 24 de ore din punct de vedere procentual. Instanța de stock afișează în acest meniu de „Recomandări” tickerul, numele, prețul actual și creșterea în $. În partea din dreapta a instanței se poate observa atât din punct de vedere cromatic (culorile roșu și verde), dar și vizual (liniile de trend ascendent și descendent) dacă stocul afișat a crescut sau a scăzut. Când utilizatorul va da click pe una din aceste instanțe, va fi redirecționat spre analiza sa fundamentală, adică instanța observabilă în imaginea 10 din anexa 1.

În imaginea 10 din Anexa 1 este prezentată analiza fundamentală a unei acțiuni de tip chip. Aici se poate observa data, prețul actual, Ratingul, Scorul și recomandarea Aplicației. Cea din urmă poate fi Strong Buy, Buy, None, Sell și Strong Sell în funcție de indicii expuși mai jos si o concluzionare pe baza lor. Market Cap-ul reprezintă în dolari capitalul de piață în dolari. Restul indicilor sunt indici statistico matematici ce, prin algoritmi, afișează informații bune, neutre sau proaste despre starea stockului, alături de explicații. De asemenea acest lucru este sugerat și la nivel vizual prin culoarea concluziilor (verde – bun, galben – neutru și roșu – rău). În partea de jos a analizei fundamentale se poate observa de asemenea butonul ce oferă posibilitatea de a adăuga stockul pe lista de favorite, incluzându-l astfel în portofoliul personal.

5. Capturi ecran aplicatie

![photo_3](https://i.ibb.co/KmgVLYH/Whats-App-Image-2022-06-30-at-21-30-26-1.jpg)
![photo_4](https://i.ibb.co/5GxWszZ/Whats-App-Image-2022-06-30-at-21-30-26-2.jpg)
![photo_5](https://i.ibb.co/cDNVDSb/Whats-App-Image-2022-06-30-at-21-30-26-3.jpg)
![photo_6](https://i.ibb.co/bgJRmHs/Whats-App-Image-2022-06-30-at-21-30-26-4.jpg)
![photo_7](https://i.ibb.co/Bj77Rx2/Whats-App-Image-2022-06-30-at-21-30-26.jpg)
![photo_8](https://i.ibb.co/BsmRFcF/Whats-App-Image-2022-06-30-at-21-30-27-1.jpg)
![photo_9](https://i.ibb.co/5hHSP0P/Whats-App-Image-2022-06-30-at-21-30-27-2.jpg)
![photo_10](https://i.ibb.co/w4n3fw4/Whats-App-Image-2022-06-30-at-21-30-27-3.jpg)
![photo_11](https://i.ibb.co/XDr4YNK/Whats-App-Image-2022-06-30-at-21-30-27-4.jpg)
![photo_12](https://i.ibb.co/vvXVCdz/Whats-App-Image-2022-06-30-at-21-30-27.jpg)

6. References

[1] https://ark-funds.com/funds/arkk/
[2] https://boilerroomtrading.teachable.com/
[3] https://brokerchooser.com/broker-reviews/etoro-review
[4] https://eodhistoricaldata.com/financial-apis/
[5] https://finance.yahoo.com/
[6] https://fintel.io/
[7] https://finviz.com/
[8] https://geekflare.com/best-stock-market-api/
[9] https://marketchameleon.com/
[10] https://nagamarkets.com/
[11] https://polygon.io/
[12] https://rapidapi.com/blog/best-stock-api/
[13] https://site.financialmodelingprep.com/
[14] https://steelkiwi.com/blog/how-to-publish-your-app-on-the-app-store-and-google-play/ [15] https://taapi.io/
[16] https://tiomarkets.com/
[17] https://tradefeeds.com/
[18] https://treblle.com/
[19] https://wavebasis.com/
[20] https://www.appify.digital/post/flutter-app-development
[21] https://www.bloomberg.com/
[22] https://www.indiainfoline.com/markets/hot-stocks
[23] https://www.investopedia.com/
[24] https://www.nirmalbang.com/knowledge-center/benefits-of-investing-in-stocks.html [25] https://www.one-tab.com/page/
[26] https://www.plus500.com/ro
[27] https://www.refinitiv.com/
[28] https://www.sec.gov/edgar.shtml
[29] https://www.sofi.com/learn/content/history-of-the-stock-market/
[30] https://www.tradingview.com/
[31] https://www.wallstreetprep.com/knowledge/
[32] https://www.webull.com/ 

