{ writeShellApplication, ... }:

{ book   # The book
, branch # The branch to which you want to deploy
, deploy # The deploy derivation
}:

writeShellApplication {
  name = "deploy";

  runtimeInputs = [ deploy ];

  text = ''
    exec deploy "$@" ${book} ${branch}
  '';
}
