import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/userDetail/initial_amount.dart';

class Currency extends StatefulWidget {
  final String name;
  final CurrencyModel? currencyModel;

  const Currency({super.key, this.currencyModel, required this.name});

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  String? selectedCurrency;

  final categories = [
    'PKR - Pakistani Rupee', // Pakistan
    'AED - UAE Dirham', // Dubai (UAE)
    'INR - Indian Rupee', // India
    'USD - US Dollar', // America
    'EUR - Euro', // Eurozone
    'GBP - British Pound', // United Kingdom
    'CNY - Chinese Yuan', // China
    'JPY - Japanese Yen', // Japan
    'SAR - Saudi Riyal', // Saudi Arabia
    'AUD - Australian Dollar',
  ];

  String getCurrencySymbol(String currency) {
    if (currency.startsWith('USD')) return 'USD \$';
    if (currency.startsWith('AED')) return 'AED ';
    if (currency.startsWith('EUR')) return 'EUR €';
    if (currency.startsWith('GBP')) return 'GBP £';
    if (currency.startsWith('JPY')) return 'JPY ¥';
    if (currency.startsWith('INR')) return 'INR ₹';
    if (currency.startsWith('AUD')) return 'AUD \$';
    if (currency.startsWith('CAD')) return 'CAD \$';
    if (currency.startsWith('CHF')) return 'CHF Fr.';
    if (currency.startsWith('CNY')) return 'CNY ¥';
    if (currency.startsWith('PKR')) return 'PKR Rs';
    if (currency.startsWith('AFN')) return 'AFN ؋';
    if (currency.startsWith('ALL')) return 'ALL Lek';
    if (currency.startsWith('AMD')) return 'AMD ֏';
    if (currency.startsWith('ANG')) return 'ANG ƒ';
    if (currency.startsWith('AOA')) return 'AOA Kz';
    if (currency.startsWith('ARS')) return 'ARS ';
    if (currency.startsWith('AWG')) return 'AWG ƒ';
    if (currency.startsWith('AZN')) return 'AZN ₼';
    if (currency.startsWith('BAM')) return 'BAM KM';
    if (currency.startsWith('BBD')) return 'BBD ';
    if (currency.startsWith('BDT')) return 'BDT ৳';
    if (currency.startsWith('BGN')) return 'BGN лв';
    if (currency.startsWith('BHD')) return 'BHD .د.ب';
    if (currency.startsWith('BIF')) return 'BIF FBu';
    if (currency.startsWith('BMD')) return 'BMD ';
    if (currency.startsWith('BND')) return 'BND ';
    if (currency.startsWith('BOB')) return 'BOB Bs';
    if (currency.startsWith('BRL')) return 'BRL R';
    if (currency.startsWith('BSD')) return 'BSD ';
    if (currency.startsWith('BTN')) return 'BTN Nu.';
    if (currency.startsWith('BWP')) return 'BWP P';
    if (currency.startsWith('BYN')) return 'BYN Br';
    if (currency.startsWith('BZD')) return 'BZD ';
    if (currency.startsWith('CDF')) return 'CDF FC';
    if (currency.startsWith('CLP')) return 'CLP ';
    if (currency.startsWith('COP')) return 'COP ';
    if (currency.startsWith('CRC')) return 'CRC ₡';
    if (currency.startsWith('CUP')) return 'CUP ₱';
    if (currency.startsWith('CVE')) return 'CVE ';
    if (currency.startsWith('CZK')) return 'CZK Kč';
    if (currency.startsWith('DJF')) return 'DJF Fdj';
    if (currency.startsWith('DKK')) return 'DKK kr';
    if (currency.startsWith('DOP')) return 'DOP RD';
    if (currency.startsWith('DZD')) return 'DZD دج';
    if (currency.startsWith('EGP')) return 'EGP £';
    if (currency.startsWith('ERN')) return 'ERN Nfk';
    if (currency.startsWith('ETB')) return 'ETB Br';
    if (currency.startsWith('FJD')) return 'FJD ';
    if (currency.startsWith('FKP')) return 'FKP £';
    if (currency.startsWith('GEL')) return 'GEL ₾';
    if (currency.startsWith('GHS')) return 'GHS ₵';
    if (currency.startsWith('GIP')) return 'GIP £';
    if (currency.startsWith('GMD')) return 'GMD D';
    if (currency.startsWith('GNF')) return 'GNF FG';
    if (currency.startsWith('GTQ')) return 'GTQ Q';
    if (currency.startsWith('GYD')) return 'GYD ';
    if (currency.startsWith('HKD')) return 'HKD ';
    if (currency.startsWith('HNL')) return 'HNL L';
    if (currency.startsWith('HRK')) return 'HRK kn';
    if (currency.startsWith('HTG')) return 'HTG G';
    if (currency.startsWith('HUF')) return 'HUF Ft';
    if (currency.startsWith('IDR')) return 'IDR Rp';
    if (currency.startsWith('ILS')) return 'ILS ₪';
    if (currency.startsWith('IQD')) return 'IQD ع.د';
    if (currency.startsWith('IRR')) return 'IRR ﷼';
    if (currency.startsWith('ISK')) return 'ISK kr';
    if (currency.startsWith('JMD')) return 'JMD ';
    if (currency.startsWith('JOD')) return 'JOD د.ا';
    if (currency.startsWith('KES')) return 'KES Sh';
    if (currency.startsWith('KGS')) return 'KGS с';
    if (currency.startsWith('KHR')) return 'KHR ៛';
    if (currency.startsWith('KID')) return 'KID ';
    if (currency.startsWith('KMF')) return 'KMF CF';
    if (currency.startsWith('KRW')) return 'KRW ₩';
    if (currency.startsWith('KWD')) return 'KWD د.ك';
    if (currency.startsWith('KYD')) return 'KYD ';
    if (currency.startsWith('KZT')) return 'KZT ₸';
    if (currency.startsWith('LAK')) return 'LAK ₭';
    if (currency.startsWith('LBP')) return 'LBP ل.ل';
    if (currency.startsWith('LKR')) return 'LKR Rs';
    if (currency.startsWith('LRD')) return 'LRD ';
    if (currency.startsWith('LSL')) return 'LSL L';
    if (currency.startsWith('LYD')) return 'LYD ل.د';
    if (currency.startsWith('MAD')) return 'MAD د.م.';
    if (currency.startsWith('MDL')) return 'MDL Lei';
    if (currency.startsWith('MGA')) return 'MGA Ar';
    if (currency.startsWith('MKD')) return 'MKD ден';
    if (currency.startsWith('MMK')) return 'MMK K';
    if (currency.startsWith('MNT')) return 'MNT ₮';
    if (currency.startsWith('MOP')) return 'MOP P';
    if (currency.startsWith('MRO')) return 'MRO UM';
    if (currency.startsWith('MTL')) return 'MTL Lm';
    if (currency.startsWith('MUR')) return 'MUR Rs';
    if (currency.startsWith('MVR')) return 'MVR ރ';
    if (currency.startsWith('MWK')) return 'MWK MK';
    if (currency.startsWith('MXN')) return 'MXN ';
    if (currency.startsWith('MYR')) return 'MYR RM';
    if (currency.startsWith('MZN')) return 'MZN MT';
    if (currency.startsWith('NAD')) return 'NAD ';
    if (currency.startsWith('NGN')) return 'NGN ₦';
    if (currency.startsWith('NIO')) return 'NIO C';
    if (currency.startsWith('NOK')) return 'NOK kr';
    if (currency.startsWith('NPR')) return 'NPR रू';
    if (currency.startsWith('NZD')) return 'NZD ';
    if (currency.startsWith('OMR')) return 'OMR ﷼';
    if (currency.startsWith('PAB')) return 'PAB B/.';
    if (currency.startsWith('PEN')) return 'PEN S/';
    if (currency.startsWith('PGK')) return 'PGK K';
    if (currency.startsWith('PHP')) return 'PHP ₱';
    if (currency.startsWith('PKR')) return 'PKR Rs';
    if (currency.startsWith('PLN')) return 'PLN zł';
    if (currency.startsWith('PYG')) return 'PYG ₲';
    if (currency.startsWith('QAR')) return 'QAR ﷼';
    if (currency.startsWith('RON')) return 'RON lei';
    if (currency.startsWith('RSD')) return 'RSD дин.';
    if (currency.startsWith('RUB')) return 'RUB ₽';
    if (currency.startsWith('RWF')) return 'RWF Fr';
    if (currency.startsWith('SAR')) return 'SAR ر.س';
    if (currency.startsWith('SBD')) return 'SBD ';
    if (currency.startsWith('SCR')) return 'SCR ₨';
    if (currency.startsWith('SDG')) return 'SDG ج.س.';
    if (currency.startsWith('SEK')) return 'SEK kr';
    if (currency.startsWith('SGD')) return 'SGD ';
    if (currency.startsWith('SHP')) return 'SHP £';
    if (currency.startsWith('SLL')) return 'SLL Le';
    if (currency.startsWith('SOS')) return 'SOS Sh';
    if (currency.startsWith('SRD')) return 'SRD ';
    if (currency.startsWith('SSP')) return 'SSP £';
    if (currency.startsWith('STN')) return 'STN Db';
    if (currency.startsWith('SYP')) return 'SYP £';
    if (currency.startsWith('SZL')) return 'SZL E';
    if (currency.startsWith('THB')) return 'THB ฿';
    if (currency.startsWith('TJS')) return 'TJS ЅМ';
    if (currency.startsWith('TMT')) return 'TMT m';
    if (currency.startsWith('TND')) return 'TND د.ت';
    if (currency.startsWith('TOP')) return 'TOP ';
    if (currency.startsWith('TRY')) return 'TRY ₺';
    if (currency.startsWith('TTD')) return 'TTD ';
    if (currency.startsWith('TVD')) return 'TVD ';
    if (currency.startsWith('TZS')) return 'TZS Sh';
    if (currency.startsWith('UAH')) return 'UAH ₴';
    if (currency.startsWith('UGX')) return 'UGX Sh';
    if (currency.startsWith('UYU')) return 'UYU ';
    if (currency.startsWith('UZS')) return 'UZS so\'m';
    if (currency.startsWith('VES')) return 'VES Bs.S';
    if (currency.startsWith('VND')) return 'VND ₫';
    if (currency.startsWith('VUV')) return 'VUV Vt';
    if (currency.startsWith('WST')) return 'WST T';
    if (currency.startsWith('XAF')) return 'XAF FCFA';
    if (currency.startsWith('XAG')) return 'XAG XAG';
    if (currency.startsWith('XAU')) return 'XAU XAU';
    if (currency.startsWith('XCD')) return 'XCD ';
    if (currency.startsWith('XDR')) return 'XDR SDR';
    if (currency.startsWith('XOF')) return 'XOF CFA';
    if (currency.startsWith('XPF')) return 'XPF ₣';
    if (currency.startsWith('YER')) return 'YER ﷼';
    if (currency.startsWith('ZAR')) return 'ZAR R';
    if (currency.startsWith('ZMW')) return 'ZMW ZK';
    if (currency.startsWith('ZWL')) return 'ZWL Z';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Currency',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "What is your favourite currency",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // DropdownButton for currency selection
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedCurrency,
                hint: const Text('Select a currency'),
                items: categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue;
                  });
                },
                underline: Container(
                  height: 2,
                  color: const Color(
                      0xff106e70), // Change this to match your design
                ),
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),

            const SizedBox(height: 40),
            InkWell(
              onTap: () async {
                if (selectedCurrency != null) {
                  String currencySymbol = getCurrencySymbol(selectedCurrency!);
                  String? name = widget.name; // Access the name from the widget
                  CurrencyModel currency = CurrencyModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    currency: currencySymbol,
                  );

                  await DbHelper.instance.insertCurrencySymbol(currency);

                  if (name != null) {
                    moveToInitailAmount(
                        currencySymbol, name); // Pass both currency and name
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name is missing')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a currency')),
                  );
                }
              },
              child: Container(
                height: 60,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff106e70),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void moveToInitailAmount(String currencySymbol, String name) {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: InitailAmount(currencySymbol: currencySymbol, name: name),
        ));
  }
}
