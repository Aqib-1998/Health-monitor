import 'dart:convert';

class DeviceModel {
  String deviceId;
  String name;
  String devicePassword;
  DeviceModel({
    required this.deviceId,
    required this.name,
    required this.devicePassword,
  });

  DeviceModel copyWith({
    String? deviceId,
    String? name,
    String? devicePassword,
  }) {
    return DeviceModel(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      devicePassword: devicePassword ?? this.devicePassword,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'name': name,
      'devicePassword': devicePassword,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      deviceId: map['deviceId'] ?? '',
      name: map['name'] ?? '',
      devicePassword: map['devicePassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromJson(String source) =>
      DeviceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'DeviceModel(deviceId: $deviceId, name: $name, devicePassword: $devicePassword)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceModel &&
        other.deviceId == deviceId &&
        other.name == name &&
        other.devicePassword == devicePassword;
  }

  @override
  int get hashCode =>
      deviceId.hashCode ^ name.hashCode ^ devicePassword.hashCode;
}

DeviceModel device5 =
    DeviceModel(deviceId: "123", name: "device 5", devicePassword: "123");

DeviceModel device4 =
    DeviceModel(deviceId: "345", name: "device 4", devicePassword: "123");

DeviceModel device3 =
    DeviceModel(deviceId: "675", name: "device 3", devicePassword: "123");

DeviceModel device2 =
    DeviceModel(deviceId: "3451", name: "device 2", devicePassword: "123");

DeviceModel device1 =
    DeviceModel(deviceId: "1234", name: "device 1", devicePassword: "123");

List<DeviceModel> dummyDevices = [
  device1,
  device2,
  device3,
  device4,
  device5,
  device1,
  device2,
  device3,
  device4,
  device5,
];
