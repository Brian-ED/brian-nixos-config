# CBQN native build
pkgs: pkgs.stdenv.mkDerivation {
  pname = "cbqn";
  version = "rolling";
  src = pkgs.fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "a0d4ef7a499873dafe3dbc91cf8f4683e0b5821c";
    hash = "sha256-TGqoajyki5HNxBiT5wuabdQvYnrFc2bBNBsyXUo3TE0=";
    fetchSubmodules = true;
  };

  dontConfigure = true;
  preferLocalBuild = true;

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs       = [ pkgs.libffi ];

  # Set the system C compiler
  makeFlags = [ "CC=${pkgs.llvmPackages.clangWithLibcAndBasicRtAndLibcxx}/bin/clang" ];

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

#  doCheck = true;
#  checkPhase = ''
#    runHook preCheck
#    bash test/mainCfgs.sh path/to/mlochbaum/BQN # run the test suite for a couple primary configurations
#    bash test/x86Cfgs.sh  path/to/mlochbaum/BQN # run the test suite for x86-64-specific configurations, including singeli; 32-bit build is "supposed" to fail one test involving ⋆⁼
#    bash test/moreCfgs.sh path/to/mlochbaum/BQN # run "2+2" in a bunch of configurations; requires dzaima/BQN to be accessible as dbqn
#    bqn test/run.bqn                           # run tests in test/cases/
#    make -C test/ffi // test FFI functionality; expects both regular and shared library CBQN builds to already exist
#
#      test/joinReuse.bqn   # test in-place join; requires -DPRINT_JOIN_REUSE
#      test/readTests.bqn   # read mlochbaum/BQN tests in various formats
#      test/precompiled.bqn # run a precompiled expression
#
#    runHook postCheck
#  '';


  meta = {
    description = "Optimized CBQN interpreter with REPLXX support for AMD Ryzen";
    homepage    = "https://github.com/dzaima/CBQN";
    license     = pkgs.lib.licenses.gpl3Only;
    platforms   = pkgs.lib.platforms.linux;
  };
}
