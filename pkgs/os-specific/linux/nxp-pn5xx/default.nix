{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, kernel
, kmod
}:

stdenv.mkDerivation {
  pname = "nxp-pn5xx";
  version = "0.4-unstable-2024-07-05-${kernel.version}";

  src = fetchFromGitHub {
    owner = "jr64";
    repo = "nxp-pn5xx";
    rev = "32ed027ad48dd278b4a4a36ae78658b5bf8ea270";
    hash = "sha256-Uf4ZQlUP8CyZq07ksxAtRMr5vD/YUQW1zNrDIYvYD6w=";
  };

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "BUILD_KERNEL_PATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)/lib/modules/${kernel.modDirVersion}"
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    echo 'SUBSYSTEM=="misc", KERNEL=="pn544", MODE="0666", GROUP="dialout"' > $out/etc/udev/rules.d/99-nxp-pn5xx.rules
  '';

  meta = with lib; {
    description = "NXP's NFC Open Source Kernel mode driver with ACPI configuration support";
    homepage = "https://github.com/jr64/nxp-pn5xx";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ stargate01 ];
    platforms = platforms.linux;
  };
}
