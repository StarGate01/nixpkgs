{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, pcsclite
, libnl
}:

stdenv.mkDerivation rec {
  pname = "ifdnlnfc";
  version = "0.0-unstable-2024-11-05";

  src = fetchFromGitHub {
    owner = "jurajsarinay";
    repo = "ifdnlnfc";
    rev = "6a7a26ca7b625929c0013389150fbe6380fcf1fa";
    sha256 = "sha256-DkO6FYnt/CxFpSzXyL2MGvM8RrpiyuBkUZCdd1I9hms=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    pcsclite
    libnl
  ];

  meta = with lib; {
    description = "IFD Handler exposing Linux NFC devices to PCSC lite";
    homepage = "https://github.com/jurajsarinay/ifdnlnfc";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stargate01 ];
  };
}
