{ mdbook
, runCommand
}:

{ name # The name of the book
, src  # The source files necessary to build the book
}:

runCommand name {
  nativeBuildInputs = [ mdbook ];
} ''
  mdbook build --dest-dir "$out" "${src}"
''
