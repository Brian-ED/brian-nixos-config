{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  ...
}:

buildPythonPackage rec {
  pname = "celltypist";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teichlab";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gv6SHpAKoqiJqVC5/fVK8VJgEf0QQKyD0rmS5aRIjO8=";
  };

  outputs = [
    "out"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
  ];

  doCheck = false;

  meta = {
    description = "Framework for writing tests";
    homepage = "https://docs.pytest.org";
    changelog = "https://github.com/pytest-dev/pytest/releases/tag/${version}";
    teams = [ lib.teams.python ];
    license = lib.licenses.mit;
  };
}
