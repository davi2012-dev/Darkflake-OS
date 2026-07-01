{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "pythowo";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "virejdasani";
    repo = "pythOwO";
    rev = "57ee3e3b3e648f57f4955b410fb59bc02cf2e84d";
    hash = "sha256-K+R8mD7Xb7b+Z7V6vU7vGZp/JdDeoP2R4o7vFk3R9kQ=";
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
