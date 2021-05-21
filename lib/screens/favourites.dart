import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../models/bank_branch.dart';
import '../models/data_manager.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen();

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late final DataManager manager;
  List<TableRow>? rows;

  @override
  void initState() {
    super.initState();
    manager = Provider.of<DataManager>(context, listen: false);
    getData();
  }

  Future<void> getData() async {
    if (manager.favouriteBranches.isEmpty) return;
    String favouriteQuery = manager.favouriteBranches[0];
    for (int i = 1; i < manager.favouriteBranches.length; i++) {
      favouriteQuery += ',' + manager.favouriteBranches[i];
    }
    http.Response response =
        await http.get(Uri.http(C.apiUrl, C.ifscApiEndpoint, {'q': favouriteQuery}));
    rows = [];
    if (response.statusCode == 200) {
      List<BankBranchModel> favourites = (jsonDecode(response.body) as List<dynamic>)
          .map<BankBranchModel>((map) => BankBranchModel.fromJson(map))
          .toList()
            ..sort((one, other) => one.ifsc.compareTo(other.ifsc));
      rows = favourites.map((e) => e.getTableRow()).toList();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    Widget child;
    if (manager.favouriteBranches.length == 0) {
      child = Center(
        child: Text('You don\'t have favourites asof now. '
            'You can go back and search for bank branches of your '
            'choice and add them to your favourite list.'),
      );
    } else if (rows == null) {
      child = Center(child: CircularProgressIndicator());
    } else if (rows!.isEmpty) {
      child = Center(child: Text(C.internetErrorMessage));
    } else {
      rows!.insert(0, BankBranchModel.getHeadings());
      child = Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(),
          children: rows!,
        ),
      );
    }

    return DefaultTextStyle(
      style: TextStyle(),
      textAlign: TextAlign.center,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Favourites'),
        ),
        body: Scrollbar(
          controller: _controller,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: _controller,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                Expanded(flex: 16, child: child),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
