class C {
  static const String apiUrl = 'searchbankbranches.herokuapp.com';

  static const String banksApiEndpoint = '/api/banks/';
  static const String branchesApiEndpoint = '/api/branches/';

  static String autocompleteApiUrl(String query, int limit, int offset) =>
      apiUrl + 'branches/autocomplete/?q=$query&limit=$limit&offset=$offset';
}
