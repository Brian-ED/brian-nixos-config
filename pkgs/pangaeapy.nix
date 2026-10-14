{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  aiohttp,
  jmespath,
  lxml,
  netcdf4,
  numpy,
  pandas,
  requests,
  ...
}:

buildPythonPackage rec {
  pname = "pangaeapy";
  version = "1.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pangaea-data-publisher";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5c7b+V/pSR2LnGRu8ForuMfCg5RRCbrzwBD5lqkwmIg=";
  };

  outputs = [
    "out"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    jmespath
    lxml
    netcdf4
    numpy
    pandas
    requests
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
