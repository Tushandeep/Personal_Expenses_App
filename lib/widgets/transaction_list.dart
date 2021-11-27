import 'package:flutter/material.dart';
import 'package:personal_expenses_app/model/transaction.dart';
import 'package:personal_expenses_app/widgets/transactionitem.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({ Key? key, required this.transactions, required this.deleteTx }) : super(key: key);

  final List<Transaction> transactions;
  final Function deleteTx;
  
  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    return (transactions.isEmpty) ? LayoutBuilder(
      builder: (context, size) {
        final height = size.maxHeight;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: (isLandScape) ? height * 0.7 : height * 0.4,
              child: Image.asset(
                'assets/images/waiting.png'
              )
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'No transactions added yet!',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 25,
              ),
            ),
          ],
        );
      }
    )
    :ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (_, index) {
        return TransactionItem(transaction: transactions[index], deleteTx: deleteTx, index: index);
      }
    );
  }
}
