import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../models/bank_branch.dart';
import '../widgets/toggle_favourites_column.dart';

class BankDetailsScreen extends StatelessWidget {
  final String ifsc;
  const BankDetailsScreen(this.ifsc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
          return DefaultTextStyle(
            style: TextStyle(fontSize: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 0, 32),
                  child: Text(model.bankName, style: TextStyle(fontSize: 40)),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: (<List<String>>[
                    ['Branch', model.branch],
                    ['IFSC', model.ifsc],
                    ['Bank ID', model.bankId.toString()],
                    ['Address', model.address],
                    ['State', model.state],
                    ['City', model.city],
                    ['Favourite', '*'],
                  ]
                      .map<TableRow>((e) => TableRow(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  e[0] + ': ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 10),
                              if (e[1] == '*')
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ToggleFavouritesColumn(model.ifsc),
                                )
                              else
                                Text(e[1], softWrap: true),
                            ],
                          ))
                      .toList()),
                  columnWidths: {
                    0: FixedColumnWidth(150),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
