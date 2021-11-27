import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/model/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
    required this.index,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                '\$${transaction.amount}'
              )
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: (MediaQuery.of(context).size.width > 430) ? ElevatedButton.icon(
          onPressed: () => deleteTx(index), 
          icon: const Icon(
            Icons.delete,
          ), 
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            foregroundColor: MaterialStateProperty.all(Theme.of(context).errorColor),
            backgroundColor: MaterialStateProperty.all(Colors.white,)
          ),
          label: const Text('Delete')) 
          :IconButton(
          icon: const Icon(Icons.delete,),
          color: Theme.of(context).errorColor,
          onPressed: () => deleteTx(index),
        ),
      ),
    );
  }
}