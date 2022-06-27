{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libnfc-nci";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "NXPNFCLinux";
    repo = "linux_libnfc-nci";
    rev = "R${version}";
    sha256 = "sha256-jgzwNLvDxROvuNpSXvr5CLlMMt5g0QuTujDcrSJeE5Y=";
  };

  buildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "Linux NFC stack for NCI based NXP NFC Controllers ";
    homepage = "https://github.com/NXPNFCLinux/linux_libnfc-nci";
    license = licenses.asl20;
    maintainers = with maintainers; [ stargate01 ];
    platforms = platforms.linux;
  };
}
