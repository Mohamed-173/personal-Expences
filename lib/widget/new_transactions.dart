import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final bool? checker;
  final Transaction? txSelected;
  final Function? addTx;
  NewTransaction({this.addTx, this.checker, this.txSelected});
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  bool? chk;
  Transaction? txl;
  // _NewTransactionState() {
  //   if (widget.checker == null) {
  //   } else {
  //     if (widget.checker == true) {
  //       chk = widget.checker;
  //       txl = widget.txSelected;
  //     }
  //   }

  // }
  late List<Transaction> transaction;

  TextEditingController _nameControler = TextEditingController();
  TextEditingController _amountControler = TextEditingController();
  DateTime _datePicker = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.checker == true) {
      _datePicker = widget.txSelected!.date!;
    } else {
      return;
    }
    print(widget.checker);
    if (widget.checker != true) {
      print('its done: ${widget.checker}');
    }
    _nameControler = widget.checker == true
        ? TextEditingController(text: widget.txSelected!.name)
        : TextEditingController();

    _amountControler = widget.checker == true
        ? TextEditingController(text: widget.txSelected!.amount.toString())
        : TextEditingController();
  }

  void _onChanged() {
    if (_nameControler.text == widget.txSelected!.name &&
        _amountControler.text == widget.txSelected!.amount.toString() &&
        _datePicker == widget.txSelected!.date) {
      print(
        'its not deffrent : $_nameControler   : ${widget.txSelected!.name}',
      );
      Navigator.pop(context);
    } else {
      print(
        'its deffrent  ${_datePicker.toString()} :  ${widget.txSelected!.id}',
      );
      Transaction tx1 = Transaction(
          name: _nameControler.text,
          amount: double.parse(_amountControler.text),
          id: widget.txSelected!.id,
          date: _datePicker);

      widget.addTx!(
        id: widget.txSelected!.id,
        txe: tx1,
      );
      Navigator.pop(context);
    }
  }

  void _onSubmited() {
    if (_amountControler.text.isEmpty) {
      return;
    }
    final enteredTitle = _nameControler.text;
    final enteredAmount = double.parse(_amountControler.text);
    final enteredDate = _datePicker;
    if (enteredTitle.isEmpty || enteredAmount <= 0 || enteredDate == null) {
      return;
    }
    widget.addTx!(
        txTitle: enteredTitle,
        txAmount: enteredAmount,
        txDate: _datePicker,
        txId: widget.checker == true
            ? widget.txSelected!.id
            : DateTime.now().toString());
    _amountControler.clear();
    _nameControler.clear();

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7 - 1)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          _datePicker = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        // color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _nameControler,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: 'ex azad',
                ),
                onSubmitted: (_) =>
                    widget.checker == true ? _onChanged : _onSubmited,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // autofocus: true,
                controller: _amountControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: 'ex 12.57',
                ),
                onSubmitted: (_) =>
                    widget.checker == true ? _onChanged : _onSubmited,
              ),
            ),
            Container(
              // color: Colors.amber,
              margin: EdgeInsets.all(8),
              height: 50,
              child: Row(
                children: [
                  Text(_datePicker == null
                      ? 'No Date Chosen!'
                      : DateFormat.yMEd().format(_datePicker)),
                  FlatButton(
                    onPressed: () {
                      _presentDatePicker();
                    },
                    child: Text(
                      'Chose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
            Container(
              // width: 20,
              margin: EdgeInsets.only(right: 8),
              // padding: EdgeInsets.only(bottom: 5),
              child: RaisedButton(
                  // color: Theme.of(context).accentColor,
                  onPressed: widget.checker == true ? _onChanged : _onSubmited,
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button!.color,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
