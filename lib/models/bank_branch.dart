import 'package:flutter/material.dart';

import '../widgets/details_redirect_column.dart';
import '../widgets/toggle_favourites_column.dart';

class BankBranchModel {
  final String ifsc;
  final int bankId;
  final String bankName;
  final String branch;
  final String address;
  final String city;
  final String distict;
  final String state;

  BankBranchModel({
    required this.ifsc,
    required this.bankId,
    required this.bankName,
    required this.branch,
    required this.address,
    required this.city,
    required this.distict,
    required this.state,
  });

  factory BankBranchModel.fromJson(Map<String, dynamic> json) {
    return BankBranchModel(
      ifsc: json['ifsc'] as String,
      bankId: json['bank_id'] as int,
      bankName: json['bank_name'] as String,
      branch: json['branch'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      distict: json['district'] as String,
      state: json['state'] as String,
    );
  }

  TableRow getTableRow() {
    List<String> entries = [
      ifsc,
      bankId.toString(),
      bankName,
      branch,
      address,
      city,
      distict,
      state,
    ];
    List<Widget> cellsInRow = entries
        .map<Widget>((e) =>
            Center(child: Padding(padding: const EdgeInsets.all(8), child: SelectableText(e))))
        .toList();
    cellsInRow.insert(cellsInRow.length, ToggleFavouritesColumn(ifsc));
    cellsInRow.insert(cellsInRow.length, DetailsRedirectColumn(this));
    return TableRow(children: cellsInRow);
  }

  static TableRow getHeadings() {
    final List<String> entries = [
      'IFSC',
      'Bank Id',
      'Bank Name',
      'Branch',
      'Address',
      'City',
      'Distict',
      'State',
      'Favourite',
      'Details',
    ];
    return TableRow(
      children: entries
          .map(
            (e) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child:
                    SelectableText(e, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          )
          .toList(),
    );
  }
}
