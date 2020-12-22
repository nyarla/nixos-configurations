{ python2Packages }:
python2Packages.buildPythonPackage rec {
  pname = "PyDRCS";
  name = "pydrcs-${version}";
  version = "0.1.6";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "1dq40sh3h8pcjpgz15shq56svai51jxgg1r3wb9k22a7a65bjqxr";
  };

  buildInputs = [
    python2Packages.python
    python2Packages.pillow
    python2Packages.wrapPython
  ];
  pythonPath = with python2Packages; [ pillow ];
  postInstall = "wrapPythonPrograms";
}
