import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge_group.dart';
import 'package:bridge_info/view/bridge_group_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mock_bridge_bloc.dart';

void main() {
  group('BridgeGroupListPage', () {
    late IBridgeBloc bridgeBloc;

    setUp(() {
      bridgeBloc = MockBridgeBloc();
    });

    tearDown(() {
      bridgeBloc.close();
    });

    testWidgets('Verify displays initial state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bridgeBloc,
            child: const BridgeGroupListPage(),
          ),
        ),
      );
      expect(find.text('No data available.'), findsOneWidget);
    });

    testWidgets('Verify displays loading state', (WidgetTester tester) async {
      bridgeBloc.add(LoadAllBridgeGroupData(groupMemberLimit: 10));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bridgeBloc,
            child: const BridgeGroupListPage(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'Verify ListView is displayed with the correct bridge group data',
        (WidgetTester tester) async {
      const String mockTitle = "mockTitle";
      (bridgeBloc as MockBridgeBloc).directLoaded = true;
      (bridgeBloc as MockBridgeBloc).mockBridgeGroupList = [
        BridgeGroup(areaCode: 0, bridges: [], title: mockTitle)
      ];
      bridgeBloc.add(LoadAllBridgeGroupData(groupMemberLimit: 10));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bridgeBloc,
            child: const BridgeGroupListPage(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ListView), findsOneWidget);

      final listTileFinder = find.byType(ListTile);
      expect(listTileFinder, findsOneWidget);

      final titleFinder = find.descendant(
        of: listTileFinder,
        matching: find.text(mockTitle),
      );
      expect(titleFinder, findsOneWidget);
    });
  });
}
