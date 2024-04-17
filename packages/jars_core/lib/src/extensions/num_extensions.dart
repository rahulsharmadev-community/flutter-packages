import 'dart:async';
import 'dart:math';
import '../utility/number_format/number_format.dart';

extension NnmExtensions on num {
  ///  ```
  /// void main() {
  ///   print(23.455.toRoundPrecision(1)); // Expected result: 23.5
  ///   print(-23.455.toRoundPrecision(1)); // Expected result: -23.5
  ///   print(23.3554.toRoundPrecision(0)); // Expected result: -23
  /// }
  /// ```
  num toRoundPrecision(int fractionDigits) {
    if (fractionDigits == 0) return round();
    var mod = pow(10, fractionDigits);
    return ((this * mod).round() / mod);
  }

  bool get isInfiniteOrNuN {
    if (this == 0) return false;
    var temp = log(abs()) / ln10;
    return temp.isNaN || temp.isInfinite;
  }

  /// Sample:
  /// ```
  /// void main(){
  ///   print(45125136.numberSimpleFormat);
  /// }
  /// ```
  /// ----------
  /// 451,251,365
  /// ----------
  String get numberSimpleFormat => NumberFormat.en().simple(this, trimZero: true);

  String get numberCompactFormat => NumberFormat.en().compact(this, trimZero: true, shortfrom: true);

  String get currencyCompactFormat =>
      NumberFormat.en().compact(this, trimZero: true, shortfrom: true, currencySymbol: true);

  /// Returns an iterable from [this] inclusive to [end] exclusive.
  ///
  /// Example:
  /// ```dart
  /// 3.to(6); // (3, 4, 5)
  /// 2.to(-2); // (2, 1, 0, -1)
  /// ```
  ///
  /// If [by] is provided, it will be used as step size for iteration. [by] is
  /// always positive, even if the direction of iteration is decreasing.
  ///
  /// Example:
  /// ```dart
  /// 8.to(3, by: 2); // (8, 6, 4)
  /// ```

  Iterable<num> to(num end, {num by = 1}) {
    if (by < 1) {
      throw ArgumentError('Invalid step size: $by. Step size must be greater than 0');
    }
    final count = ((end - this).abs() / by).ceil();
    // Explicit type declaration required for function argument.
    final num Function(num) generator =
        this >= end ? (index) => this - (by * index) : (index) => this + (by * index);
    return Iterable<num>.generate(count, generator);
  }

  /// Sample:
  /// ```
  /// void main() async {
  ///   print('+ wait for 2 seconds');
  ///   await 2.delay();
  ///   print('- 2 seconds completed');
  ///   print('+ callback in 1.2sec');
  ///   1.delay(() => print('- 1.2sec callback called'));
  ///   print('currently running callback 1.2sec');
  /// }
  ///```
  Future delay([FutureOr Function()? callback]) async => Future.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );

  // Duration get milliseconds => Duration(microseconds: (this * 1000).a round());

  Duration get seconds {
    if (!isFinite) throw FormatException("The number must be finite.");

    int x = floor();
    int y = ((this - x) * 1000).toInt();
    return Duration(seconds: x, milliseconds: y);
  }

  Duration get milliseconds {
    if (!isFinite) throw FormatException("The number must be finite.");

    int x = floor();
    int y = ((this - x) * 1000).toInt();
    return Duration(milliseconds: x, microseconds: y);
  }

  Duration get minutes {
    if (!isFinite) throw FormatException("The number must be finite.");

    int x = floor();
    int y = ((this - x) * 1000).toInt();
    return Duration(minutes: x, seconds: y);
  }

  Duration get hours {
    if (!isFinite) throw FormatException("The number must be finite.");

    int x = floor();
    int y = ((this - x) * 1000).toInt();
    return Duration(hours: x, minutes: y);
  }

  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());
}
