const energileddDag = 0.403;
const energileddNatt = 0.3068;
final validUntil = DateTime(2023, 12, 31);
const stromStotteLimit = 0.875;

class Strompris {
  final double nokPerKwh;
  final double eurPerKwh;
  final double exr;
  final DateTime timeStart;
  final DateTime timeEnd;

  const Strompris({
    required this.nokPerKwh,
    required this.eurPerKwh,
    required this.exr,
    required this.timeStart,
    required this.timeEnd,
  });

  factory Strompris.fromJson(Map<String, dynamic> json) {
    return Strompris(
      nokPerKwh: json['NOK_per_kWh'] as double,
      eurPerKwh: json['EUR_per_kWh'] as double,
      exr: json['EXR'] as double,
      timeStart: DateTime.parse(json['time_start']),
      timeEnd: DateTime.parse(json['time_end']),
    );
  }
}

class Strompriser {
  final List<Strompris> strompriser;

  const Strompriser({required this.strompriser});

  Strompris get current => strompriser
      .where((element) =>
          element.timeStart.isBefore(DateTime.now()) &&
          element.timeEnd.isAfter(DateTime.now()))
      .first;

  double get nokPerKwh => current.nokPerKwh;

  double get mva => (nokPerKwh * 0.25);

  double get stromStotte {
    if (nokPerKwh + mva > stromStotteLimit) {
      return (nokPerKwh + mva - stromStotteLimit) * 0.9;
    }
    return 0;
  }

  double get price {
    final now = DateTime.now();
    final nettleie =
        (now.hour >= 6 && now.hour <= 22) ? energileddDag : energileddNatt;
    return (nokPerKwh + mva - stromStotte + nettleie);
  }
}
