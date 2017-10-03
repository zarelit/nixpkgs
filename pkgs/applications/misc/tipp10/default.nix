{stdenv, fetchFromGitHub, qt4, qmake4Hook }:
with stdenv;
let
  darwin = lib.boolToString isDarwin;
  linux = lib.boolToString isLinux;
in
  mkDerivation rec {
    name = "tipp10-2.1.0";

    src = fetchFromGitHub {
      owner = "KarlZeilhofer";
      repo = "Tipp10";
      rev = "4e06794808ad61a6e3d6928e01b3bc61803b16d5";
      sha256 = "0b18zsmsm7pjc4fz1imfydj1nczsvgg6yd96acv57gal6xsbyksb";
    };


    linux = "true";
    patches = [./defines.patch];
    postPatch = ''
      substituteAllInPlace def/defines.h
    '';

    enableParallelBuilding = true;
    buildInputs = [ qt4 qmake4Hook ];

    installPhase = ''
      install -Dm755 tipp10 "$out/bin/tipp10"
      install -Dm644 release/tipp10v2.template "$out/data/tipp10v2.template"
      #install -Dm644 tipp10.png "$out/share/icons/tipp10.png"
      #cp -R $desktop/share/applications/* $out/share/applications
      #cp -R release/help $out*/
    '';

    meta = with lib; {
      description = "Touch Typing tutor with intelligence";
      homepage = https://www.tipp10.com;
      license = lib.licenses.gpl2;
      maintainers = with maintainers; [ zarelit ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  }
