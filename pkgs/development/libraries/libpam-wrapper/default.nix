{ lib, stdenv
, fetchgit
, cmake
, linux-pam
, enablePython ? false
, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "libpam-wrapper";
  version = "1.1.5";

  src = fetchgit {
    url = "git://git.samba.org/pam_wrapper.git";
    rev = "pam_wrapper-${version}";
    sha256 = "sha256-AtfkiCUvCxUfll6lOlbMyy5AhS5R2BGF1+ecC1VuwzM=";
  };

  patches = [
    # See https://cmake.org/cmake/help/latest/policy/CMP0148.html
    ./00-cmake-python.patch
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals enablePython [ python ];

  # We must use linux-pam, using openpam will result in broken fprintd.
  buildInputs = [ linux-pam ];

  meta = with lib; {
    description = "Wrapper for testing PAM modules";
    homepage = "https://cwrap.org/pam_wrapper.html";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
