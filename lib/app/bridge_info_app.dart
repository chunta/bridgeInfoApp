import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/bloc/bride_data_fetcher.dart';
import 'package:bridge_info/router/app_route.dart';
import 'package:bridge_info/view/bride_detail_page.dart';
import 'package:bridge_info/view/bride_single_group_page.dart';
import 'package:bridge_info/view/bridge_group_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// A Flutter application that provides information about various bridge groups and details.
///
/// The `BridgeInfoApp` class is the main entry point of the application. It uses the `BlocProvider`
/// to provide the `BridgeBloc` instance throughout the app, which manages the state and business logic
/// related to fetching and displaying bridge information.
///
/// The app uses a `MaterialApp` with a custom `onGenerateRoute` function to navigate between different
/// pages, such as the list of bridge groups, a specific bridge group, and bridge details.
/// It also utilizes the `Logger` package to log important information and errors, ensuring proper handling
/// of route arguments.
///
/// Routes:
/// - Home: Displays the list of bridge groups.
/// - SingleBridgeGroup: Displays a single bridge group based on the selected index.
/// - BridgeDetail: Displays detailed information about a selected bridge.
///
/// Note: The `debugShowCheckedModeBanner` is set to false to hide the debug banner in the application.
class BridgeInfoApp extends StatelessWidget {
  BridgeInfoApp({super.key});
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IBridgeBloc>(
        create: (context) => BridgeBloc(dataFetcher: BridgeDataFetcher()),
        child: MaterialApp(
            title: 'Bridge Info App',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case RoutePaths.home:
                  return MaterialPageRoute(
                    builder: (context) => const BridgeGroupListPage(),
                  );
                case RoutePaths.singleBridgeGroup:
                  final SingleBridgeGroupPars? singleBridgeGroupPars =
                      settings.arguments as SingleBridgeGroupPars?;
                  if (singleBridgeGroupPars == null) {
                    _logger.e("singleBridgeGroupPars should not be null");
                    return MaterialPageRoute(
                      builder: (context) => const BridgeGroupListPage(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (context) => BrideSingleGroupPage(
                      selectedGroupIndex:
                          singleBridgeGroupPars.selectedBridgeGroupIndex,
                    ),
                  );
                case RoutePaths.bridgeDetail:
                  final bridgeDetailPars =
                      settings.arguments as BridgeDetailPars?;
                  if (bridgeDetailPars == null) {
                    _logger.e("bridgeDetailPars should not be null");
                    return MaterialPageRoute(
                      builder: (context) => const BridgeGroupListPage(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (context) => BridgeDetailPage(
                        selectedGroupIndex:
                            bridgeDetailPars.selectedBridgeGroupIndex,
                        selectedBridgeIndex:
                            bridgeDetailPars.selectedBridgeIndex),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (context) => const BridgeGroupListPage(),
                  );
              }
            }));
  }
}
