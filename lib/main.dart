import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart';

import 'core/utils/app_routes.dart';
import 'core/utils/service_locator.dart';
import 'models/data_manager.dart';
import 'screens/home.dart';
import 'screens/bank_details.dart';
import 'screens/cubit/bank_branches_cubit.dart';
import 'screens/favourites.dart';

void main() async {
  await setup();
  setPathUrlStrategy();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataManager()),
        BlocProvider<BankBranchesCubit>(create: (_) => BankBranchesCubit()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.grey,
          fontFamily: GoogleFonts.firaSans().fontFamily,
        ),
        title: 'Bank Branches',
        routeInformationParser: VxInformationParser(),
        routerDelegate: VxNavigator(routes: {
          AppRoutes.home: (_, __) => MaterialPage(child: HomeScreen()),
          AppRoutes.favouriteBranches: (_, __) => MaterialPage(child: FavouritesScreen()),
          AppRoutes.details: (uri, _) =>
              MaterialPage(child: BankDetailsScreen(uri.queryParameters['ifsc']!)),
        }),
      ),
    );
  }
}
