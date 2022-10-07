import 'dart:async';
import 'dart:io';

class Tofi {
  File executable;

  Tofi({required this.executable});

  Future<String?> show(List<String> choices) async {
    final process = await Process.start(executable.path, []);
    process.stdin.write(choices.join("\n"));
    await process.stdin.close();

    final choice = Completer<String?>(); 
    
    final List<int> bytes = <int>[];
    process.stdout.listen((data) {
      bytes.addAll(data);
    }, onDone: () {
      String str = String.fromCharCodes(bytes);

      if (str.isEmpty) {
        choice.complete(null);
        return;
      }

      choice.complete(str.substring(0, str.length - 1));
    }, onError: (err) {
      choice.complete(null);
    });

    return await choice.future;
  }
}
