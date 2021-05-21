import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_banks/models/bank_branch_model.dart';
import 'package:search_banks/models/favourite_branches.dart';

class BankBranchFavourite extends StatefulWidget {
  final String bankIfscCode;
  BankBranchFavourite(this.bankIfscCode);

  @override
  _BankBranchFavouriteState createState() => _BankBranchFavouriteState();
}

class _BankBranchFavouriteState extends State<BankBranchFavourite> {
  @override
  Widget build(BuildContext context) {
    FavouriteBranches _favBranches = Provider.of<FavouriteBranches>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton(
          icon: binarySearch(_favBranches.favouriteBranches, widget.bankIfscCode) != -1
              ? Icon(Icons.star_rate_rounded, color: Colors.yellow)
              : Icon(Icons.star_outline_rounded, color: Colors.grey),
          onPressed: () {
            _favBranches.toggleFavouriteState(widget.bankIfscCode);
            setState(() {});
          },
        ),
      ),
    );
  }
}
