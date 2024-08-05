import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/bridge_group.dart';
import 'package:bridge_info/view/bride_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mock_bridge_bloc.dart';

void main() {
  group('BridgeDetailPage', () {
    late IBridgeBloc bridgeBloc;

    setUp(() {
      bridgeBloc = MockBridgeBloc();
      (bridgeBloc as MockBridgeBloc).mockBridgeGroupList = [
        BridgeGroup(
          areaCode: 0,
          bridges: [
            Bridge(
                longitudeStart: 0,
                latitudeStart: 0,
                longitudeEnd: 0,
                latitudeEnd: 0,
                structureType: "Solid"),
            Bridge(
                longitudeStart: 0,
                latitudeStart: 0,
                longitudeEnd: 0,
                latitudeEnd: 0,
                structureType: "Soft"),
          ],
          title: 'mockTitle00',
        ),
        BridgeGroup(
          areaCode: 0,
          bridges: [
            Bridge(
                longitudeStart: 0,
                latitudeStart: 0,
                longitudeEnd: 0,
                latitudeEnd: 0,
                structureType: "Diamon"),
            Bridge(
                longitudeStart: 0,
                latitudeStart: 0,
                longitudeEnd: 0,
                latitudeEnd: 0,
                structureType: "Silver"),
          ],
          title: 'mockTitle01',
        ),
      ];
    });

    tearDown(() {
      bridgeBloc.close();
    });

    Future<void> pumpBridgeDetailPage(
        WidgetTester tester, int groupIndex, int bridgeIndex) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bridgeBloc,
            child: BridgeDetailPage(
                selectedGroupIndex: groupIndex,
                selectedBridgeIndex: bridgeIndex),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    void verifyBridgeDetailDisplay(String expectedStructureType) {
      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.descendant(of: find.byType(ListView), matching: find.byType(Card)),
        findsNWidgets(7),
      );

      final lastCardFinder = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Card),
          )
          .last;

      final listTileFinder = find.descendant(
        of: lastCardFinder,
        matching: find.byType(ListTile),
      );
      expect(listTileFinder, findsOneWidget);

      final subtitleTextFinder = find.descendant(
        of: listTileFinder,
        matching: find.text(expectedStructureType),
      );
      expect(subtitleTextFinder, findsOneWidget);
    }

    testWidgets('Verify detail display - selectIndex: 0',
        (WidgetTester tester) async {
      await pumpBridgeDetailPage(tester, 0, 0);
      verifyBridgeDetailDisplay('Solid');
    });

    testWidgets('Verify detail display - selectIndex: 1',
        (WidgetTester tester) async {
      await pumpBridgeDetailPage(tester, 1, 1);
      verifyBridgeDetailDisplay('Silver');
    });
  });
}
