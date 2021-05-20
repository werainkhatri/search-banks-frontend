import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/cubit/bank_branches_cubit.dart';

class PaginationManager extends StatefulWidget {
  final Function(int pageNumber) listener;
  final TextEditingController pageNumberController;

  const PaginationManager(this.listener, this.pageNumberController);

  @override
  _PaginationManagerState createState() => _PaginationManagerState();
}

class _PaginationManagerState extends State<PaginationManager> {
  late final TextEditingController _pageNoController;
  late final FocusNode _focusNode;
  int totalPageCount = 1;

  @override
  void initState() {
    super.initState();
    _pageNoController = widget.pageNumberController;
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBranchesCubit, BankBranchesState>(
      builder: (context, state) {
        if (state is BankBranchesLoaded && state.tableRows.length > 1) {
          totalPageCount = state.totalPageCount;
        }
        return Row(
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                onPressed: (toInt(_pageNoController.text) ?? 0) > 1
                    ? () => updatePageNumber(toInt(_pageNoController.text)! - 1)
                    : null,
              ),
            ),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _pageNoController,
                onSubmitted: (newValue) {
                  int? newPageNumber = toInt(newValue);
                  if (newPageNumber != null) {
                    updatePageNumber(newPageNumber);
                  }
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'of $totalPageCount',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chevron_right_rounded),
                onPressed: (toInt(_pageNoController.text) ?? totalPageCount + 1) < totalPageCount
                    ? () => updatePageNumber(toInt(_pageNoController.text)! + 1)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  int? toInt(String value) => (value.isNotEmpty && int.tryParse(value) != null)
      ? int.parse(value).clamp(1, totalPageCount).toInt()
      : null;

  void updatePageNumber(int newPageNumber) {
    _pageNoController.text = (newPageNumber).toString();
    widget.listener(newPageNumber);
  }
}
