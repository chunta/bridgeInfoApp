import 'package:bridge_info/model/bridge.dart';

/// Represents a group of bridges with a title and an area code.
///
/// The `BridgeGroup` class models a collection of `Bridge` instances, associated
/// with a specific area code and a title. It is used to organize and categorize
/// groups of bridges under a common title and area code.
///
/// This class includes a factory method to create an empty instance of `BridgeGroup`
/// with default values, providing a way to initialize a `BridgeGroup` when no
/// specific data is available or when a placeholder is needed.
class BridgeGroup {
  final int areaCode;
  final List<Bridge> bridges;
  final String title;
  BridgeGroup(
      {required this.areaCode, required this.bridges, required this.title});

  static BridgeGroup empty() {
    return BridgeGroup(
      areaCode: 0,
      bridges: [],
      title: '',
    );
  }
}
