part of 'bank_branches_cubit.dart';

abstract class BankBranchesState {}

class BankBranchesInitial extends BankBranchesState {}

class BankBranchesLoading extends BankBranchesState {}

class BankBranchesLoaded extends BankBranchesState {
  final List<TableRow> tableRows;
  final int totalPageCount;

  BankBranchesLoaded(this.tableRows, this.totalPageCount);
}

class BankBranchesError extends BankBranchesState {
  final String description;

  BankBranchesError(this.description);
}
