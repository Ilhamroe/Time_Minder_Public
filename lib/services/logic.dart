// import 'dart:io';

// void main() {
//   stdout.write('Masukkan waktu fokus dalam menit: ');
//   int inTimeMinutes = int.parse(stdin.readLineSync()!);

//   stdout.write('Masukkan waktu istirahat dalam menit: ');
//   int inRestMinutes = int.parse(stdin.readLineSync()!);

//   stdout.write('Masukkan jumlah interval: ');
//   int interval = int.parse(stdin.readLineSync()!);

//   int inTimeSeconds = inTimeMinutes * 60;
//   int inRestSeconds = inRestMinutes * 60;

//   int focusTime = inTimeSeconds ~/ (interval + 1);
//   int restTime = inRestSeconds;

//   for (int i = 0; i < interval; i++) {
//     print(('Waktu fokus ke-${i + 1} : ${formatTime(focusTime)}'));
//     print(('Waktu istirahat ke-${i + 1} : ${formatTime(restTime)}'));
//   }

//   print(('Waktu fokus ke-${interval + 1} : ${formatTime(focusTime)}'));
// }

// void printModeStatus(
//     Map<String, int> modeMap, String modeKey, String modeText, String color) {
//   if (modeMap.containsKey(modeKey)) {
//     print('${modeText} : ${formatTime(modeMap[modeKey]!)}');
//     print('Mode: ${color == 'green' ? 'Waktu Fokus' : 'Waktu Istirahat'}');
//   } else {
//     print('Mode tidak ditemukan');
//   }
// }

// String formatTime(int seconds) {
//   int minutes = seconds ~/ 60;
//   int remainingSeconds = seconds % 60;
//   return '$minutes menit $remainingSeconds detik';
// }
