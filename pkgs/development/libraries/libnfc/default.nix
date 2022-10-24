{ lib
, stdenv
, fetchFromGitHub
, libusb-compat-0_1
, readline
, cmake
, pkg-config
, pcsclite
, PCSC
}:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = pname;
    rev = "test";
    sha256 = "sha256-xm5tLMpTiwjqekuB6QainCV2tB6c/MuqGRgsJ7SRiC8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb-compat-0_1
    readline
    pcsclite
  ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  configureFlags = [
    "sysconfdir=/etc"
  ];

  cmakeFlags = [
    "-DLIBNFC_DEBUG_MODE=ON"
    "-DLIBNFC_DRIVER_PCSC=ON"
    "-DLIBNFC_DRIVER_ACR122_PCSC=ON"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DLIBNFC_DRIVER_PN532_I2C=OFF"
    "-DLIBNFC_DRIVER_PN532_SPI=OFF"
  ];

  dontStrip = true;

  meta = with lib; {
    description = "Library for Near Field Communication (NFC)";
    homepage = "https://github.com/nfc-tools/libnfc";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
