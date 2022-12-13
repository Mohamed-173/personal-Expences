import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class ListTransaction extends StatelessWidget {
  final Function? editTx;
  final List<Transaction>? addTx;
  final Function? deleteTx;
  ListTransaction({
    Key? key,
    this.addTx,
    this.deleteTx,
    this.editTx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return addTx!.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Container(
                  child: Text(
                    'No Transaction yet!',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemCount: addTx!.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: ListTile(
                  onTap: () {},
                  onLongPress: () {
                    editTx!(context, addTx![index]);

                    print(addTx![index].id);
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                              '\$${addTx![index].amount!.toStringAsFixed(0)}')),
                    ),
                  ),
                  title: Text(
                    '${addTx![index].name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                      '${DateFormat.yMMMd().format(addTx![index].date as DateTime)}'),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete, color: Colors.red),
                          label: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            deleteTx!(txId: addTx![index].id);
                          })
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteTx!(txId: addTx![index].id);
                          }),
                ),
              );
            },
          );
  }
}
