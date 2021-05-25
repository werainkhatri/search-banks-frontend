import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/cubit/bank_branches_cubit.dart';

class PaginationManager extends StatefulWidget {
  final void Function(int pageNumber) listener;
  final TextEditingController pageNumberController;

  const PaginationManager(this.listener, this.pageNumberController);

  @override
  _PaginationManagerState createState() => _PaginationManagerState();
}

class _PaginationManagerState extends State<PaginationManager> {
  late final TextEditingController _pageNoController;
  late final FocusNode _focusNode;
  int totalPageCount = 0;
  int currentPageNumber = 1;

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
        if (state is BankBranchesLoaded) {
          totalPageCount = state.totalPageCount;
          currentPageNumber = int.parse(_pageNoController.text);
        } else {
          totalPageCount = 0;
          currentPageNumber = 1;
        }
        return Row(
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                onPressed: currentPageNumber > 1
                    ? () {
                        setState(() {
                          currentPageNumber--;
                        });
                        _pageNoController.text = currentPageNumber.toString();
                        Future.delayed(Duration(milliseconds: 500), () => currentPageNumber)
                            .then((value) {
                          if (value == currentPageNumber) widget.listener(currentPageNumber);
                        });
                      }
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
                    currentPageNumber = newPageNumber;
                    Future.delayed(Duration(milliseconds: 100), () => currentPageNumber)
                        .then((value) {
                      if (value == currentPageNumber) widget.listener(currentPageNumber);
                    });
                  } else {
                    _pageNoController.text = currentPageNumber.toString();
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
                onPressed: currentPageNumber < totalPageCount
                    ? () {
                        setState(() {
                          currentPageNumber++;
                        });
                        _pageNoController.text = currentPageNumber.toString();
                        Future.delayed(Duration(milliseconds: 100), () => currentPageNumber)
                            .then((value) {
                          if (value == currentPageNumber) widget.listener(currentPageNumber);
                        });
                      }
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
}
