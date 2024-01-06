{ lib, makeWrapper, mpi, ngspice, pkg-config, stdenv, ... }:
let
  pname = "asco";
  version = "0.4.11";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchTarball {
    url = "https://sourceforge.net/projects/asco/files/asco/0.4.11/ASCO-0.4.11.tar.gz/download#";
    sha256 = "0nn96mdy1nfmk8bxh6x5fxrdqx7a7s6nr1y27w4mnh6z9xswwi5c";
  };
  buildInputs = [
    makeWrapper
    mpi
    ngspice
    pkg-config
    stdenv
  ];
  hardeningDisable = [ "all" ];

  patchPhase = ''
    substituteInPlace ./Makefile \
    --replace '<FULL_PATH_TO_MPICH>' '${mpi}' \
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp  -r . $out
    cp asco $out/bin/asco
  '';

  postFixup = ''
    wrapProgram $out/bin/asco \
    --set PATH ${lib.makeBinPath [
      ngspice
    ]}
  '';
}
