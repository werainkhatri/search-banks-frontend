import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../core/constants.dart';
import '../core/utils/app_routes.dart';
import '../widgets/cities_dropdown.dart';
import '../widgets/pagination_manager.dart';
import 'cubit/bank_branches_cubit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controller for search bar
  late TextEditingController _searchController;

  /// Controller for page number
  late TextEditingController _pageNumberController;

  /// Last processed query
  late String _lastQuery;

  late int rowsPerPage, pageNumber;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _pageNumberController = TextEditingController(text: '1');
    _lastQuery = '';
    rowsPerPage = 10;
    pageNumber = 1;
    _scrollController = ScrollController();

    _searchController.addListener(() {
      String _currentQuery = _searchController.text.trim();
      // if last query is same as the current query, skip
      if (_lastQuery == _currentQuery) return;

      // wait for a certain amount of time and get api results only if the query remains the same
      Future.delayed(Duration(milliseconds: 400), () => _currentQuery).then((value) {
        if (value == _searchController.text.trim() && _lastQuery != value) {
          _lastQuery = value;
          getLatestData(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: LayoutBuilder(builder: (context, constraints) {
            double width = constraints.maxWidth;
            return Column(
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: width / 18),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Favourites', style: TextStyle(fontSize: 20)),
                    ),
                    onPressed: () {
                      context.vxNav.push(Uri.parse(AppRoutes.favouriteBranches));
                    },
                  ),
                ),
                Center(
                  child: Text(
                    'Bank Branches',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(flex: 4, child: Container()),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        controller: _searchController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder(), hintText: 'Search'),
                      ),
                    ),
                    Expanded(flex: 4, child: Container()),
                  ],
                ),
                SizedBox(height: 40),
                if (width > 800)
                  Row(
                    children: [
                      Expanded(flex: 2, child: Container()),
                      Expanded(flex: 4, child: CitiesDropdownWidget()),
                      Expanded(child: Container()),
                      Expanded(
                          flex: 2, child: Text('Rows per page: ', style: TextStyle(fontSize: 18))),
                      Expanded(
                        flex: 2,
                        child: StatefulBuilder(builder: (context, setState) {
                          return DropdownButtonFormField<int>(
                            decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 0)),
                            value: rowsPerPage,
                            onChanged: (newValue) {
                              if (rowsPerPage == newValue) return;
                              setState(() {
                                rowsPerPage = newValue!;
                              });
                              getLatestData(false);
                            },
                            items: [10, 20, 30, 40, 50]
                                .map<DropdownMenuItem<int>>(
                                  (e) =>
                                      DropdownMenuItem(value: e, child: Center(child: Text('$e'))),
                                )
                                .toList(),
                          );
                        }),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 4,
                        child: PaginationManager(
                          (int newPageNumber) {
                            pageNumber = newPageNumber;
                            getLatestData(false);
                          },
                          _pageNumberController,
                        ),
                      ),
                      Expanded(flex: 2, child: Container()),
                    ],
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(flex: 2, child: Container()),
                      Expanded(flex: 5, child: CitiesDropdownWidget()),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 3,
                        child: Text('Rows per page:', style: TextStyle(fontSize: 18)),
                      ),
                      Expanded(
                        flex: 3,
                        child: StatefulBuilder(builder: (context, setState) {
                          return DropdownButtonFormField<int>(
                            decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 0)),
                            value: rowsPerPage,
                            onChanged: (newValue) {
                              if (rowsPerPage == newValue) return;
                              setState(() {
                                rowsPerPage = newValue!;
                              });
                              getLatestData(false);
                            },
                            items: [10, 20, 30, 40, 50]
                                .map<DropdownMenuItem<int>>(
                                  (e) =>
                                      DropdownMenuItem(value: e, child: Center(child: Text('$e'))),
                                )
                                .toList(),
                          );
                        }),
                      ),
                      Expanded(flex: 2, child: Container()),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Container()),
                      Expanded(
                        flex: 10,
                        child: PaginationManager(
                          (int newPageNumber) {
                            pageNumber = newPageNumber;
                            getLatestData(false);
                          },
                          _pageNumberController,
                        ),
                      ),
                      Expanded(flex: 2, child: Container()),
                    ],
                  )
                ],
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 16,
                      child: DefaultTextStyle(
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                        child: BlocBuilder<BankBranchesCubit, BankBranchesState>(
                          builder: (context, state) {
                            if (state is BankBranchesInitial) {
                              return Center(child: Text(C.emptyQueryMessage));
                            } else if (state is BankBranchesLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is BankBranchesLoaded) {
                              if (state.tableRows.length == 1) {
                                return Center(child: Text(C.noResultsFoundMessage));
                              }
                              // int colsToRemove = 0;
                              List<TableRow> tableRows = [];
                              state.tableRows.forEach((e) {
                                List<Widget> columnsToDisplay = [];
                                e.forEachIndexed((i, element) {
                                  if ((width > 1500 || i != 4) &&
                                      (width > 1200 || i != 5) &&
                                      (width > 1000 || i != 6) &&
                                      (width > 800 || i != 7)) columnsToDisplay.add(element);
                                });
                                tableRows.add(TableRow(children: columnsToDisplay));
                              });
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                border: TableBorder.all(),
                                children: tableRows,
                              );
                            } else {
                              assert(state is BankBranchesError);
                              return Center(
                                child: Text(
                                  C.internetErrorMessage +
                                      '\nDescription: ${(state as BankBranchesError).description}',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: 40),
              ],
            );
          }),
        ),
      ),
    );
  }

  void getLatestData(bool newSearch) async {
    if (newSearch) pageNumber = 1;
    await context.read<BankBranchesCubit>().search(
          _searchController.text,
          rowsPerPage,
          pageNumber,
          context,
        );
    if (newSearch) _pageNumberController.text = '1';
  }
}
