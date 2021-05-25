import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../core/utils/app_routes.dart';
import '../models/bank_branch.dart';

class DetailsRedirectColumn extends StatelessWidget {
  final BankBranchModel model;

  const DetailsRedirectColumn(this.model);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        tooltip: 'View More Details',
        icon: Icon(Icons.open_in_new),
        onPressed: () {
          context.vxNav.push(Uri(path: AppRoutes.details, queryParameters: {'ifsc': model.ifsc}));
        },
      ),
    );
  }
}
