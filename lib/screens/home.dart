import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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

  /// Last processed query
  late String _lastQuery;

  late int rowsPerPage, pageNumber;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _lastQuery = '';
    rowsPerPage = 10;
    pageNumber = 1;
    _scrollController = ScrollController();

    _searchController.addListener(() {
      String _current = _searchController.text.trim();
      // if last query is same as the current query, skip
      if (_lastQuery == _current) return;

      // wait for a certain amount of time and get api results only if the query remains the same
      Future.delayed(Duration(milliseconds: 200), () => _current).then((value) {
        if (value == _searchController.text.trim() && _lastQuery != value) {
          _lastQuery = value;
          getLatestData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<int>(
      create: (context) => 1,
      child: Scaffold(
        body: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: ListView(
            controller: _scrollController,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 17,
                    child: Text(
                      'Bank Branches',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(flex: 5, child: CitiesDropdownWidget()),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Search'),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(child: Text('Rows per page: ')),
                  Expanded(
                    child: StatefulBuilder(builder: (context, setState) {
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 0)),
                        value: rowsPerPage,
                        onChanged: (newValue) {
                          if (rowsPerPage == newValue) return;
                          setState(() {
                            rowsPerPage = newValue!;
                          });
                          getLatestData();
                        },
                        items: [10, 20, 30, 40, 50, 100]
                            .map<DropdownMenuItem<int>>(
                              (e) => DropdownMenuItem(value: e, child: Center(child: Text('$e'))),
                            )
                            .toList(),
                      );
                    }),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                      flex: 2,
                      child: PaginationManager(
                        (int newPageNumber) {
                          pageNumber = newPageNumber;
                          getLatestData();
                        },
                        TextEditingController(text: '1'),
                      )),
                  Expanded(child: Container()),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 16,
                    child: DefaultTextStyle(
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                      child: BlocConsumer<BankBranchesCubit, BankBranchesState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is BankBranchesInitial) {
                            return Center(
                                child: Text('Enter a query to search for from the database'));
                          } else if (state is BankBranchesLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is BankBranchesLoaded) {
                            if (state.tableRows.length == 1) {
                              return Center(child: Text('No records for the given query found'));
                            }
                            return Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              border: TableBorder.all(),
                              children: state.tableRows,
                            );
                          } else {
                            assert(state is BankBranchesError);
                            return Center(
                              child: Text(
                                'No Internet Connection. Try again later\nDescription: ${(state as BankBranchesError).description}',
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
          ),
        ),
      ),
    );
  }

  void getLatestData() {
    context.read<BankBranchesCubit>().search(_searchController.text, rowsPerPage, pageNumber);
  }
}
