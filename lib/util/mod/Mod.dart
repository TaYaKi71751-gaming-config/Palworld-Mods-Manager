import 'dart:io';

import 'package:path/path.dart' as p;

// https://chatgpt.com/share/67878d1e-1a64-8006-8569-f40f2ce01f15
// https://gist.github.com/Swader/5163867
void recursiveFolderCopySync(String source, String destination) {
  Directory sourceDir = Directory(source);
  if (!sourceDir.existsSync()) {
    throw Exception('Source directory "$source" does not exist, nothing to copy');
  }

  Directory destinationDir = Directory(destination);
  if (!destinationDir.existsSync()) {
    destinationDir.createSync(recursive: true);
  }

  for (var entity in sourceDir.listSync()) {
    if (true) {
      String newPath = p.join(destinationDir.path, p.basename(entity.path));
      if (entity is File) {
        entity.copySync(newPath);
      } else if (entity is Directory) {
        recursiveFolderCopySync(entity.path, newPath);
      } else {
        throw Exception('Unknown entity type: ${entity.runtimeType}');
      }
    }
  }
}

class Mod {
  String? path;
  Mod(String this.path);


  bool get status {
    if (Directory(this.path!).existsSync()) {
      if (this.path!.contains(Platform.pathSeparator + 'Disabled')) {
        return false;
      }
    }
    if (Directory(this.path!).existsSync()) {
      if (!this.path!.contains(Platform.pathSeparator + 'Disabled')) {
        return true;
      }
    }
    return false;
  }

  set status(bool stat) {
    String? from, to;
    if (stat == true) {
      from = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '').replaceAll(Directory.current.path,Directory.current.path + Platform.pathSeparator + 'Disabled');
      to = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '');
    } else if (stat == false) {
      to = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '').replaceAll(Directory.current.path,Directory.current.path + Platform.pathSeparator + 'Disabled');
      from = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '');
    }
				// print(this.path! + '\n' + from! + '\n' + to!);
					 List<String> _path = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '').replaceAll(Directory.current.path, Directory.current.path + Platform.pathSeparator + 'Disabled').split(Platform.pathSeparator);
						_path[_path.length - 1] = '';
					 Directory(_path.join(Platform.pathSeparator)).createSync(recursive: true);
						// print(this.path!.endsWith(from!));
      if (this.path == to) {
      } else if (this.path! == from!) {
				recursiveFolderCopySync(from!, to!);
				Directory(from!).deleteSync(recursive: true);
      }
  }

  get isMod {
    if (Directory(this.path!).existsSync()) {
						var disabledPath = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '').replaceAll(Directory.current.path, Directory.current.path + Platform.pathSeparator + 'Disabled');
            var dpath = disabledPath.split(Platform.pathSeparator);
            if(dpath[dpath.length - 2] == 'Mods') {
              return true;
            }
						var enabledPath = this.path!.replaceAll(Platform.pathSeparator + 'Disabled', '');
            dpath = enabledPath.split(Platform.pathSeparator);
            if(dpath[dpath.length - 2] == 'Mods') {
              return true;
            }
    }
    return false;
  }
}
