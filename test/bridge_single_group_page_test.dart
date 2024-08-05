import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/bridge_group.dart';
import 'package:bridge_info/view/bride_single_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mock_bridge_bloc.dart';

void main() {
  group('BrideSingleGroupPage', () {
    late IBridgeBloc bridgeBloc;

    setUp(() {
      bridgeBloc = MockBridgeBloc();
    });

    tearDown(() {
      bridgeBloc.close();
    });

    Future<void> testBridgeCount(
        WidgetTester tester, int selectedIndex, int expectedCount) async {
      (bridgeBloc as MockBridgeBloc).mockBridgeGroupList = [
        BridgeGroup(
          areaCode: 0,
          bridges: List.generate(
            3,
            (i) => Bridge(
              longitudeStart: 0,
              latitudeStart: 0,
              longitudeEnd: 0,
              latitudeEnd: 0,
            ),
          ),
          title: 'mockTitle00',
        ),
        BridgeGroup(
          areaCode: 0,
          bridges: List.generate(
            2,
            (i) => Bridge(
              longitudeStart: 0,
              latitudeStart: 0,
              longitudeEnd: 0,
              latitudeEnd: 0,
            ),
          ),
          title: 'mockTitle01',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bridgeBloc,
            child: BrideSingleGroupPage(selectedGroupIndex: selectedIndex),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.descendant(of: find.byType(ListView), matching: find.byType(Card)),
        findsNWidgets(expectedCount),
      );
    }

    testWidgets('Verify number of bridges - index 0',
        (WidgetTester tester) async {
      await testBridgeCount(tester, 0, 3);
    });

    testWidgets('Verify number of bridges - index 1',
        (WidgetTester tester) async {
      await testBridgeCount(tester, 1, 2);
    });
  });
}
