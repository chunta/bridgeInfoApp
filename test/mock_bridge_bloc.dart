import 'package:bridge_info/bloc/bride_bloc.dart';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/bridge_group.dart';

class MockBridgeBloc extends IBridgeBloc {
  bool directLoaded = false;

  List<BridgeGroup> mockBridgeGroupList = [];

  MockBridgeBloc() : super(BridgeInitial(groupMemberLimit: 20)) {
    on<LoadAllBridgeGroupData>((event, emit) async {
      if (directLoaded) {
        emit(AllBridgeGroupDataLoaded(bridgeGroupList: mockBridgeGroupList));
      } else {
        emit(BridgeLoading());
      }
    });
  }

  @override
  List<BridgeGroup> getAllBridgeGroup() {
    return [];
  }

  @override
  Bridge getBridgeDetail(
      int selectedBridgeGroupIndex, int selectedBridgeIndex) {
    if (mockBridgeGroupList.isNotEmpty) {
      BridgeGroup bridgeGroup = mockBridgeGroupList[selectedBridgeGroupIndex];
      if (bridgeGroup.bridges.length > selectedBridgeIndex) {
        return bridgeGroup.bridges[selectedBridgeIndex];
      }
    }
    return Bridge.empty();
  }

  @override
  BridgeGroup getBridgeGroup(int selectedBridgeGroupIndex) {
    if (mockBridgeGroupList.isNotEmpty &&
        mockBridgeGroupList.length > selectedBridgeGroupIndex) {
      return mockBridgeGroupList[selectedBridgeGroupIndex];
    }
    return BridgeGroup.empty();
  }

  @override
  MinMaxSliderPair getMinMaxGroupMemberLimit() {
    return MinMaxSliderPair(minValue: 1, maxValue: 10);
  }
}
