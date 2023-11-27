import 'dart:math';

String generateRandomCode(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String code = '';

  for (int i = 0; i < length; i++) {
    int index = random.nextInt(characters.length);
    code += characters[index];
  }

  return code;
}
