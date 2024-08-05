import 'package:bridge_info/model/bridge.dart';

/// Represents a footbridge, which includes an ID, an area code, and a list of bridges.
///
/// The `Footbridge` class encapsulates information about a footbridge, including
/// its identifier, associated area code, and a collection of `Bridge` instances
/// that are part of the footbridge. It provides functionality to create an instance
/// from JSON data and convert an instance to JSON format.
///
/// This class supports the initialization of its properties from a JSON map and
/// offers a method to serialize its data for use in network communication or storage.
class Footbridge {
  final int id;
  final int areaCode;
  final List<Bridge> bridges;

  Footbridge({required this.id, required this.areaCode, required this.bridges});

  // Factory method to create a Footbridge instance from JSON
  factory Footbridge.fromJson(Map<String, dynamic> json) {
    return Footbridge(
      id: json['id'],
      areaCode: json['areacode'],
      bridges: (json['bridges'] as List<dynamic>)
          .map((bridge) => Bridge.fromJson(bridge as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert Footbridge instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'areaCode': areaCode,
      'bridges': bridges.map((bridge) => bridge.toJson()).toList(),
    };
  }
}
