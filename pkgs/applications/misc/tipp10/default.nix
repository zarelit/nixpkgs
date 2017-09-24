{stdenv, fetchFromGitHub, qt4, qmake4Hook }:
# TODO: install icon
# TODO: check help files
stdenv.mkDerivation rec {
  name = "tipp10-2.1.0";

  # FIXME: note about fork
  src = fetchFromGitHub {
    owner = "KarlZeilhofer";
    repo = "Tipp10";
    rev = "4e06794808ad61a6e3d6928e01b3bc61803b16d5";
    sha256 = "0b18zsmsm7pjc4fz1imfydj1nczsvgg6yd96acv57gal6xsbyksb";
  };

  patches = [./defines.patch];
  ## Will configure the application to build for mac or linux
  #postPatch = ''
  #  substituteAllInPlace def/defines.h
  #'';
  enableParallelBuilding = true;

  buildInputs = [ qt4 qmake4Hook ];
  otherInstallThings = ''
    install -Dm644 tipp10.png "$out/share/pixmaps/tipp10.png"
    install -Dm644 tipp10.desktop "$out/share/applications/tipp10.desktop"
    cp -r release/help $out/share/tipp10/help
  '';

  installPhase = ''
    install -Dm755 tipp10 "$out/bin/tipp10"
    install -Dm644 release/tipp10v2.template "$out/data/tipp10v2.template"
  '';

  meta = {
    description = "Touch Typing tutor with intelligence";
    homepage = https://www.tipp10.com;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [zarelit];
    platforms = with stdenv.lib.platforms; linux;
  };
}
