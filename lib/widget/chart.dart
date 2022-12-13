import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './chart-bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);

  List<Map<String, dynamic>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalsum = 0.0;
      for (int i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date!.day == weekday.day &&
            recentTransaction[i].date!.month == weekday.month &&
            recentTransaction[i].date!.year == weekday.year) {
          totalsum += recentTransaction[i].amount!;
        }
      }
      // print(DateFormat.E().format(weekday));
      // print(totalsum);

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalsum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValue.map((date) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBars(
                date['day'].toString(),
                date['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (date['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
