{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  flit-core,
  setuptools,
}:
buildPythonPackage {
  pname = "cached-method";
  version = "v0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "martenlienen";
    repo = "cached_method";
    rev = "2032a09511e7a1b98c2b24b280a83d2129f8c8b1";
    hash = "sha256-iV9EWUySvKi1hMUV7RnzJX3IAlTuXGCMxC+PZNNwWQA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flit-core
  ];

  meta = {
    description = "A Python library for simulating finite automata, pushdown automata, and Turing machines";
    homepage = "https://github.com/caleb531/automata";
    license = lib.licenses.mit;
  };
}
