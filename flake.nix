{
  description = "Host Configuration";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hardware-configuration.nix  # マシン固有の設定
        ./dev-base.nix                # 共通パッケージ
        ./user.nix                    # dev ユーザー SSHキーの設定など
        ./system.nix                  # ホスト名やシステムが参照するリポジトリの設定
        ./boot-bios.nix               # biosによる起動
        # ./boot-uefi.nix             # uefiによる起動(オプション)
        ./serial-console.nix          # シリアルコンソールの有効化(オプション)
        ./qemu-guest.nix              # ゲストエージェントの有効化(オプション)
      ];
    };

    nixosConfigurations."ci-test" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-ci.nix
        ./dev-base.nix 
        ./user.nix
        ./ci-test.nix
      ];
    };
  };
}