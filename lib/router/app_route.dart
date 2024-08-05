const String homePath = '/';
const String singleBridgeGroupPath = '/singleBridgeGroup';
const String bridgeDetailPath = '/bridgeDetail';

/// A utility class that defines the route paths and provides methods to build route parameters.
///
/// The `RoutePaths` class contains constants representing the paths for the different routes in the application,
/// including the home page, single bridge group page, and bridge detail page. It also provides methods for creating
/// instances of `SingleBridgeGroupPars` and `BridgeDetailPars`, which are used to pass data between routes.
class RoutePaths {
  static const home = homePath;
  static const singleBridgeGroup = singleBridgeGroupPath;
  static const bridgeDetail = bridgeDetailPath;

  /// Creates an instance of `SingleBridgeGroupPars` with the given index of the selected bridge group.
  ///
  /// This method is used to pass the index of the selected bridge group when navigating to the
  /// single bridge group page.
  static SingleBridgeGroupPars buildSingleBridgeGroupPars(
      int selectedBridgeGroupIndex) {
    return SingleBridgeGroupPars(
        selectedBridgeGroupIndex: selectedBridgeGroupIndex);
  }

  /// Creates an instance of `BridgeDetailPars` with the given indices of the selected bridge group and bridge.
  ///
  /// This method is used to pass the indices of the selected bridge group and bridge when navigating to the
  /// bridge detail page.
  static BridgeDetailPars buildBridgeDetailPars(
      int selectedBridgeGroupIndex, int selectedBridgeIndex) {
    return BridgeDetailPars(
        selectedBridgeGroupIndex: selectedBridgeGroupIndex,
        selectedBridgeIndex: selectedBridgeIndex);
  }
}

/// A data class that holds the index of the selected bridge group.
///
/// `SingleBridgeGroupPars` is used to pass data related to the selected bridge group
/// when navigating between routes.
class SingleBridgeGroupPars {
  final int selectedBridgeGroupIndex;
  SingleBridgeGroupPars({required this.selectedBridgeGroupIndex});
}

/// A data class that holds the indices of the selected bridge group and bridge.
///
/// `BridgeDetailPars` is used to pass data related to the selected bridge group and specific bridge
/// when navigating between routes.
class BridgeDetailPars {
  final int selectedBridgeGroupIndex;
  final int selectedBridgeIndex;

  BridgeDetailPars(
      {required this.selectedBridgeGroupIndex,
      required this.selectedBridgeIndex});
}
