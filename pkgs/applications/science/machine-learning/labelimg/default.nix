{ lib, python3Packages, fetchFromGitHub, qt5 }:
  python3Packages.buildPythonApplication rec {
    pname = "labelImg";
    version = "1.8.3";
    src = fetchFromGitHub {
      owner = "tzutalin";
      repo = "labelImg";
      rev = "b33f965b6d14c14f1e46b247f1bf346e03f2e950";
      hash = "sha256-0DBPsQWwiUbBPbVu88yl4mGiMhYHYLWUkMsjpMbPrL4=";
    };
    nativeBuildInputs = with python3Packages; [
      pyqt5
      qt5.wrapQtAppsHook
    ];
    propagatedBuildInputs = with python3Packages; [
      pyqt5
      lxml
      sip_4
    ];
    preBuild = ''
      make qt5py3
    '';
    postInstall = ''
      cp libs/resources.py $out/${python3Packages.python.sitePackages}/libs
    '';
    dontWrapQtApps = true;
    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
    meta = with lib; {
      description = "A graphical image annotation tool and label object bounding boxes in images";
      homepage = "https://github.com/tzutalin/labelImg";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.cmcdragonkai ];
    };
  }
