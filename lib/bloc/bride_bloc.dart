import 'bride_data_fetcher.dart';
import 'dart:core';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/bridge_group.dart';
import 'package:bridge_info/model/foot_bridge.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// An abstract class defining the BLoC interface for managing bridge data.
///
/// This class serves as the base for any BLoC that manages bridge-related data and
/// state, including retrieving bridge groups and individual bridge details.
abstract class IBridgeBloc extends Bloc<BridgeEvent, BridgeState> {
  IBridgeBloc(super.initialState);

  /// Returns the minimum and maximum limits for group members.
  ///
  /// This method provides a [MinMaxSliderPair] that represents the range of values
  /// for group members.
  MinMaxSliderPair getMinMaxGroupMemberLimit();

  /// Retrieves a specific bridge group based on the provided index.
  ///
  /// [selectedBridgeGroupIndex] is the index of the bridge group to retrieve.
  /// Returns the [BridgeGroup] corresponding to the provided index.
  BridgeGroup getBridgeGroup(int selectedBridgeGroupIndex);

  /// Gets the details of a specific bridge within a given bridge group.
  ///
  /// [selectedBridgeGroupIndex] is the index of the bridge group containing the bridge.
  /// [selectedBridgeIndex] is the index of the bridge within the bridge group.
  /// Returns the [Bridge] object with the details of the specified bridge.
  Bridge getBridgeDetail(int selectedBridgeGroupIndex, int selectedBridgeIndex);

  /// Retrieves a list of all available bridge groups.
  ///
  /// This method returns a [List] of [BridgeGroup] objects representing all the bridge groups.
  List<BridgeGroup> getAllBridgeGroup();
}

class MinMaxSliderPair {
  final int minValue;
  final int maxValue;

  MinMaxSliderPair({required this.minValue, required this.maxValue});
}

@immutable
abstract class BridgeEvent extends Equatable {
  const BridgeEvent();
}

class LoadAllBridgeGroupData extends BridgeEvent {
  final int _groupMemberLimit;

  LoadAllBridgeGroupData({required int groupMemberLimit})
      : _groupMemberLimit = groupMemberLimit.clamp(1, 20);

  int get groupMemberLimit => _groupMemberLimit;

  @override
  List<Object> get props => [_groupMemberLimit];
}

class BridgeGroupMemberNumberChange extends BridgeEvent {
  final int numberOfMember;

  const BridgeGroupMemberNumberChange(this.numberOfMember);

  @override
  List<Object> get props => [numberOfMember];
}

@immutable
abstract class BridgeState extends Equatable {
  const BridgeState();
}

class BridgeInitial extends BridgeState {
  final int _groupMemberLimit;

  BridgeInitial({required int groupMemberLimit})
      : _groupMemberLimit = groupMemberLimit.clamp(
            BridgeBloc.minGroupMemberLimit, BridgeBloc.maxGroupMemberLimit);

  int get groupMemberLimit => _groupMemberLimit;

  @override
  List<Object> get props => [_groupMemberLimit];
}

class BridgeLoading extends BridgeState {
  @override
  List<Object> get props => [];
}

class AllBridgeGroupDataLoaded extends BridgeState {
  final List<BridgeGroup> bridgeGroupList;

  const AllBridgeGroupDataLoaded({
    required this.bridgeGroupList,
  });

  @override
  List<Object> get props => [bridgeGroupList];
}

class BridgeError extends BridgeState {
  final String message;

  const BridgeError(this.message);

  @override
  List<Object> get props => [message];
}

class BridgeBloc extends IBridgeBloc {
  static const int minGroupMemberLimit = 1;
  static const int maxGroupMemberLimit = 20;

  final _logger = Logger(printer: PrettyPrinter());
  List<BridgeGroup> _bridgeGroupList = [];
  final IBridgeDataFetcher _dataFetcher;

  BridgeBloc({required IBridgeDataFetcher dataFetcher})
      : _dataFetcher = dataFetcher,
        super(BridgeInitial(groupMemberLimit: 20)) {
    on<LoadAllBridgeGroupData>((event, emit) async {
      _logger.d("start loading");
      emit(BridgeLoading());
      try {
        final bridgeInfoFuture = _dataFetcher.getBridges();
        final footbridgesFuture = _dataFetcher.getFootbridges();
        final groupMemberLimit = event.groupMemberLimit;
        final results =
            await Future.wait([bridgeInfoFuture, footbridgesFuture]);

        final bridgeInfo = results[0] as List<Bridge>?;
        final footbridges = results[1] as List<Footbridge>?;

        if (bridgeInfo != null && footbridges != null) {
          List<Bridge> bridgeInFoot = [];
          for (var footbridge in footbridges) {
            for (var bridge in footbridge.bridges) {
              bridge.areaCode = footbridge.areaCode;
              bridgeInFoot.add(bridge);
            }
          }
          Map<int, List<Bridge>> groupBridge = {};
          for (var bridge in bridgeInFoot) {
            final key = bridge.areaCode;
            if (key != null) {
              groupBridge.putIfAbsent(key, () => []).add(bridge);
            }
          }
          for (var bridge in bridgeInfo) {
            final key = bridge.areaCode;
            if (key != null) {
              groupBridge.putIfAbsent(key, () => []).add(bridge);
            }
          }
          List<BridgeGroup> bridgeGroupList = [];
          for (var entry in groupBridge.entries) {
            int areaCode = entry.key;
            List<Bridge> bridgeList = entry.value;
            int groupNumber = (bridgeList.length / groupMemberLimit).ceil();
            for (int i = 0; i < groupNumber; i++) {
              int startIndex = i * groupMemberLimit;
              int endIndex = (startIndex + groupMemberLimit < bridgeList.length)
                  ? startIndex + groupMemberLimit
                  : bridgeList.length;
              List<Bridge> groupedBridgeList =
                  bridgeList.sublist(startIndex, endIndex);
              String title = "$areaCode";
              if (i > 0) {
                title = "$title(${i + 1})";
              }
              BridgeGroup group = BridgeGroup(
                areaCode: areaCode,
                bridges: groupedBridgeList,
                title: title,
              );
              bridgeGroupList.add(group);
            }
          }
          _logger.d("groupMemberLimit: $groupMemberLimit");
          _bridgeGroupList = bridgeGroupList;
          emit(AllBridgeGroupDataLoaded(bridgeGroupList: bridgeGroupList));
        } else {
          emit(const BridgeError("Failed to load data"));
        }
      } catch (e) {
        _logger.e("Error occurred while loading data: $e");
        emit(const BridgeError("Error occurred while loading data"));
      }
    });
  }

  @override
  MinMaxSliderPair getMinMaxGroupMemberLimit() {
    return MinMaxSliderPair(
        minValue: minGroupMemberLimit, maxValue: maxGroupMemberLimit);
  }

  @override
  BridgeGroup getBridgeGroup(int selectedBridgeGroupIndex) {
    if (_bridgeGroupList.isEmpty ||
        _bridgeGroupList.length <= selectedBridgeGroupIndex ||
        selectedBridgeGroupIndex < 0) {
      return BridgeGroup.empty();
    }
    return _bridgeGroupList[selectedBridgeGroupIndex];
  }

  @override
  List<BridgeGroup> getAllBridgeGroup() {
    return _bridgeGroupList;
  }

  @override
  Bridge getBridgeDetail(
      int selectedBridgeGroupIndex, int selectedBridgeIndex) {
    BridgeGroup group = getBridgeGroup(selectedBridgeGroupIndex);
    if (group.bridges.isEmpty ||
        group.bridges.length <= selectedBridgeIndex ||
        selectedBridgeIndex < 0) {
      return Bridge.empty();
    }
    return group.bridges[selectedBridgeIndex];
  }
}
