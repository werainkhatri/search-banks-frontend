import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quiver/cache.dart';

import '../../core/constants.dart';
import '../../core/utils/logger.dart';
import '../../models/api_response.dart';
import '../../models/bank_branch.dart';
import '../../models/data_manager.dart';

part 'bank_branches_state.dart';

class BankBranchesCubit extends Cubit<BankBranchesState> {
  BankBranchesCubit() : super(BankBranchesInitial());

  Future<void> search(String query, int limit, int pageNumber, BuildContext context) async {
    if (query.isEmpty) {
      emit(BankBranchesInitial());
      return;
    }
    int offset = (pageNumber - 1) * limit;
    MapCache<String, APIResponse> cache = Provider.of<DataManager>(context, listen: false).cache;

    String cacheKey = query.trim() + ' ' + limit.toString() + ' ' + offset.toString();
    APIResponse? response = await cache.get(cacheKey);
    if (response != null) {
      List<List<Widget>> branchesToDisplay = response.responseBranches
          .map<List<Widget>>((branch) => branch.getRowWidgets())
          .toList()
            ..insert(0, BankBranchModel.getHeadings());
      emit(BankBranchesLoaded(
        branchesToDisplay,
        response.totalPageCount,
        response.responseBranches,
      ));
      return;
    }

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
        emit(BankBranchesError('Something went wrong. Please try again later'));
      } else {
        dynamic decodedResponse = jsonDecode(response.body);
        List<BankBranchModel> responseBranches = decodedResponse['result']
            .map<BankBranchModel>((json) => BankBranchModel.fromJson(json))
            .toList();

        cache.set(cacheKey, APIResponse(responseBranches, decodedResponse['total_page_count']));

        List<List<Widget>> branchesToDisplay = responseBranches
            .map<List<Widget>>((branch) => branch.getRowWidgets())
            .toList()
              ..insert(0, BankBranchModel.getHeadings());

        emit(BankBranchesLoaded(
          branchesToDisplay,
          decodedResponse['total_page_count'],
          responseBranches,
        ));
      }
    } catch (e) {
      emit(BankBranchesError(e.toString()));
    }
  }
}
