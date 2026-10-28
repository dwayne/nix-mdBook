{ writeShellApplication

, deploy
}:

{ book
, branch
}:

writeShellApplication {
  name = "deploy-book";
  runtimeInputs = [ deploy ];
  text = ''
    exec deploy "$@" "${book}" "${branch}"
  '';
}
