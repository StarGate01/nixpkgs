{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, autoreconfHook
, pcsclite, PCSC
, libnfc
, python3
, help2man
, gengetopt
, openssl_1_1
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "vsmartcard-ccid";
  version = "20220814";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    rev = "1a395716cbd96515635e406de7e7a290824166b8";
    sha256 = "sha256-/3l4/cXeMRbfDTewchpC8zfGww1F4qvwpUszPJzpY5A=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/ccid";

  CFLAGS = [
    "-g"
    "-Wno-error=use-after-free"
  ];

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    help2man
    autoPatchelfHook
  ];

  buildInputs = [
    pcsclite
    gengetopt
    openssl_1_1
  ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  postInstall = ''
  '';

  meta = with lib; {
    description = "Forwards a locally present PC/SC smart card reader as a standard USB CCID reader";
    homepage = "https://frankmorgner.github.io/vsmartcard/ccid/README.html";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
