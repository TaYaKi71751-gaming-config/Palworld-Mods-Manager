import 'dart:io';

import 'package:palworld_mods_manager/util/mod/Mod.dart';

class ModList {
  static List<Mod> get all {
    List<Mod> rtn = List.empty(growable: true);
    for (FileSystemEntity entity in Directory.current.listSync()) {
      try {
        if (Directory(entity.path).existsSync()) {
          for(FileSystemEntity entity2 in Directory(entity.path).listSync()){
            if(Directory(entity2.path).existsSync()){
              var m = Mod(entity2.path);
              if (m.isMod == true) {
                rtn.add(m);
              }
            }
          }
        }
      } catch (e) {}
      List<String> dpath = entity.path.split(Platform.pathSeparator);
      dpath = (dpath
              .join(Platform.pathSeparator)
              .replaceAll(Platform.pathSeparator + 'Disabled', '')
              .replaceAll(Directory.current.path,
                  Directory.current.path + Platform.pathSeparator + 'Disabled'))
          .split(Platform.pathSeparator);
      // print(dpath.join(Platform.pathSeparator));

      try {
        if (Directory(dpath.join(Platform.pathSeparator)).existsSync()) {
          for (FileSystemEntity entity2 in Directory(dpath.join(Platform.pathSeparator)).listSync()){
            var m = Mod(entity2.path);
            if (m.isMod == true) {
              print(m.path);
              rtn.add(m);
            }
          }
          var m = Mod(dpath.join(Platform.pathSeparator));
          if (m.isMod == true) {
            rtn.add(m);
          }
        }
      } catch (e) {}
    }
    return rtn;
  }
}
