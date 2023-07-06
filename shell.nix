let
  # Import pinned repositories
  sources = import ./nix/sources.nix;
  # Grab nixpkgs from there
  nixpkgs = import sources.nixpkgs { config.allowUnfree = true; };
in
# Create a shell
nixpkgs.mkShell {
  nativeBuildInputs = [
    nixpkgs.niv # grab the latest version of niv
  ];
  # Force this nixpkgs to be available for commands such as
  # nix-shell -p <package>
  NIX_PATH =
    "nixpkgs=${sources.nixpkgs}:nixos-config=/etc/nixos/configuration.nix";
}
