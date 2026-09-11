void main() {
  calculate();
}

void calculate() {
  // TASK 1
  print('task 1');
  for (int i = 1; i <= 10; i++) {
    for (int j = 1; j <= 10; j++) {
      print('$i * $j = ${i * j}');
    }
  }

  // TASK 2
  print('\n task 2');
  bool leapYear(int year) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return true;
    }
    return false;
  }

  int daysInMonth(int month, int year) {
    List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    if (month == 2 && leapYear(year)) {
      return 29;
    }

    return days[month - 1];
  }

  String nextDay(int day, int month, int year) {
    if (month < 1 || month > 12) {
      return 'invalid date';
    }

    int maxDay = daysInMonth(month, year);

    if (day < 1 || day > maxDay) {
      return 'invalid date';
    }

    day++;

    if (day > maxDay) {
      day = 1;
      month++;

      if (month > 12) {
        month = 1;
        year++;
      }
    }

    String dd = day < 10 ? '0$day' : '$day';
    String mm = month < 10 ? '0$month' : '$month';

    return '$dd.$mm.$year';
  }

  print('05.09.2026 -> ${nextDay(5, 9, 2026)}');
  print('28.02.2024 -> ${nextDay(28, 2, 2024)}');
  print('28.02.2026 -> ${nextDay(28, 2, 2026)}');
  print('29.02.2026 -> ${nextDay(29, 2, 2026)}');
  print('28.02.2100 -> ${nextDay(28, 2, 2100)}');
  print('28.02.2000 -> ${nextDay(28, 2, 2000)}');
  print('31.12.2025 -> ${nextDay(31, 12, 2025)}');

  // TASK 3
  print('\ntask 3');

  int countVowels(String text) {
    String vowels = 'aeiouAEIOU';
    int count = 0;

    for (int i = 0; i < text.length; i++) {
      if (vowels.contains(text[i])) {
        count++;
      }
    }

    return count;
  }

  String text = 'flutter mobile development';
  print('"$text" -> ${countVowels(text)}');

  // TASK 4
  print('\n task 4');

  void findMinMax(List<int> numbers) {
    int min = numbers[0];
    int max = numbers[0];

    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] < min) {
        min = numbers[i];
      }

      if (numbers[i] > max) {
        max = numbers[i];
      }
    }

    print('$numbers -> max: $max, min: $min');
  }

  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  List<int> numbers1 = [234, 34, 123, 44, 949, 112, 67];

  findMinMax(numbers);
  findMinMax(numbers1);

  // TASK 5
  print('\n task 5');

  bool isPrime(int number) {
    if (number < 2) {
      return false;
    }

    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) {
        return false;
      }
    }

    return true;
  }

  print('3 -> ${isPrime(3) ? 'простое число' : 'не простое число'}');
  print('6 -> ${isPrime(6) ? 'простое число' : 'не простое число'}');
}
