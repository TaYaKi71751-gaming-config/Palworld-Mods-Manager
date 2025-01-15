import 'dart:io';

class Task {
  static Future<void> kill(String process) async {
    if (Platform.isWindows) {
      Process.run('taskkill.exe', ['/F', '/IM', '$process']);
    } else if (Platform.isLinux || Platform.isMacOS) {
						List<String> pids = List.empty(growable: true);
					 ProcessResult _process = await Process.run("ps",["ax"]);
						List<String> processList = _process.stdout.split('\n');
						for(String p in processList){
							if(!p.contains(process)){
								continue;
							}
							List<String> col = p.split(' ');
							String pid = '';
							for(String c in col){
								if(c == ''){
									continue;
								}
								pids.add(c);
								break;
							}
						}
						for(String pid in pids){
							await Process.run('kill', ['-9', '$pid']);
						}
    }
  }
}
