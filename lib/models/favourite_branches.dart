import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

class FavouriteBranches {
  /// List of bank branches made favourite by the user
  /// the list is kept sorted at each insertion to speed up search
  late List<String> favouriteBranches;
  late SharedPreferences preferences;

  FavouriteBranches() {
    preferences = GetIt.I.get<SharedPreferences>();
    _init();
  }

  void _init() {
    List<String>? favourites = preferences.getStringList(C.favoutiveSP);
    if (favourites != null) {
      favouriteBranches = favourites;
    } else {
      favouriteBranches = [];
      preferences.setStringList(C.favoutiveSP, favouriteBranches);
    }
  }

  void toggleFavouriteState(String ifscCode) {
    int index = binarySearch(favouriteBranches, ifscCode);
    if (index == -1) {
      favouriteBranches.insert(favouriteBranches.length, ifscCode);
    } else {
      favouriteBranches.removeAt(index);
    }
    favouriteBranches.sort();
    preferences.setStringList(C.favoutiveSP, favouriteBranches);
  }
}
