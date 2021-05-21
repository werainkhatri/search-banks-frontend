import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/utils/logger.dart';
import '../models/bank_branch_model.dart';
import '../models/favourite_branches.dart';
import 'package:http/http.dart' as http;

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen();

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late final FavouriteBranchesManager manager;
  List<TableRow>? rows;

  @override
  void initState() {
    super.initState();
    manager = Provider.of<FavouriteBranchesManager>(context, listen: false);
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
      rows = jsonDecode(response.body)
          .map<TableRow>((map) => BankBranchModel.fromJson(map, true).getTableRow())
          .toList();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      child = SingleChildScrollView(
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
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            Expanded(flex: 16, child: child),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
