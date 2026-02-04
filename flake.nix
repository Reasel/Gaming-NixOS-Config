# flake.nix
{
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
     bakkesmod-nix = {
       url = "github:AddG0/bakkesmod-nix";
       inputs.nixpkgs.follows = "nixpkgs";
     };
     crossmacro.url = "github:alper-han/CrossMacro";
   };

   outputs = {self, nixpkgs, home-manager, bakkesmod-nix, crossmacro, ...}@inputs: {
  # set up for NixOS
  nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      ./configuration.nix
      # Add Home Manager integration
      home-manager.nixosModules.home-manager
       {
         nixpkgs.config.allowUnfree = true;  # Required for unfree packages

         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.users.reasel = { pkgs, ... }: {  # Changed to "reasel" to match your user
           imports = [ bakkesmod-nix.homeManagerModules.default ];

          # Required: Set Home Manager stateVersion (match your NixOS version)
          home.stateVersion = "25.11";


          programs.bakkesmod = {
            enable = true;
            plugins = with pkgs.bakkesmod-plugins; [  # Customize plugins as needed
              ingamerank
            ];
            config = {  # Customize config options as needed (see repo docs for all options)
              console.enabled = false;
              ranked.showRanks = true;
              ranked.autoGG = true;

              extraConfig = {
                "bind \"NumPadOne\"" = "queue";
                "bind \"NumPadTwo\"" = "load_freeplay";
                "bind \"Subtract\"" = "cancel_queue";
              };

            };
          };
        };
      }
    ];
  };
};
}
