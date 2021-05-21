import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search_banks/core/utils/service_locator.dart';
import 'screens/cubit/bank_branches_cubit.dart';
import 'screens/home.dart';

import 'models/favourite_branches.dart';

void main() async {
  await setup();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FavouriteBranches()),
        BlocProvider<BankBranchesCubit>(create: (_) => BankBranchesCubit()),
      ],
      child: MaterialApp(
        title: 'Material App',
        home: HomeScreen(),
      ),
    );
  }
}
