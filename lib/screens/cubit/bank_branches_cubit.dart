import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../../core/utils/logger.dart';
import '../../models/bank_branch_model.dart';

part 'bank_branches_state.dart';

class BankBranchesCubit extends Cubit<BankBranchesState> {
  BankBranchesCubit() : super(BankBranchesInitial());

  Future<void> search(String query, int limit, int pageNumber) async {
    if (query.isEmpty) {
      emit(BankBranchesInitial());
      return;
    }
    int offset = (pageNumber - 1) * limit;

    try {
      http.Response response = await http.get(Uri.http(C.apiUrl, C.branchesApiEndpoint, {
        'q': query.trim(),
        'limit': limit.toString(),
        'offset': offset.toString(),
      }));

      if (response.statusCode != 200) {
        Log.w(
            tag: 'BankBranchesCubit',
            message: 'Error while fetching details: Code ${response.statusCode}');
        emit(BankBranchesError(
            'Couldn\'t fetch the details. Check your internet connection and try again'));
      } else {
        // TODO test for favourite. Add a parameter to get the set of favourites.
        dynamic decodedResponse = jsonDecode(response.body);
        List<BankBranchModel> responseBranches = decodedResponse['result']
            .map<BankBranchModel>((json) => BankBranchModel.fromJson(json))
            .toList();
        List<TableRow> branchesToDisplay = responseBranches
            .map<TableRow>((branch) => branch.getTableRow())
            .toList()
              ..insert(0, BankBranchModel.getHeadings());
        emit(BankBranchesLoaded(
            branchesToDisplay, decodedResponse['total_page_count'], responseBranches));
      }
    } catch (e) {
      Log.e(tag: 'BankBranchesCubit', message: 'Exception while calling /api/branches/ api : $e');
    }
  }
}
