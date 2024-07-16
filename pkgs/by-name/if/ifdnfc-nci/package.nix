{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, pcsclite
, libnfc-nci
, config
, enableBell ? config.ifdnfc-nci.enableBell or false
}:

stdenv.mkDerivation rec {
  pname = "ifdnfc-nci";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = "ifdnfc-nci";
    rev = "v${version}";
    sha256 = "sha256-gU9XMj27v7wT+LR1nShDW2bTP6LYNkjoh7xMXgX7y3A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pcsclite
    libnfc-nci
  ];

  cmakeFlags = [ ] ++ lib.optionals enableBell [
    "-DWITH_DETECTION_BELL=ON"
  ];

  meta = with lib; {
    description = "PC/SC IFD Handler based on linux_libnfc-nci";
    homepage = "https://github.com/StarGate01/ifdnfc-nci";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stargate01 ];
  };
}
