{ lib
, stdenv
, fetchFromGitHub
, maven
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "globalplatformpro";
  version = "21.12.31";

  src = fetchFromGitHub {
    owner = "martinpaljak";
    repo = "GlobalPlatformPro";
    rev = "v${version}";
    sha256 = "sha256-6pKY4ReSv4WZCNgx98EuZZ54dM24USgZnylLOkHa+tI=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ maven jre ];

  buildPhase = ''
    runHook preBuild

    # Skip Windows executable packaging
    sed -i '/<\!-- Package for Windows -->/,$d' tool/pom.xml
    echo '</plugins></build></project>' >> tool/pom.xml

    mvn package

    # Install binaries
    mkdir -p $out/bin
    mv tool/target/gp.jar tool/target/gptool-${version}.jar $out/bin

    makeWrapper ${jre}/bin/java $out/bin/gpp \
      --add-flags "-jar $out/bin/gp.jar"

    # Install libraries
    mkdir -p $out/lib
    mv library/target/globalplatformpro-${version}.jar $out/lib

    # Install docs
    mkdir -p $out/share/docs
    mv docs/* $out/share/docs

    runHook postBuild
  '';

  dontInstall = true;
  dontFixup = true;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-daCqwXAShUIeKaVXY09CnJnXsW1+6t7roEs8rhKdW5k=";

  meta = with lib; {
    description = "Load and manage applets on compatible JavaCards";
    homepage = "https://github.com/martinpaljak/GlobalPlatformPro";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stargate01 ];
  };
}
