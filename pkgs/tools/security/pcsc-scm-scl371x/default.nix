{ lib, stdenv, fetchurl, unzip, libusb-compat-0_1 }:

let
  arch = if stdenv.hostPlatform.system == "i686-linux" then "32"
  else if stdenv.hostPlatform.system == "x86_64-linux" then "64"
  else throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "pcsc-scm-scl371x";
  version = "2.18";

  src = fetchurl {
    url = "https://files.identiv.com/products/logical-access-control/scl3711/SCx371x_Linux_${version}_Driver.zip";
    sha256 = "sha256-la0hTfaONNZps1vjVc4wuycK+11DySKT9hL8+GCwUrk=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
    tar xf "scx371x_${version}_linux_${arch}bit_release.tar.bz2"
    export sourceRoot=$(readlink -e scx371x_${version}_linux_${arch}bit_release)
  '';

  installPhase = ''
    mkdir -p $out/pcsc/drivers
    cp -r proprietary/*.bundle $out/pcsc/drivers
  '';

  libPath = lib.makeLibraryPath [ libusb-compat-0_1 ];

  fixupPhase = ''
    patchelf --set-rpath $libPath \
      $out/pcsc/drivers/SCx371x.bundle/Contents/Linux/libSCx371x.so.${version};
  '';

  meta = with lib; {
    description = "SCM Microsystems SCL371x chipcard reader user space driver";
    homepage = "https://www.scm-pc-card.de/kartenleser/identiv-leser/kontaktbehaftet/67/scm-scl3711-kontaktloser-leser-fuer-chipkarten-und-nfc-905169";
    downloadPage = "https://support.identiv.com/scl3711/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ stargate01 ];
    platforms = platforms.linux;
  };
}
