{ writeShellScriptBin, tofi-rbw-unwrapped, tofi, rbw }:

writeShellScriptBin "tofi-rbw" ''
  ${tofi-rbw-unwrapped}/bin/tofi-rbw --tofi ${tofi}/bin/tofi --rbw ${rbw}/bin/rbw "$@"
''
