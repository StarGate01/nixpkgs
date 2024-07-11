{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, pkg-config
, systemd
, glib
, dbus
, libnl
, python3Packages
, python3
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "neard";
  version = "0.19-unreleased-2024-07-02";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linux-nfc";
    repo = "neard";
    rev = "a0a7d4d677800a39346f0c89d93d0fe43a95efad";
    hash = "sha256-6BgX7cJwxX+1RX3wU+HY/PIBgzomzOKemnl0SDLJNro=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    python3Packages.wrapPython
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    systemd
    glib
    dbus
    libnl
  ] ++ (with python3Packages; [
    python
  ]);

  pythonPath = with python3Packages; [
    dbus-python
    pygobject3
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-debug"
    "--enable-tools"
    "--enable-ese"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  postInstall = ''
    install -m 0755 tools/snep-send $out/bin/

    install -D -m644 src/main.conf $out/etc/neard/main.conf

    # INFO: the config option "--enable-test" would copy the apps to $out/lib/neard/test/ instead
    install -d $out/lib/neard
    install -m 0755 test/* $out/lib/neard/
    wrapPythonProgramsIn $out/lib/neard "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Near Field Communication Daemon for Linux ";
    homepage = "https://github.com/linux-nfc/neard";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ stargate01 ];
    platforms = platforms.linux;
  };
}
