import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'zaposlen.g.dart';

@HiveType(typeId: 0)
class Zaposlen {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String surname;

  @HiveField(2)
  final String position;

  @HiveField(3)
  final DateTime birthDate;

  @HiveField(4)
  final TimeOfDay arrivalTime;

  @HiveField(5)
  final TimeOfDay departureTime;

  Zaposlen({
    required this.name,
    required this.surname,
    required this.position,
    required this.birthDate,
    required this.arrivalTime,
    required this.departureTime,
  });
}
