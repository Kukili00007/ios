void main() {
  String name = 'Kuka';
  double balance = 5000.0;

  print('Банкомат');
  checkBalance(name: name, balance: balance);

  print('\nПополнение');
  balance = deposit(currentBalance: balance, amount: 1500.0);
  checkBalance(name: name, balance: balance);

  print('\nСнятие денег');
  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 2000.0,
    pinCode: 1234,
  );
  checkBalance(name: name, balance: balance);

  print('\nНеверный PIN');
  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 100.0,
    pinCode: null,
  );

  print('\nНедостаточно денег');
  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 10000.0,
    pinCode: 1234,
  );
}

// Arrow function =>
void checkBalance({required String name, required double balance}) =>
    print('$name, ваш доступный баланс: $balance тг.');

double deposit({required double currentBalance, double? amount}) {
  double depositAmount = amount ?? 0.0;

  if (depositAmount <= 0) {
    print('Ошибка: сумма пополнения должна быть больше 0.');
    return currentBalance;
  }

  double newBalance = currentBalance + depositAmount;
  print('Пополнение: +$depositAmount тг. Новый баланс: $newBalance тг.');
  return newBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  const int correctPin = 1234;
  int enteredPin = pinCode ?? 0000;
  double withdrawAmount = amount ?? 0.0;

  if (enteredPin != correctPin) {
    print('$name, ошибка: неверный PIN-код. Операция отменена.');
    return currentBalance;
  }

  if (withdrawAmount <= 0) {
    print('Ошибка: сумма снятия должна быть больше 0.');
    return currentBalance;
  }

  if (withdrawAmount > currentBalance) {
    print('$name, недостаточно средств. Операция отменена.');
    return currentBalance;
  }

  double newBalance = currentBalance - withdrawAmount;
  print('Вы сняли: $withdrawAmount тг. Новый баланс: $newBalance тг.');
  return newBalance;
}
