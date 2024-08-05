import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that displays detailed information about a specific bridge.
///
/// The `BridgeDetailPage` class is a stateful widget that shows details about a bridge,
/// including its group index, area code, coordinates, and structure type. It receives
/// the selected group and bridge indices as input parameters and fetches the bridge
/// details using a `BridgeBloc` instance.
///
/// The `_BridgeDetailPageState` class handles the state of the `BridgeDetailPage` widget.
/// In the `initState` method, it retrieves the `Bridge` object corresponding to the selected
/// group and bridge indices using the `IBridgeBloc` interface. The bridge details are then
/// displayed in a list of `Card` widgets, each showing specific information about the bridge.
class BridgeDetailPage extends StatefulWidget {
  final int selectedGroupIndex;
  final int selectedBridgeIndex;

  const BridgeDetailPage({
    super.key,
    required this.selectedGroupIndex,
    required this.selectedBridgeIndex,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BridgeDetailPageState createState() => _BridgeDetailPageState();
}

class _BridgeDetailPageState extends State<BridgeDetailPage> {
  late Bridge _bridge;

  @override
  void initState() {
    super.initState();
    IBridgeBloc ibloc = context.read<IBridgeBloc>();
    _bridge = ibloc.getBridgeDetail(
      widget.selectedGroupIndex,
      widget.selectedBridgeIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridge Detail'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Group Index'),
                  subtitle: Text('${widget.selectedGroupIndex}'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Area Code'),
                  subtitle: Text('${_bridge.areaCode ?? 0}'),
                ),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Latitude Start'),
                  subtitle: Text('${_bridge.latitudeStart}'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Latitude End'),
                  subtitle: Text('${_bridge.latitudeEnd}'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Longitude Start'),
                  subtitle: Text('${_bridge.longitudeStart}'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Longitude End'),
                  subtitle: Text('${_bridge.longitudeEnd}'),
                ),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Structure Type'),
                  subtitle: Text(_bridge.structureType ?? ''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
