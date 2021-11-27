import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_expenses_app/model/transaction.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

import './constants/list_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS) ? CupertinoApp(
        title: "Personal Expenses",
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        theme: CupertinoThemeData(
          primaryColor: Colors.purple,
          textTheme: const CupertinoTextThemeData().copyWith(
            navTitleTextStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ) 
      :MaterialApp(
        title: "Personal Expenses",
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.purpleAccent,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              ),
            ),
          ),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(
            addTx: _addNewTransaction
          ),
          behavior: HitTestBehavior.opaque,
        );
      }
    );
  }

  bool showChart = false;

  List<Transaction> get _recentTransactions {
    return userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(int index) {
    userTransactions.removeAt(index);
    setState(() {});
  }

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Show Chart'),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: showChart,
          onChanged: (val) {
            setState(() {
              showChart = val;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPortraitContent(bool isLandScape, double bodyHeight) {
    return SizedBox(
      height: (isLandScape) ? bodyHeight * 0.75 : bodyHeight * 0.25,
      child: Chart(
        recentTransactions: _recentTransactions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    // final scaleText = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;

    PreferredSizeWidget appBarIOS = CupertinoNavigationBar(
      middle: const Text(
        'Personal Expenses',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        )
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => _startAddNewTransaction(context),
              child: const Icon(CupertinoIcons.add, size: 30,),
            ),
          )
        ],
      ),
    );

    PreferredSizeWidget appBar = AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Personal Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () => _startAddNewTransaction(context),
            ),
          )
        ],
    );

    final double bodyHeight = (size.height - ((Platform.isIOS) ? appBarIOS.preferredSize.height : appBar.preferredSize.height) - MediaQuery.of(context).padding.top);
    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              _buildLandscapeContent(),
            if (showChart || !isLandScape) 
              _buildPortraitContent(isLandScape, bodyHeight),
            if (!showChart)
              SizedBox(
                height: bodyHeight * 0.75,
                child: TransactionList(
                  transactions: userTransactions, 
                  deleteTx: _deleteTransaction,
                ),
              ),
          ],
        ),
      ),
    );
    return Platform.isIOS ? CupertinoPageScaffold(
      child: body,
    )
    :Scaffold(
      appBar: appBar,
      
      floatingActionButton: (Platform.isIOS) ? null : FloatingActionButton(
        child: const Icon(Icons.add, size: 30),
        onPressed: () => _startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      body: body,
    );
  }
}
