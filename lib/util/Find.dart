// https://stackoverflow.com/questions/66532037/any-way-to-list-physical-disk-on-windows-with-flutter-dart
import 'dart:convert';
import 'dart:io';

//Future<void> main() async {
//  (await WindowsDrive.getDrives()).forEach(print);
// C:
// E:
// F:
// G:
// Z:
//}

class WindowsDrive {
  final String driveLetter;
  final int? freeSpace;

  const WindowsDrive(this.driveLetter, this.freeSpace);

  // Node,Caption,FreeSpace
  factory WindowsDrive.parse(String line) {
    final segments = line.split(',');
    return WindowsDrive(segments[1], int.tryParse(segments[2]));
  }

  @override
  String toString() => '$driveLetter';

  static Iterable<WindowsDrive> getDrives() =>
      LineSplitter.split((Process.runSync(
                  'wmic',
                  [
                    'logicaldisk',
                    'get',
                    'caption',
                    ',',
                    'freespace',
                    '/format:csv'
                  ],
                  stdoutEncoding: const SystemEncoding()))
              .stdout as String)
          .map((string) => string.trim())
          .where((string) => string.isNotEmpty)
          .skip(1)
          .map((e) => WindowsDrive.parse(e));
}

class Find {
  static List<File> file(String filename) {
    List<File> list = List.empty(growable: true);
    if (Platform.isWindows) {
      List<String> drives =
          (WindowsDrive.getDrives()).toString().replaceAll(RegExp("[^A-Za-z]"),"").split('\n');
      for (String drive in drives) {
        for (String line in (Process.runSync('cmd.exe', ['/c', 'where /r $drive:\\ $filename'],
                    stdoutEncoding: const SystemEncoding())
                .stdout as String)
            .split('\n')) {
          if (line.length == 0) {
            continue;
          }
          list.add(File(line));
        }
      }
      return list;
    } else if (Platform.isLinux || Platform.isMacOS) {
      for (String line in (((Process.runSync(
                  'bash', ['-c', 'find \$HOME -name $filename'],
                  stderrEncoding: const SystemEncoding()))
              .stdout as String)
          .split('\n'))) {
        if (line.length == 0) {
          continue;
        }
        list.add(File(line));
      }
      return list;
    }
    throw Error();
  }
}
