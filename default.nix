with import <nixpkgs> {};

pkgs.mkShell {
  name = "pip-env";
  buildInputs = with pkgs; [ pkgs.python3 pkgs.python3.pkgs.gevent pkgs.python3.pkgs.pymysql ];
  src = null;
  shellHook = ''

  '';
}
