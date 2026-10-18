{ writeShellApplication

, deploy # The deploy derivation
}:

{ book   # The book
, branch # The branch to which you want to deploy
}:

writeShellApplication {
  name = "deploy-book";

  runtimeInputs = [ deploy ];

  text = ''
    exec deploy "$@" ${book} ${branch}
  '';
}
