import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that displays a list of bridge groups.
///
/// The `BridgeGroupListPage` class is a stateful widget that shows a list of bridge groups.
/// It initializes by retrieving the maximum value for the number of group members and
/// loading all bridge group data based on that limit. The page displays a list of bridge
/// groups and allows users to navigate to a detailed view of a selected group. It also
/// provides a slider to adjust the group member limit and refresh the list of bridge groups.
///
/// The `_BridgeGroupListPageState` class manages the state of the `BridgeGroupListPage` widget.
/// In the `initState` method, it retrieves the maximum number of group members and triggers
/// an event to load all bridge group data using the `IBridgeBloc` interface. The UI consists
/// of a `ListView` that shows each bridge group and a `Slider` to adjust the group member limit.
/// The `FloatingActionButton` refreshes the list based on the current slider value.
///
/// The `BlocBuilder` widget listens for state changes from the `IBridgeBloc` and updates the UI
/// accordingly. It displays a loading indicator when data is being fetched, shows the list of
/// bridge groups when data is loaded, or displays an error message or a placeholder when necessary.
class BridgeGroupListPage extends StatefulWidget {
  const BridgeGroupListPage({super.key});

  @override
  _BridgeGroupListPageState createState() => _BridgeGroupListPageState();
}

class _BridgeGroupListPageState extends State<BridgeGroupListPage> {
  int _selectedGroupMember = 1;

  @override
  void initState() {
    super.initState();
    IBridgeBloc ibloc = context.read<IBridgeBloc>();
    _selectedGroupMember = ibloc.getMinMaxGroupMemberLimit().maxValue;
    ibloc.add(LoadAllBridgeGroupData(groupMemberLimit: _selectedGroupMember));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridge Group List'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<IBridgeBloc, BridgeState>(
                builder: (context, state) {
                  if (state is BridgeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AllBridgeGroupDataLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.bridgeGroupList.length,
                      itemBuilder: (context, index) {
                        final group = state.bridgeGroupList[index];
                        return ListTile(
                          title: Text(group.title),
                          subtitle: Text(
                              'Number of Bridges: ${group.bridges.length}'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.singleBridgeGroup,
                              arguments:
                                  RoutePaths.buildSingleBridgeGroupPars(index),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is BridgeError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('No data available.'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final sliderWidth = constraints.maxWidth * 2 / 3;
                  IBridgeBloc bloc = context.read<IBridgeBloc>();
                  MinMaxSliderPair valuePair = bloc.getMinMaxGroupMemberLimit();
                  return Column(
                    children: [
                      SizedBox(
                        width: sliderWidth,
                        height: 10,
                        child: Slider(
                          value: _selectedGroupMember.toDouble(),
                          min: valuePair.minValue.toDouble(),
                          max: valuePair.maxValue.toDouble(),
                          divisions: valuePair.maxValue - valuePair.minValue,
                          label: _selectedGroupMember.toString(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGroupMember = value.toInt();
                              bloc.add(LoadAllBridgeGroupData(
                                  groupMemberLimit: _selectedGroupMember));
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<IBridgeBloc>().add(
              LoadAllBridgeGroupData(groupMemberLimit: _selectedGroupMember));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
