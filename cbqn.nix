# CBQN native build
pkgs: pkgs.stdenv.mkDerivation {
  pname = "cbqn";
  version = "rolling";
  src = pkgs.fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "a37166975cee583d0176549ec70de5ff79d5d26e";
    hash = "sha256-4t0iJJPGT9a9ShrLm3okzk563UMxrThbf2a130c80Ac=";
    fetchSubmodules = true;
  };

  dontConfigure = true;
  preferLocalBuild = true;

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs       = [ pkgs.libffi ];

  # Set the system C compiler
  makeFlags = [ "CC=${pkgs.llvmPackages_19.clangWithLibcAndBasicRtAndLibcxx}/bin/clang" ];

  # Customize build for maximum performance.
  buildFlags = [
    "notui=1"
    "REPLXX=1"
    "o3n"
    "target_from_cc=1"
  ];
  # Set up local copies of required submodules.
  preBuild = ''
    mkdir -p build/{singeliLocal,bytecodeLocal,replxxLocal}
    cp -r build/singeliSubmodule/* build/singeliLocal/
    cp -r build/bytecodeSubmodule/* build/bytecodeLocal/
    cp -r build/replxxSubmodule/* build/replxxLocal/
    unset NIX_ENFORCE_NO_NATIVE
  '';

  postPatch = ''
    # Remove the SHELL definition from the makefile and fix shebangs.
    sed -i '/SHELL =/d' makefile
    patchShebangs build/build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp BQN $out/bin/
    ln -sf BQN $out/bin/bqn
    ln -sf BQN $out/bin/cbqn
  '';

  meta = {
    description = "Optimized CBQN interpreter with REPLXX support for AMD Ryzen";
    homepage    = "https://github.com/dzaima/CBQN";
    license     = pkgs.lib.licenses.gpl3Only;
    platforms   = pkgs.lib.platforms.linux;
  };
}