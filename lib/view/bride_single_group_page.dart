import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that displays a list of bridges within a selected group.
///
/// The `BrideSingleGroupPage` class is a stateful widget that shows a list of bridges
/// belonging to a specific group. The group is identified by its index, which is passed
/// as a parameter to the widget. The list of bridges is fetched using the `IBridgeBloc`
/// interface.
///
/// The `_BrideSingleGroupPageState` class manages the state of the `BrideSingleGroupPage`.
/// In the `initState` method, it retrieves the list of bridges for the selected group index
/// and stores it in the `_bridgeList` variable. The bridges are displayed in a `ListView`
/// using `ListView.builder`, with each bridge represented by a `Card` widget showing its
/// area code, coordinates, and structure type.
///
/// The `onTap` handler for each list item navigates to the `BridgeDetailPage` by calling
/// `Navigator.pushNamed` with the route path and the necessary arguments, using the
/// `RoutePaths.buildBridgeDetailPars` method to create the parameters.
class BrideSingleGroupPage extends StatefulWidget {
  final int selectedGroupIndex;

  const BrideSingleGroupPage({super.key, required this.selectedGroupIndex});

  @override
  // ignore: library_private_types_in_public_api
  _BrideSingleGroupPageState createState() => _BrideSingleGroupPageState();
}

class _BrideSingleGroupPageState extends State<BrideSingleGroupPage> {
  List<Bridge> _bridgeList = [];

  @override
  void initState() {
    super.initState();
    IBridgeBloc ibloc = context.read<IBridgeBloc>();
    _bridgeList = ibloc.getBridgeGroup(widget.selectedGroupIndex).bridges;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Bridge Group List'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _bridgeList.length,
            itemBuilder: (context, index) {
              final bridge = _bridgeList[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    'Area Code: ${bridge.areaCode}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Lat: ${bridge.latitudeStart}, Long: ${bridge.longitudeStart}'),
                      Text('Structure Type: ${bridge.structureType ?? 'N/A'}'),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.bridgeDetail,
                      arguments: RoutePaths.buildBridgeDetailPars(
                        widget.selectedGroupIndex,
                        index,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
