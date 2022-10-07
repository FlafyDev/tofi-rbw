import 'package:args/args.dart';
import 'dart:io';

import 'package:tofi_rbw/rbw.dart';
import 'package:tofi_rbw/tofi.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption("rbw", help: "rbw executable path")
    ..addOption("tofi", help: "tofi executable path")
    ..addOption(
      "action",
      help:
          "Choose what to do after selecting a login name and user.\nIf not specified, tofi will ask for an action.",
      valueHelp: '"copy password" "copy username"',
    )
    ..addFlag("help", abbr: "h");

  final ArgResults argResults = parser.parse(arguments);

  if (argResults["help"]) {
    print(parser.usage);
    return;
  }

  final rbw = Rbw(executable: File(argResults["rbw"] ?? "rbw"));
  final tofi = Tofi(executable: File(argResults["tofi"] ?? "tofi"));

  if (!await rbw.isUnlocked()) {
    print("rbw is not unlocked.");
    exitCode = 1;
    return;
  }

  final logins = await rbw.getLogins();

  final loginName = await tofi.show(logins.keys.toList());
  if (loginName == null) {
    print("No login name was selected.");
    exitCode = 2;
    return;
  }

  final loginUser = await tofi.show(logins[loginName]!);
  if (loginUser == null) {
    print("No login user was selected.");
    exitCode = 3;
    return;
  }

  final String? action = (argResults["action"] as String?) ??
      await tofi.show(["copy password", "copy username"]);

  switch (action) {
    case "copy username":
      print(loginUser);
      break;
    case "copy password":
      print(await rbw.getPassword(loginName, loginUser));
      break;
    default:
      print("unknown action: $action");
      exitCode = 4;
      return;
  }

  exitCode = 0;
}
