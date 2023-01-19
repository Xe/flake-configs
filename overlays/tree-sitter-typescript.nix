final: prev: {
  tree-sitter-grammars = prev.tree-sitter-grammars // {
    tree-sitter-typescript =
      prev.tree-sitter-grammars.tree-sitter-typescript.overrideAttrs (_: {
        nativeBuildInputs = [ final.nodejs final.tree-sitter ];
        configurePhase = ''
          tree-sitter generate --abi 13 typescript/src/grammar.json
          tree-sitter generate --abi 13 tsx/src/grammar.json
        '';
      });
  };
}
