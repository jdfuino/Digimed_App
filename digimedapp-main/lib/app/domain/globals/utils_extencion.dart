extension Regex on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPhoneNumber() {
    return RegExp(r'^\+\d{1,3}(?!0)\d+$').hasMatch(this);
  }

  bool isValidIdNumber() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }

  bool isValidWeightNumber() {
    return RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(this);
  }

  bool isValidIdentificationNumber() {
    return RegExp(r'^(V|v|E|e)\d{5,9}$').hasMatch(this);
  }

  bool isWeightInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 635.0;
  }

  bool isHeightInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 3.0;
  }

  bool isSystolicInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 250;
  }

  bool isDiastolicInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 140;
  }

  bool isHeartRateInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 250;
  }

  bool isGlucoseInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 300;
  }

  bool isTriglyceridesInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 500;
  }

  bool isCholesterolInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 300;
  }

  bool isHemoglobinInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 30;
  }

  bool isSleepInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 24;
  }

  bool isUricAcidInValidRange() {
    double? number = double.tryParse(this);
    return number != null && number >= 0.0 && number <= 20;
  }
}

// extension FullNameValidator on String {
//   bool isValidFullName() {
//     return RegExp(^[AZ]'?[- a-zA-Z]( [a-zA-Z])*$)
//         .hasMatch(this);
//   }
// }

extension VerificarEdad on DateTime {
  bool isLegalAge() {
    return DateTime.now().difference(this).inDays >= 18 * 365.25;
  }
}
