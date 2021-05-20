import 'package:flutter/material.dart';

class BankBranchModel {
  final String ifsc;
  final int bankId;
  final String bankName;
  final String branch;
  final String address;
  final String city;
  final String distict;
  final String state;
  bool favourite;

  BankBranchModel({
    required this.ifsc,
    required this.bankId,
    required this.bankName,
    required this.branch,
    required this.address,
    required this.city,
    required this.distict,
    required this.state,
    required this.favourite,
  });

  factory BankBranchModel.fromJson(Map<String, dynamic> json, [bool isFavourite = false]) {
    return BankBranchModel(
      ifsc: json['ifsc'] as String,
      bankId: json['bank_id'] as int,
      bankName: json['bank_name'] as String,
      branch: json['branch'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      distict: json['district'] as String,
      state: json['state'] as String,
      favourite: isFavourite,
    );
  }

  TableRow getTableRow() {
    // TODO Add star to display state of favourite
    List<String> entries = [
      ifsc,
      bankId.toString(),
      bankName,
      branch,
      address,
      city,
      distict,
      state,
      favourite.toString(),
    ];
    return TableRow(
      children: entries
          .map((e) =>
              Center(child: Padding(padding: const EdgeInsets.all(8), child: SelectableText(e))))
          .toList(),
    );
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
