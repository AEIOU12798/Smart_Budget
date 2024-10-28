import 'package:flutter/material.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/records_pages/expense_page.dart';
import 'package:smart_budget/records_pages/income_page.dart';
import 'package:smart_budget/ui/screens/home_page.dart';



class RecordDetailPage extends StatefulWidget {
  final RecordsModel? record;
  final String balance;
  final String name;
  final String currencySymbol;
  const RecordDetailPage({super.key, this.record, required this.name, required this.balance,required this.currencySymbol});

  @override
  _RecordDetailPageState createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  var records=<RecordsModel>[];
  // Fetch records from the database after updating
  Future<void> _fetchRecords() async {
    final fetchedRecords = await DbHelper.instance.getAll(); // Make sure this returns the latest records
    setState(() {
      records = fetchedRecords;
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
            onPressed: () async {
              if (widget.record != null && widget.record!.type =='Income') {
                final incomedata = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  IncomePage(recordsModel: widget.record, balance: widget.balance, name: widget.name, currencySymbol: widget.currencySymbol,),
                  ),
                );

                if (incomedata != null) {
                  await _fetchRecords(); // Fetch updated records

                  final incomeIndex = records.indexWhere((e) => e.id == incomedata.id);
                  if (incomeIndex != -1) {
                    setState(() {
                      // Update existing record
                      records[incomeIndex] = incomedata;
                    });
                  } else {
                    print('Record not found in the list');
                  }
                }
              }

              else if (widget.record != null && widget.record!.type =='Expense') {
                final expensedata = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensePage(recordModel: widget.record,Balance: widget.balance, name: widget.name, currencySymbol: widget.currencySymbol,),
                  ),
                );

                if (expensedata != null) {
                  await _fetchRecords(); // Fetch updated records

                  final expenseIndex = records.indexWhere((e) => e.id == expensedata.id);
                  if (expenseIndex != -1) {
                    setState(() {
                      // Update existing record
                      records[expenseIndex] = expensedata;
                    });
                  } else {
                    print('Record not found in the list');
                  }
                }
              }

            },
            icon: const Icon(Icons.edit),
          ),

          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await DbHelper.instance.delete(widget.record!.id);
              setState(() {
                records.removeWhere((element) => element.id == widget.record!.id);
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(initialAmount: widget.balance.toString(),name: widget.name,currencySymbol: widget.currencySymbol,)));  // Close the detail page after deleting
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_note_outlined,size: 30.0,),
                Text(
                  ' ${widget.record!.description}',
                  style: const TextStyle(fontSize: 25),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Category', style: TextStyle(fontSize: 18,color: Colors.black26),),
                Text(
                  ' ${widget.record!.category}', style: const TextStyle(fontSize: 18),),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Amount', style: TextStyle(fontSize: 18,color: Colors.black26),),
                Text(
                  ' ${widget.record!.amount}', style: const TextStyle(fontSize: 18),),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Date', style: TextStyle(fontSize: 18,color: Colors.black26),
                ),
                Text(
                  ' ${widget.record!.date}', style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text(
                  'Wallet', style: TextStyle(fontSize: 18,color: Colors.black26),
                ),
                Text(
                  ' Cash', style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Type', style: TextStyle(fontSize: 18,color: Colors.black26),
                ),
                Text(
                  ' ${widget.record!.type}', style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Memo', style: TextStyle(fontSize: 18,color: Colors.black26),
                ),
                Text(
                  ' ${widget.record!.memo}', style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height:1.0,color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

