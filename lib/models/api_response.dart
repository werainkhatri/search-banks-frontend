import 'bank_branch.dart';

class APIResponse {
  final List<BankBranchModel> responseBranches;
  final int totalPageCount;

  APIResponse(this.responseBranches, this.totalPageCount);
}
