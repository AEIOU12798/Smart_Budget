import 'package:flutter/material.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/records_pages/income_page.dart';
import 'package:smart_budget/ui/screens/records_detail.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String currencySymbol;
  final String initialAmount;

  const HomePage(
      {super.key,
      required this.initialAmount,
      required this.name,
      required this.currencySymbol});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<RecordsModel> records = <RecordsModel>[];
  dynamic recordsData;
  double? currentBalance;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
    fetchBalance();

    // Fetch records when the page loads
  }

  late double h = MediaQuery.of(context).size.height;

  Future<void> _fetchRecords() async {
    final data = await DbHelper.instance.getAll();
    setState(() {
      records.clear();
      records.addAll(data);
    });
  }

  // Fetch initial balance from the database
  Future<void> fetchBalance() async {
    List<InitialBalanceModel> balances =
        await DbHelper.instance.getInitialAmount();

    if (balances.isNotEmpty) {
      setState(() {
        currentBalance = balances.first.balance; // Get the first balance entry
      });
    } else {
      setState(() {
        currentBalance = double.parse(
            widget.initialAmount); // Set default if no balance is found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? name = widget.name;
    return Scaffold(
      appBar: AppBar(
        title: Text('$name', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff106e70),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 135.0),
        child: FloatingActionButton(
          elevation: 8.0,
          onPressed: () async {
            // Navigate to the IncomePage and await the new record
            final record = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => IncomePage(
                      currencySymbol: widget.currencySymbol,
                      balance: currentBalance?.toStringAsFixed(2) ??
                          widget.initialAmount,
                      name: widget.name,
                    )));
            // If a record is returned, refresh the records list
            if (record != null) {
              await _fetchRecords();

              // Fetch the updated list of records
            }
          },
          shape: const CircleBorder(eccentricity: 1.0),
          backgroundColor: const Color(0xff106e70),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40.0,
            color: const Color(0xff106e70),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    const Icon(Icons.wallet_rounded, color: Colors.white),
                    Row(
                      children: [
                        Text(
                          'Balance: ${widget.currencySymbol}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          ' ${currentBalance?.toStringAsFixed(2) ?? 'Loading...'}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 20.0),
          records.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.event_note_outlined,
                          size: 80.0, color: Color(0xff106e70)),
                      SizedBox(height: 30.0),
                      Center(
                          child: Text(
                        'No Record',
                        style: TextStyle(fontSize: 30.0),
                      )),
                      SizedBox(height: 10.0),
                      Center(
                          child: Text('Tap + button to add your first record')),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                   //  record.date=DateFormat('EEE, MMM d, ''yyyy').format(DateTime.now());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${record.date}'),
                            const Divider(height: 1.0, color: Colors.grey),
                            Card(
                              elevation: 5.0,
                              child: ListTile(
                                onTap: () async {
                                  final gotRecord = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => RecordDetailPage(
                                                record: record,
                                                name: widget.name,
                                                balance: currentBalance
                                                        ?.toStringAsFixed(2) ??
                                                    'Loading...',
                                                currencySymbol:
                                                    widget.currencySymbol,
                                              )));
                              
                                  if (gotRecord != null) {
                                    setState(() {
                                      final recordIndex = records.indexWhere(
                                          (e) => e.id == gotRecord.id);
                                      if (recordIndex != -1) {
                                        records[recordIndex] = gotRecord;
                                      }
                                    });
                                  }
                                },
                                leading: const Icon(Icons.note,color:Color(0xff106e70) ,),
                                title: Text(record.type),
                                subtitle: Text(record.category),
                                trailing: Text('${record.amount}'),


                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
