final: prev: {
  # Electron >= 39.8.10 / 40.9.3 enforces CORS on custom protocols. Obsidian registers
  # app:// without corsEnabled, so the PDF viewer (app://obsidian.md) can't fetch vault
  # files (app://<id>/...) and shows "0 of 0". Same fix as NixOS/nixpkgs#525772;
  # drop this overlay once the nixpkgs pin ships it.
  obsidian = prev.obsidian.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.asar ];

    preInstall = (old.preInstall or "") + ''
      asar extract resources/app.asar app-src
      substituteInPlace app-src/main.js \
        --replace-fail "supportFetchAPI: true," "supportFetchAPI: true, corsEnabled: true,"
      asar pack app-src resources/app.asar --unpack-dir "node_modules/{btime,get-fonts}"
    '';
  });
}
