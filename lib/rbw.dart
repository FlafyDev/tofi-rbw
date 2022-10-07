import 'dart:io';

class RbwLogin {
  String name;
  List<String> users;

  RbwLogin({
    required this.name,
    required this.users,
  });
}

class Rbw {
  File executable;

  Rbw({required this.executable});

  Future<bool> isUnlocked() async {
    return await Process.run(executable.path, ["unlocked"]).then(
      (res) => res.exitCode == 0,
    );
  }

  Future<Map<String, List<String>>> getLogins() async {
    final logins = <String, List<String>>{};

    await Process.run(
      executable.path,
      ["list", "--fields", "name", "user"],
    ).then((res) => res.stdout.toString().split("\n").forEach((line) {
          final split = line.split("\t");
          if (split.length != 2) {
            return;
          }
          if (!logins.keys.contains(split[0])) {
            logins[split[0]] = [];
          }
          logins[split[0]]!.add(split[1]);
        }));

    return logins;
  }

  Future<String?> getPassword(String name, String user) async {
    return await Process.run(executable.path, ["get", name, user]).then(
      (res) {
        if (res.exitCode == 0) {
          String pass = res.stdout.toString();
          return pass.substring(0, pass.length - 1);
        } else {
          return null;
        }
      },
    );
  }
}
