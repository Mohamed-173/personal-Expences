import 'package:flutter/material.dart';
import './widget/chart.dart';
import './models/transaction.dart';
import './widget/list_transaction.dart';
import './widget/new_transactions.dart';

void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        appBarTheme: AppBarTheme(
          color: Colors.purple,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
            ),
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Transaction> transaction = [];

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return transaction.where((tx) {
      return tx.date!.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      {required String txTitle,
      required double txAmount,
      required DateTime txDate,
      required String txId}) {
    final tx = Transaction(
      name: txTitle,
      amount: txAmount,
      date: txDate,
      id: txId.toString(),
    );

    setState(() {
      transaction.add(tx);
    });
  }

  void _deleteTransaction({String? txId}) {
    setState(() {
      transaction.removeWhere((element) {
        return txId == element.id;
      });
    });
  }

  void _changeT({String? id, Transaction? txe}) {
    setState(() {
      print('onChanged');
      print(id);
      transaction.where((element) {
        if (txe!.id == element.id) {
          print('123456');
          element.name = txe.name;
          element.amount = txe.amount;
          element.date = txe.date;
          element.id = txe.id;
          return true;
        } else {
          print('onChanged 5321');
          return false;
        }
      }).toList();
    });
  }

  void _editTransaction(BuildContext ctx, Transaction txe) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: isLandScape
                  ? EdgeInsets.symmetric(vertical: 10)
                  : EdgeInsets.only(bottom: 1),
              color: Colors.transparent.withOpacity(0.55),
              height: 300,
              child: NewTransaction(
                addTx: _changeT,
                checker: true,
                txSelected: txe,
              ),
            ),
          );
        });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: isLandScape
                  ? EdgeInsets.symmetric(vertical: 10)
                  : EdgeInsets.only(bottom: 1),
              color: Colors.transparent.withOpacity(0.55),
              height: 300,
              child: NewTransaction(
                addTx: _addNewTransaction,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    final bool _isLandScape = mediaquery.orientation == Orientation.landscape;

    final appbar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text('Second App By Me '),
      centerTitle: true,
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white10,
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewTransaction(context);
            },
          ),
        )
      ],
    );

    final _listTransactions = Container(
      height: (mediaquery.size.height -
              appbar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
      child: ListTransaction(
        editTx: _editTransaction,
        addTx: transaction,
        deleteTx: _deleteTransaction,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbar,
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isLandScape)
              Container(
                  height: (mediaquery.size.height -
                          appbar.preferredSize.height -
                          mediaquery.padding.top) *
                      0.3,
                  child: Chart(_recentTransaction)),
            if (_isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Charts'),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  )
                ],
              ),
            if (_isLandScape)
              _showChart
                  ? Container(
                      height: (mediaquery.size.height -
                              appbar.preferredSize.height -
                              mediaquery.padding.top) *
                          0.7,
                      child: Chart(_recentTransaction))
                  : _listTransactions,
            if (!_isLandScape) _listTransactions
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 5,
          child: Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
