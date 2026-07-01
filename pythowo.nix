{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "pythowo";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "virejdasani";
    repo = "pythOwO";
    rev = "master"; 
    hash = "sha256-9Yy9oaW2NkxM+av3mgAYRAzOQjuZ2bV1w0fNd7u0yQ8=";
  };

  format = "other";
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/libexec/pythowo
    cp -r * $out/libexec/pythowo/

    # Cria o executável no PATH apontando para o script principal
    makeWrapper ${python3}/bin/python $out/bin/pythowo \
      --add-flags "$out/libexec/pythowo/shwell.py"
  '';

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  meta = with lib; {
    description = "An UwU programming language written in Python";
    homepage = "https://github.com/virejdasani/pythOwO";
    license = licenses.mit;
  };
}
