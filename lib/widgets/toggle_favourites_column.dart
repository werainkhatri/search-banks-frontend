import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/data_manager.dart';

class ToggleFavouritesColumn extends StatefulWidget {
  final String bankIfscCode;
  ToggleFavouritesColumn(this.bankIfscCode);

  @override
  _ToggleFavouritesColumnState createState() => _ToggleFavouritesColumnState();
}

class _ToggleFavouritesColumnState extends State<ToggleFavouritesColumn> {
  @override
  Widget build(BuildContext context) {
    DataManager _favBranches = Provider.of<DataManager>(context);
    bool isFavourite = binarySearch(_favBranches.favouriteBranches, widget.bankIfscCode) != -1;
    return IconButton(
      tooltip: isFavourite ? 'Remove from favourites' : 'Add to favourites',
      icon: isFavourite
          ? Icon(Icons.star_rate_rounded, color: Colors.yellow)
          : Icon(Icons.star_outline_rounded, color: Colors.grey),
      onPressed: () {
        _favBranches.toggleFavouriteState(widget.bankIfscCode);
        setState(() {});
      },
    );
  }
}
