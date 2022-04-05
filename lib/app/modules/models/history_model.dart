import 'dart:convert';

class History {
  String temperature;
  String spo2;
  String bpm;
  DateTime dateTime;
  String id;
  History({
    required this.temperature,
    required this.spo2,
    required this.bpm,
    required this.dateTime,
    required this.id,
  });

  History copyWith({
    String? temperature,
    String? spo2,
    String? bpm,
    DateTime? dateTime,
    String? id,
  }) {
    return History(
      temperature: temperature ?? this.temperature,
      spo2: spo2 ?? this.spo2,
      bpm: bpm ?? this.bpm,
      dateTime: dateTime ?? this.dateTime,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'spo2': spo2,
      'bpm': bpm,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      temperature: map['temperature'] ?? '-',
      spo2: map['spo2'] ?? '-',
      bpm: map['bpm'] ?? '-',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      id: map['id'] ?? '-',
    );
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source));

  @override
  String toString() {
    return 'History(temperature: $temperature, spo2: $spo2, bpm: $bpm, dateTime: $dateTime, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is History &&
        other.temperature == temperature &&
        other.spo2 == spo2 &&
        other.bpm == bpm &&
        other.dateTime == dateTime &&
        other.id == id;
  }

  @override
  int get hashCode {
    return temperature.hashCode ^
        spo2.hashCode ^
        bpm.hashCode ^
        dateTime.hashCode ^
        id.hashCode;
  }
}

History history1 = History(
    temperature: "28 c",
    spo2: "97%",
    bpm: "70 BPM",
    dateTime: DateTime.now(),
    id: "123");
History history2 = History(
    temperature: "18 c",
    spo2: "17%",
    bpm: "70 BPM",
    dateTime: DateTime.now(),
    id: "213");

List<History> dummyHistory = [
  history1,
  history2,
  history1,
  history2,
  history1,
  history2,
  history1,
  history2,
  history1,
  history2,
  history1,
  history2,
  history1,
  history2
];
