import 'package:path_provider/path_provider.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._internal();

  final String _table1Name = 'records';
  final String _table2Name = 'initialBalance';
  final String _table3Name = 'userName';
  final String _table4Name = 'currencySymbol';

  DbHelper._internal();

  Database? _database;

  Future<Database> get db async {
    _database ??= await _initializeDb();
    return _database!;
  }

  Future<Database> _initializeDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/records_db.db';

    return await openDatabase(path, version: 1, onCreate: (database, version) {
      database.execute('''
  CREATE TABLE $_table1Name(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT,
    amount REAL,
    date TEXT,
    time TEXT,
    type TEXT,
    memo TEXT,
    description TEXT,
    balance_id INTEGER,
    FOREIGN KEY (balance_id) REFERENCES $_table2Name(id) ON DELETE CASCADE ON UPDATE CASCADE
  )
''');

      database.execute('''
      CREATE TABLE $_table2Name(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        balance REAL
      )
    ''');
      database.execute('''
      CREATE TABLE $_table3Name(
        id INTEGER ,
        name Text
      )
    ''');

      database.execute('''
      CREATE TABLE $_table4Name(
        id INTEGER ,
        currency Text
      )
    ''');
    });
  }

  /// insert User_Name
  Future<int> insertUserDetail(UserModel user) async {
    return await (await db).insert(
      _table3Name,
      {
        'id': user.id,
        'name': user.name,
      },
    );
  }

  /// Get userName

  Future<List<UserModel>> getUserDetail() async {
    final response = await (await db).query(_table3Name);
    final users = <UserModel>[];
    for (var data in response) {
      final userDetail = UserModel(
        id: int.parse(data['id'].toString()),
        name: data['name'].toString(),
      );
      users.add(userDetail);
    }
    return users;
  }

  /// insert Currency_Symbol
  Future<int> insertCurrencySymbol(CurrencyModel currency) async {
    return await (await db).insert(
      _table4Name,
      {
        'id': currency.id,
        'currency': currency.currency,
      },
    );
  }

  /// Get Currency_Symbol

  Future<List<CurrencyModel>> getCurrencySymbol() async {
    final response = await (await db).query(_table4Name);
    final currencies = <CurrencyModel>[];
    for (var data in response) {
      final currencysymbol = CurrencyModel(
        id: int.parse(data['id'].toString()),
        currency: data['currency'].toString(),
      );
      currencies.add(currencysymbol);
    }
    return currencies;
  }

  /// new Insert iitail Amount
  /// Corrected insertInitialAmount method
  Future<void> insertInitialAmount(InitialBalanceModel balance) async {
    await (await db).insert(_table2Name, {
      'id': balance.id,
      'balance': balance.balance,
    });
  }

  /// Get Initial_amount

  Future<List<InitialBalanceModel>> getInitialAmount() async {
    final response = await (await db).query(_table2Name);
    final amounts = <InitialBalanceModel>[];
    for (var data in response) {
      final initialamount = InitialBalanceModel(
        id: int.parse(data['id'].toString()),
        balance: double.parse(data['balance'].toString()),
      );
      amounts.add(initialamount);
    }
    return amounts;
  }

  Future<void> addToBalance(double amount) async {
    List<InitialBalanceModel> balances = await getInitialAmount();

    if (balances.isEmpty) {
      print('No balance entry found. Please initialize the balance.');
      return;
    }

    // Assuming only one balance entry, get the first one
    InitialBalanceModel currentBalanceEntry = balances.first;
    double currentBalance = currentBalanceEntry.balance;
    double newBalance = currentBalance + amount;

    print(
        'Adding to balance: Current: $currentBalance, Added: $amount, New: $newBalance');

    // Update the balance in the database
    await (await db).update(
      _table2Name,
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [currentBalanceEntry.id], // Ensure we update the correct row
    );
  }

  Future<void> subtractFromBalance(double amount) async {
    List<InitialBalanceModel> balances = await getInitialAmount();

    if (balances.isEmpty) {
      print('No balance entry found. Please initialize the balance.');
      return;
    }

    // Assuming only one balance entry, get the first one
    InitialBalanceModel currentBalanceEntry = balances.first;
    double currentBalance = currentBalanceEntry.balance;
    double newBalance = currentBalance - amount;

    print(
        'Subtracting from balance: Current: $currentBalance, Subtracted: $amount, New: $newBalance');

    // Update the balance in the database
    await (await db).update(
      _table2Name,
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [currentBalanceEntry.id], // Ensure we update the correct row
    );
  }

  /// New inset method with forieng key
  Future<int> insert(RecordsModel record) async {
    print('Inserting record: Type = ${record.type}, Amount = ${record.amount}');

    // Get the current balance (assuming there's only one balance entry)
    List<InitialBalanceModel> balances = await getInitialAmount();
    if (balances.isEmpty) {
      print('No balance entry found. Please initialize the balance.');
      return -1;
    }
    InitialBalanceModel currentBalanceEntry = balances.first;

    int result = await (await db).insert(_table1Name, {
      'category': record.category,
      'description': record.description,
      'date': record.date,
      'memo': record.memo,
      'amount': record.amount,
      'type': record.type,
      'balance_id': currentBalanceEntry.id, // Set the foreign key
    });

    // Update the balance based on the type of record
    if (record.type == 'Income') {
      print('Income detected. Adding to balance.');
      await addToBalance(record.amount);
    } else if (record.type == 'Expense') {
      print('Expense detected. Subtracting from balance.');
      await subtractFromBalance(record.amount);
    }

    return result;
  }

  Future<void> printAllBalances() async {
    List<InitialBalanceModel> balances = await getInitialAmount();
    for (var balance in balances) {
      print('Balance ID: ${balance.id}, Balance Amount: ${balance.balance}');
    }
  }

  /// Again Update method with balance uodation
  Future<int> update(RecordsModel record) async {
    List<InitialBalanceModel> balances = await getInitialAmount();
    if (balances.isEmpty) {
      print('No balance entry found. Please initialize the balance.');
      return -1;
    }

    InitialBalanceModel currentBalanceEntry = balances.first;

    // Fetch the old record before updating to compare amounts
    RecordsModel? oldRecord = await getRecordById(record.id);

    if (oldRecord == null) {
      print('Record not found for update.');
      return -1;
    }

    // Calculate the difference and adjust the balance accordingly
    double amountDifference = record.amount - oldRecord.amount;

    if (record.type == 'Income') {
      await addToBalance(amountDifference); // Add difference if Income
    } else if (record.type == 'Expense') {
      await subtractFromBalance(
          amountDifference); // Subtract difference if Expense
    }

    return await (await db).update(
      _table1Name,
      {
        'category': record.category,
        'description': record.description,
        'date': record.date,
        'memo': record.memo,
        'amount': record.amount,
        'type': record.type,
        'balance_id': currentBalanceEntry.id,
        // Ensure we update with the correct foreign key
      },
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<RecordsModel?> getRecordById(int id) async {
    final response = await (await db).query(
      _table1Name,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (response.isNotEmpty) {
      final data = response.first;
      return RecordsModel(
        id: int.parse(data['id'].toString()),
        category: data['category'].toString(),
        description: data['description'].toString(),
        memo: data['memo'].toString(),
        date: data['date'].toString(),
        type: data['type'].toString(),
        amount: double.parse(data['amount'].toString()),
      );
    }
    return null;
  }

  /// New Update mehod with foreign key
  // Future<int> update(RecordsModel record) async {
  //   List<InitialBalanceModel> balances = await getInitialAmount();
  //   if (balances.isEmpty) {
  //     print('No balance entry found. Please initialize the balance.');
  //     return -1;
  //   }
  //   InitialBalanceModel currentBalanceEntry = balances.first;
  //
  //   return await (await db).update(
  //     _table1Name,
  //     {
  //       'category': record.category,
  //       'description': record.description,
  //       'date': record.date,
  //       'memo': record.memo,
  //       'amount': record.amount,
  //       'type': record.type,
  //       'balance_id': currentBalanceEntry.id, // Ensure we update with the correct foreign key
  //     },
  //     where: 'id = ?',
  //     whereArgs: [record.id],
  //   );
  // }

  /// new Delete function with balance deletion
  Future<int> delete(int recordId) async {
    // Fetch the record before deletion to adjust the balance
    RecordsModel? recordToDelete = await getRecordById(recordId);

    if (recordToDelete == null) {
      print('Record not found for deletion.');
      return -1;
    }

    // Adjust the balance based on the type of the record
    if (recordToDelete.type == 'Income') {
      await subtractFromBalance(
          recordToDelete.amount); // Subtract Income amount
    } else if (recordToDelete.type == 'Expense') {
      await addToBalance(recordToDelete.amount); // Add back Expense amount
    }

    return await (await db).delete(
      _table1Name,
      where: 'id = ?',
      whereArgs: [recordId],
    );
  }

  Future<List<RecordsModel>> getAll() async {
    final response = await (await db).query(_table1Name);
    final records = <RecordsModel>[];
    for (var data in response) {
      final allrecords = RecordsModel(
        id: int.parse(data['id'].toString()),
        category: data['category'].toString(),
        description: data['description'].toString(),
        memo: data['memo'].toString(),
        date: data['date'].toString(),
        // time: data['time'].toString(),
        type: data['type'].toString(),
        amount: double.parse(data['amount'].toString()),
      );
      records.add(allrecords);
    }
    return records;
  }
}

/// Previus insert maethod
// Future<int> insert(RecordsModel record) async {
//   print('Inserting record: Type = ${record.type}, Amount = ${record.amount}');
//
//   int result = await (await db).insert(_table1Name, {
//     'id': record.id,
//     'category': record.category,
//     'description': record.description,
//     'date': record.date,
//     'memo': record.memo,
//     'amount': record.amount,
//     'type': record.type,
//   });
//
//   // Update the balance based on the type of record
//   if (record.type == 'Income') {
//     print('Income detected. Adding to balance.');
//     await addToBalance(record.amount);
//     print(record.amount);
//   } else if (record.type == 'Expense') {
//     print('Expense detected. Subtracting from balance.');
//     await subtractFromBalance(record.amount);
//   }
//
//   return result;
// }

/// Inert record function
// Future<int> insert(RecordsModel record) async
// {
//   return await (await db).insert(_table1Name, {
//     'id': record.id,
//     'category': record.category,
//     'description': record.description,
//     'date': record.date,
//    // 'time':record.time,
//     'memo': record.memo,
//     'amount':record.amount,
//     'type': record.type,
//
//   },);
// }

/// Previous Upsate method
//   Future<int> update(RecordsModel record) async {
//     return await (await db).update(
//       _table1Name,
//       {
//         'category': record.category,
//         'description': record.description,
//         'date': record.date,
//         //'time':record.time,
//         'memo': record.memo,
//         'amount':record.amount,
//         'type': record.type,
//       },
//       where: 'id = ?',
//       whereArgs: [record.id],
//     );
//   }

//       database.execute('''
//   CREATE TABLE $_table1Name(
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     category TEXT,
//     amount REAL,
//     date TEXT,
//     time TEXT,
//     type TEXT,
//     memo TEXT,
//     description TEXT
//   )
// ''');

/// Previous insert initial_amount
// Future<Object> insertInitialAmount(InitialBalanceModel initamount) async {
//   // First, check if a balance already exists
//   List<InitialBalanceModel> balances = await getInitialAmount();
//
//   if (balances.isNotEmpty) {
//     print('Initial balance already exists. Returning existing balance.');
//     print('Existing balance: ${balances.first.balance}');
//
//     // Return the current balance of the first balance entry found
//     return {
//       'balance': balances.first.balance,  // Return the existing balance
//     };
//   }
//
//   // If no balance exists, insert a new one
//   int result = await (await db).insert(_table2Name, {
//     'id': initamount.id,
//     'balance': initamount.balance,
//   });
//
//   if (result > 0) {
//     print('Initial balance inserted successfully.');
//     return {
//       'balance': initamount.balance,  // Return the newly inserted balance
//     };
//   } else {
//     print('Failed to insert the initial balance.');
//     return {
//       'error': 'Failed to insert initial balance',
//     };
//   }
// }

// Future<void> resetBalanceTable() async {
//   await (await db).delete(_table2Name); // Clear the balance table
//   await insertInitialAmount(InitialBalanceModel(id: 1, balance: 0)); // Insert starting balance
// }

// Future<void> initializeBalance() async {
//   List<InitialBalanceModel> balances = await getInitialAmount();
//   if (balances.isEmpty) {
//     await insertInitialAmount(InitialBalanceModel(id: 1, balance: 0)); // Starting balance of 0
//   }
// }

/// Previous Delete function
// Future<int> delete(int recordId) async {
//   return await (await db).delete(
//     _table1Name,
//     where: 'id = ?',
//     whereArgs: [recordId],
//   );
// }
