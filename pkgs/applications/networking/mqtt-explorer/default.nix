{ lib
, stdenv
, fetchurl
, appimageTools
, electron_24
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "mqtt-explorer";
  version = "0.3.5";

  src = appimageTools.extract {
    name = pname;
    src = fetchurl {
      url = "https://github.com/thomasnordquist/MQTT-Explorer/releases/download/v${version}/MQTT-Explorer-${version}.AppImage";
      sha256 = "sha256-Yfz42+dVIx3xwIOmYltp5e9rYka+KskvQuxJVVBgbg4=";
    };
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -m 444 -D resources/app.asar $out/libexec/app.asar
    install -m 444 -D mqtt-explorer.png $out/share/icons/mqtt-explorer.png
    install -m 444 -D mqtt-explorer.desktop $out/share/applications/mqtt-explorer.desktop
    makeWrapper ${electron_24}/bin/electron $out/bin/mqtt-explorer --add-flags $out/libexec/app.asar
  '';

  meta = with lib;{
    description = "An all-round MQTT client that provides a structured topic overview.";
    homepage = "https://mqtt-explorer.com/";
    license = licenses.cc-by-nd-40;
    maintainers = with maintainers; [ stargate01 ];
    platforms = platforms.linux;
  };
}
