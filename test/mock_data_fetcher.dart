import 'package:bridge_info/bloc/bride_data_fetcher.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/foot_bridge.dart';

class MockDataFetcher implements IBridgeDataFetcher {
  List<Footbridge> mockFoorBridgeList = [];
  List<Bridge> mockBridgeList = [];

  @override
  Future<List<Footbridge>?> getFootbridges() async {
    return mockFoorBridgeList;
  }

  @override
  Future<List<Bridge>?> getBridges() async {
    return mockBridgeList;
  }

  Future<int> bridgeNumberByAreaCode(int areaCode) async {
    int count = 0;
    List<Footbridge>? footBridges = await getFootbridges();
    for (int i = 0; i < footBridges!.length; i++) {
      if (footBridges[i].areaCode == areaCode) {
        count += footBridges[i].bridges.length;
      }
    }
    List<Bridge>? bridges = await getBridges();
    for (int i = 0; i < bridges!.length; i++) {
      if (bridges[i].areaCode == areaCode) {
        count += 1;
      }
    }
    return count;
  }
}
