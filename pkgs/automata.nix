{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  frozendict,
  typing-extensions,
  networkx,
  cached-method,
  pytestCheckHook,
  pythonOlder,
  flit-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "automata";
  version = "v9.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "caleb531";
    repo = "automata";
    tag = version;
    hash = "sha256-Dhn3RSIpN1xpYZqRJuCw1jDEhczaI2oPDnLP1P4gmN4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flit-core
    cached-method
    networkx
    frozendict
    typing-extensions
  ];


  meta = {
    description = "A Python library for simulating finite automata, pushdown automata, and Turing machines";
    homepage = "https://github.com/caleb531/automata";
    license = lib.licenses.mit;
  };
}
