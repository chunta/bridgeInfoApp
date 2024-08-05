/// Represents a bridge with various geographical and structural attributes.
///
/// The `Bridge` class models a bridge with properties such as geographical coordinates,
/// area code, and structure type. It includes functionalities for creating instances
/// from JSON data and converting instances to JSON format.
///
/// Instances can be created with specific values for each property or using a default
/// set of values provided by the class.
class Bridge {
  int? areaCode;
  final double longitudeStart;
  final double latitudeStart;
  final double longitudeEnd;
  final double latitudeEnd;
  final String? structureType;

  Bridge({
    this.areaCode,
    required this.longitudeStart,
    required this.latitudeStart,
    required this.longitudeEnd,
    required this.latitudeEnd,
    this.structureType,
  });

  static Bridge empty() {
    return Bridge(
      areaCode: 0,
      latitudeStart: 0,
      longitudeStart: 0,
      latitudeEnd: 0,
      longitudeEnd: 0,
      structureType: '',
    );
  }

  // Factory method to create a Bridge instance from JSON
  factory Bridge.fromJson(Map<String, dynamic> json) {
    return Bridge(
      areaCode: json['areacode'],
      longitudeStart: json['longitudestart'],
      latitudeStart: json['latitudestart'],
      longitudeEnd: json['longitudeend'],
      latitudeEnd: json['latitudeend'],
      structureType: json['structuretype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitudeStart': longitudeStart,
      'latitudeStart': latitudeStart,
      'longitudeEnd': longitudeEnd,
      'latitudeEnd': latitudeEnd,
      'structureType': structureType,
    };
  }
}
