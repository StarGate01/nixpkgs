{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, pcsclite
, libnfc-nci
}:

stdenv.mkDerivation rec {
  pname = "ifdnfc-nci";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = "ifdnfc-nci";
    rev = "v${version}";
    sha256 = "sha256-XnLwgKVBXhhGxD6igTkde/MLcegc0ok7w7iLQ9BPWAM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pcsclite
    libnfc-nci
  ];

  meta = with lib; {
    description = "PC/SC IFD Handler based on linux_libnfc-nci";
    homepage = "https://github.com/StarGate01/ifdnfc-nci";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stargate01 ];
  };
}
