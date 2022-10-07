{ lib, stdenv, fetchFromGitHub, buildDartPackage, makeWrapper, tofi, rbw }:

buildDartPackage rec {
  pname = "tofi-rbw";
  version = "0.0.1";

  src = ../.;
  specFile = ../pubspec.yaml;
  lockFile = ../pub2nix.lock;
  
  meta = with lib; {
    description = "Uses Tofi to get information from rbw.";
    homepage = "https://github.com/FlafyDev/tofi-rbw";
    maintainers = [ ];
    license = licenses.mit;
  };
}
