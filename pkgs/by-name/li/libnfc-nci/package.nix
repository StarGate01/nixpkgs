{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation {
  pname = "libnfc-nci";
  version = "2.4.2-unreleased";

  src = fetchFromGitHub {
    owner = "NXPNFCLinux";
    repo = "linux_libnfc-nci";
    rev = "449538e5e106666e5263afeaddacc5836fc23d3f";
    sha256 = "sha256-ngooArd2g8DBFRQ0M7BFYoJLlhWLX/R5YjuDkj6qh1Y=";
  };

  buildInputs = [
    pkg-config
    autoreconfHook
  ];

  configureFlags = [
    "--enable-i2c"
  ];

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
