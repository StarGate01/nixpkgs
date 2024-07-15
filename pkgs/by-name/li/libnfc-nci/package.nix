{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, config
, debug ? config.libnfc-nci.debug or false
}:

stdenv.mkDerivation {
  pname = "libnfc-nci";
  version = "2.4.1-unstable-2024-07-16";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = "linux_libnfc-nci";
    rev = "4fc402ffd07642b1231fb259a6b956771d524e5e";
    sha256 = "sha256-mrGsTikxS/oR+Wh9a4aVCszbF/nbFAVBQfYN421vqU0=";
  };

  buildInputs = [
    pkg-config
    autoreconfHook
  ];

  configureFlags = [
    "--enable-i2c"
  ] ++ lib.optionals debug [
    "--enable-debug"
  ];
  dontStrip = debug;

  postInstall = ''
    rm -rf $out/etc
  '';

  meta = with lib; {
    description = "Linux NFC stack for NCI based NXP NFC Controllers";
    homepage = "https://github.com/NXPNFCLinux/linux_libnfc-nci";
    license = licenses.asl20;
    maintainers = with maintainers; [ stargate01 ];
    platforms = platforms.linux;
  };
}
