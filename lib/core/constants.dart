class C {
  static const String apiUrl = 'searchbankbackend.herokuapp.com';

  static const String banksApiEndpoint = '/api/banks/';
  static const String branchesApiEndpoint = '/api/branches/';
  static const String ifscApiEndpoint = '/api/ifsc/';

  static String autocompleteApiUrl(String query, int limit, int offset) =>
      apiUrl + 'branches/autocomplete/?q=$query&limit=$limit&offset=$offset';

  static const String favoutiveSP = 'favourite_bank_branches';

  static const String internetErrorMessage =
      'Couldn\'t connect. Check your internet connection and try again later';
}
