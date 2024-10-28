class RecordsModel {
  int id;
  String category;
  double amount;
  String date;
 // String time;
  String type;
  String memo;
  String description;

  RecordsModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
   // required this.time,
    required this.type,
    required this.memo,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date,
      //'time': time,
      'type': type,
      'memo': memo,
      'description': description,
    };
  }

  factory RecordsModel.fromMap(Map<String, dynamic> map) {
    return RecordsModel(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
     // time: map['time'],
      type: map['type'],
      memo: map['memo'],
      description: map['description'],
    );
  }
}


class UserModel{
  int id;
  String name;

  UserModel({
    required this.id,
    required this.name,
  });
}

class CurrencyModel{
  int id;
  String currency;

  CurrencyModel({
    required this.id,
    required this.currency,
  });
}


class InitialBalanceModel{
  int id;
  double balance;

  InitialBalanceModel({
    required this.id,
    required this.balance,
});
}
