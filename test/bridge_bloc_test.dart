import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/bridge_group.dart';
import 'package:bridge_info/model/foot_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'mock_data_fetcher.dart';

void main() {
  group('BridgeBloc With Max Group Memeber', () {
    late MockDataFetcher dataFetcher;
    late BridgeBloc bloc;

    blocTest<BridgeBloc, BridgeState>(
      'Verify bloc state',
      setUp: () {
        dataFetcher = MockDataFetcher();
        dataFetcher.mockBridgeList = genBridgeList();
        dataFetcher.mockFoorBridgeList = genFootBridgeList();
        bloc = BridgeBloc(dataFetcher: dataFetcher);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
        LoadAllBridgeGroupData(
          groupMemberLimit: bloc.getMinMaxGroupMemberLimit().maxValue,
        ),
      ),
      expect: () => [
        BridgeLoading(),
        AllBridgeGroupDataLoaded(bridgeGroupList: bloc.getAllBridgeGroup()),
      ],
    );

    test("Verify non-zero bridges in the first group", () async {
      final BridgeGroup group00 = bloc.getBridgeGroup(0);
      expect(group00.bridges.length, greaterThan(0));
      expect(group00.bridges.length,
          lessThanOrEqualTo(bloc.getMinMaxGroupMemberLimit().maxValue));
    });

    test("Verify correct number of bridges for area code 60010", () async {
      int groupCount = 0;
      int areaCode = 60010;
      List<BridgeGroup> bridgeGroups = bloc.getAllBridgeGroup();
      for (int i = 0; i < bridgeGroups.length; i++) {
        if (bridgeGroups[i].areaCode == areaCode) {
          groupCount += bridgeGroups[i].bridges.length;
        }
      }
      int expectedCount = await dataFetcher.bridgeNumberByAreaCode(areaCode);
      expect(groupCount, expectedCount);
    });
  });

  group('BridgeBloc With Group Memeber Limit - 2', () {
    const int limit = 2;
    late BridgeBloc bloc;
    late MockDataFetcher dataFetcher;

    blocTest<BridgeBloc, BridgeState>(
      'Verify bloc state',
      setUp: () {
        dataFetcher = MockDataFetcher();
        dataFetcher.mockBridgeList = genBridgeList();
        dataFetcher.mockFoorBridgeList = genFootBridgeList();
        bloc = BridgeBloc(dataFetcher: dataFetcher);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
        LoadAllBridgeGroupData(
          groupMemberLimit: limit,
        ),
      ),
      expect: () => [
        BridgeLoading(),
        AllBridgeGroupDataLoaded(bridgeGroupList: bloc.getAllBridgeGroup()),
      ],
    );

    test("Returns non-zero bridges in the first group2", () async {
      final BridgeGroup group00 = bloc.getBridgeGroup(0);
      expect(group00.bridges.length, greaterThan(0));
      expect(group00.bridges.length, lessThanOrEqualTo(limit));
    });

    test("Verify number of group division2", () async {
      final List<BridgeGroup> bridgeGroups = bloc.getAllBridgeGroup();
      for (int i = 0; i < bridgeGroups.length; i++) {
        expect(bridgeGroups[i].bridges.length, lessThanOrEqualTo(limit));
      }
    });

    test("Verify group division and count for areaCode 600102", () async {
      int areaCode = 60010;
      int expectedCount = await dataFetcher.bridgeNumberByAreaCode(areaCode);
      int left = expectedCount % limit;
      final List<BridgeGroup> bridgeGroups = bloc.getAllBridgeGroup();
      int verifyLeftCount = 0;
      int verifyNumberOfGroupWithLimit = 0;
      int expectNumberOfGroupWithLimit = expectedCount ~/ limit;
      for (final group in bridgeGroups) {
        if (group.areaCode == areaCode) {
          if (group.bridges.length == left && left != 0) {
            verifyLeftCount++;
          } else if (group.bridges.length == limit) {
            verifyNumberOfGroupWithLimit++;
          }
        }
      }
      if (left != 0) {
        expect(verifyLeftCount, 1,
            reason:
                "Expected one group with leftover bridges matching the remainder.");
      }
      expect(verifyNumberOfGroupWithLimit, expectNumberOfGroupWithLimit,
          reason: "Expected number of full groups does not match.");
    });
  });
}

List<Bridge> genBridgeList() {
  return [
    Bridge(
        areaCode: 60010,
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "SRC"),
    Bridge(
        areaCode: 60010,
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "RC"),
    Bridge(
        areaCode: 60020,
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "RC"),
    Bridge(
        areaCode: 60030,
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "RC")
  ];
}

List<Footbridge> genFootBridgeList() {
  Footbridge footbridge01 = Footbridge(id: 0, areaCode: 60010, bridges: [
    Bridge(
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "SRC"),
    Bridge(
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "RC"),
    Bridge(
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "RC")
  ]);
  Footbridge footbridge02 = Footbridge(id: 1, areaCode: 60020, bridges: [
    Bridge(
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "SRC"),
    Bridge(
        longitudeStart: 0,
        latitudeStart: 0,
        longitudeEnd: 0,
        latitudeEnd: 0,
        structureType: "RC")
  ]);
  return [footbridge01, footbridge02];
}
