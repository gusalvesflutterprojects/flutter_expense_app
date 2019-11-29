import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import './widgets/chart.dart';
import './models/transaction.dart';
import './widgets/empty_transactions.dart';
import './widgets/add_transaction_form.dart';
import './widgets/transaction_list_container.dart';

void main() => runApp(MyApp());

var uuid = Uuid();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
              body1: TextStyle(
                fontFamily: 'SanFrancisco',
              ),
            ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontFamily: 'SanFrancisco',
          ),
        ),
        primarySwatch: Colors.purple,
        accentColor: Colors.greenAccent,
        errorColor: Colors.red[700],
      ),
      title: 'Expenses App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _limitValue = 1000;

  final List<Transaction> _transactions = [
    Transaction(
      id: uuid.v1(),
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New pajamas',
      amount: 80.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New waifu pillow',
      amount: 40.99,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New waifu pillow',
      amount: 40.99,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New waifu pillow',
      amount: 40.99,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'New waifu pillow',
      amount: 40.99,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: uuid.v1(),
      title: 'Before date',
      amount: 40.99,
      date: DateTime.now().subtract(Duration(days: 10)),
    ),
  ];

  DateTime get _firstDay {
    int sundayWeekdayNum = 7;
    DateTime lastSunday = DateTime.now();

    while (lastSunday.weekday != sundayWeekdayNum) {
      lastSunday = lastSunday.subtract(Duration(days: 1));
    }

    return lastSunday;
  }

  List<Transaction> get _weekTransactions {
    return _transactions
        .where((tx) =>
            tx.date.isAfter(_firstDay.subtract(Duration(days: 1))) &&
            tx.date.isBefore(DateTime.now()))
        .toList();
  }

  List<Transaction> get _olderTransactions {
    return _transactions
        .where(
          (tx) => tx.date.isBefore(
            _firstDay.subtract(
              Duration(days: 1),
            ),
          ),
        )
        .toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: AddTransactionForm(
            _addTransaction,
            _firstDay,
          ),
        );
      },
    );
  }

  void _addTransaction(
    String txTitle,
    double txAmount,
    DateTime txDate,
  ) {
    if (txTitle.isNotEmpty && txAmount > 0) {
      final newTx = Transaction(
        id: uuid.v1(),
        title: txTitle,
        amount: txAmount,
        date: txDate,
      );
      setState(
        () => _transactions.add(newTx),
      );

      Navigator.of(context).pop();
    }
  }

  void _removeTransaction(String txId) {
    setState(
      () => _transactions.removeWhere(
        (tx) => tx.id == txId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expenses App',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Chart(
            _weekTransactions,
            _firstDay,
            _limitValue,
          ),
          Expanded(
            child: _weekTransactions.length > 0 || _olderTransactions.length > 0
                ? ListView(
                    children: <Widget>[
                      _weekTransactions.length > 0
                          ? TransactionListContainer(
                              _weekTransactions,
                              _removeTransaction,
                              'Week spendings',
                            )
                          : Container(), // ? Render nothing
                      _olderTransactions.length > 0
                          ? TransactionListContainer(
                              _olderTransactions,
                              _removeTransaction,
                              'Older spendings',
                            )
                          : Container(), // ? Render nothing,
                    ],
                  )
                : EmptyTransactions(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: () => _startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
