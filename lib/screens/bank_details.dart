import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_banks/core/constants.dart';
import 'package:search_banks/models/bank_branch.dart';
import 'package:http/http.dart' as http;

class BankDetailsScreen extends StatelessWidget {
  final String ifsc;
  const BankDetailsScreen(this.ifsc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<http.Response>(
        future: http.get(Uri.http(C.apiUrl, C.ifscApiEndpoint, {'q': ifsc})),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data?.statusCode != 200) {
            return Center(child: Text(C.noResultsFoundMessage));
          }
          BankBranchModel model = BankBranchModel.fromJson(jsonDecode(snapshot.data!.body)[0]);
          return Container(
            child: Text(model.bankName),
          );
        },
      ),
    );
  }
}
