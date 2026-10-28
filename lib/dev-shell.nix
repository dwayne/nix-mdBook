{ just
, lib
, mdbook
, mkShell

, highlightJs

, enableDefaultJustfile ? true
, enableHighlightJs ? true
, autogenerateHighlightJs ? true
}:

mkShell {
  name = "shell";

  packages = [
    just
    mdbook
  ];

  shellHook = ''
    export PROJECT_ROOT="$PWD"

    ${lib.optionalString enableDefaultJustfile ''
      export PROJECT_DEFAULT_JUSTFILE="${./justfile}"

      if [ -z "$(find "$PROJECT_ROOT" -maxdepth 1 \( -iname justfile -o -iname .justfile \))" ]; then
        export JUST_JUSTFILE="$PROJECT_DEFAULT_JUSTFILE"
        export JUST_WORKING_DIRECTORY="$PROJECT_ROOT"
      fi
    ''}

    ${lib.optionalString enableHighlightJs ''
      export PROJECT_HIGHLIGHT_JS="${highlightJs}/highlight.js"

      ${lib.optionalString autogenerateHighlightJs ''
        if [ ! -f "$PROJECT_ROOT/theme/highlight.js" ]; then
          just generate-highlight-js
        fi
      ''}
    ''}
  '';
}
