import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const prefix = '+90 ';

    // Sadece rakamları al
    String numbers = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Eğer başında 90 varsa kaldır
    if (numbers.startsWith('90')) {
      numbers = numbers.substring(2);
    }

    // Maksimum 10 rakam
    if (numbers.length > 10) {
      numbers = numbers.substring(0, 10);
    }

    // Boş kontrolü - önemli değişiklik burada
    if (numbers.isEmpty || newValue.text.length <= prefix.length) {
      return const TextEditingValue(
        text: '+90 ',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // Telefon numarasını formatla
    String formatted = prefix;

    // 5xx
    formatted += numbers.substring(0, numbers.length.clamp(0, 3));
    if (numbers.length > 3) formatted += ' ';

    // xxx
    if (numbers.length > 3) {
      formatted += numbers.substring(3, numbers.length.clamp(3, 6));
      if (numbers.length > 6) formatted += ' ';
    }

    // xx
    if (numbers.length > 6) {
      formatted += numbers.substring(6, numbers.length.clamp(6, 8));
      if (numbers.length > 8) formatted += ' ';
    }

    // xx
    if (numbers.length > 8) {
      formatted += numbers.substring(8, 10);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
