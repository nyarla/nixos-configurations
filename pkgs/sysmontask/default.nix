{ python3, fetchpatch, fetchFromGitHub, wrapGAppsHook, cairo, dmidecode, glib
, gobject-introspection, gtk3, libwnck, lshw, psutils }:
python3.pkgs.buildPythonApplication rec {
  pname = "SysMonTask";
  version = "2022-07-09";

  src = fetchFromGitHub {
    owner = "KrispyCamel4u";
    repo = "SysMonTask";
    rev = "aee8b9cace49df622909b280010ea08c952198c5";
    sha256 = "0qvm8fkh45f0fm1q03fvn076clgf9pl3f60f7l3n9y4bwirg38rp";
  };

  patches = [ ./L3.patch ];

  postPatch = ''
    sed -i "s|/usr/share|$out/share|g" glade_files/sysmontask.glade
    sed -i "s|/usr/share|$out/share|g" sysmontask/gproc.py
    sed -i "s|/usr/share|$out/share|g" sysmontask/sysmontask.py
    sed -i "s|/usr/share|$out/share|g" sysmontask/theme_setter.py

    sed -i "s|lshw -c network|${lshw}/bin/lshw -c network|" sysmontask/net.py
    sed -i "s|dmidecode -t memory|${dmidecode}/bin/dmidecode -t memory|" sysmontask/mem.py
  '';

  buildInputs = [ glib gtk3 cairo gobject-introspection libwnck lshw psutils ];

  nativeBuildInputs = [ wrapGAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [ psutil pycairo pygobject3 ];

  postInstall = ''
    mv $out/lib/*/site-packages/usr/share $out/share
  '';

  checkPhase = "true";
}
