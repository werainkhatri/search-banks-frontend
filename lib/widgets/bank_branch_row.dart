import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/data_manager.dart';

class BankBranchFavourite extends StatefulWidget {
  final String bankIfscCode;
  BankBranchFavourite(this.bankIfscCode);

  @override
  _BankBranchFavouriteState createState() => _BankBranchFavouriteState();
}

class _BankBranchFavouriteState extends State<BankBranchFavourite> {
  @override
  Widget build(BuildContext context) {
    DataManager _favBranches = Provider.of<DataManager>(context);
    bool isFavourite = binarySearch(_favBranches.favouriteBranches, widget.bankIfscCode) != -1;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Tooltip(
          message: isFavourite ? 'Remove from favourites' : 'Add to favourites',
          child: IconButton(
            icon: isFavourite
                ? Icon(Icons.star_rate_rounded, color: Colors.yellow)
                : Icon(Icons.star_outline_rounded, color: Colors.grey),
            onPressed: () {
              _favBranches.toggleFavouriteState(widget.bankIfscCode);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
