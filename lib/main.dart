import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palworld_mods_manager/util/Find.dart';
import 'package:palworld_mods_manager/util/mod/ModList.dart';
import 'package:palworld_mods_manager/util/Process.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palworld Mods Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Palworld Mods Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _kill() async {
    await Task.kill('Palworld-Win64-Shipping.exe');
  }

  bool _moved_path_once = false;

  void _move_path() {
    if(_moved_path_once) return;
    List<File> files = Find.file('mods.txt');
    for(var file in files){
      if(file.path != ''){
        List<String> dpath = file.path.split(Platform.pathSeparator);
								dpath[dpath.length - 1] = '';
								dpath[dpath.length - 2] = '';
        Directory.current = dpath.join(Platform.pathSeparator);
      }
    }
    _moved_path_once = true;
  }

  @override
  Widget build(BuildContext context) {
    _move_path();
    print(Directory.current);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Column(
                    children: (ModList.all.map((mod) {
                  return Column(
                    children: [
                      Text(
                        mod.path!,
                        style: TextStyle(fontSize: 20),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            mod.status = !mod.status;
                          });
                        },
                        tooltip: mod.status ? 'Enabled' : 'Disabled',
                        child: Icon(mod.status ? Icons.check : Icons.close),
                      ),
                    ],
                  );
                })).toList()),
              ),
            );
          },
        ),
        floatingActionButton: Wrap(
          children: [
            FloatingActionButton(
              onPressed: _kill,
              tooltip: 'Kill',
              child: const Icon(Icons.close),
            ),
          ],
        ));
  }
}
