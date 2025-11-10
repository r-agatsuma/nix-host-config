# My NixOS Host Configuration (`nix-host-config`)

This is my **private** repository for managing NixOS host-specific configurations. It works with the public `nix-dev-base` repository to create a fully declarative development environment.

## 1. Initial Setup

Follow these steps for a freshly installed, minimal NixOS system.

### Step 1: On the New NixOS Machine
1.  Log in as `root`.
2.  Install `git` and `openssh` (if not already present).
    ```bash
    nix-env -iA nixos.git nixos.openssh
    ```
3.  Set a `root` password to allow `scp`.
    ```bash
    passwd root
    ```
4.  Get the machine's IP address.
    ```bash
    ip a
    ```

### Step 2: From Your Laptop (Transfer)
`scp` or `rsync` the entire repository to the new machine's `/root` directory. `rsync` is cleaner.

```bash
git clone https://github.com/r-agatsuma/nix-host-config.git
cd nix-host-config
rsync -rlptv --delete ./ root@<nixos-ip>:/root/nix-host-config
```

As an alternative, use `git`.

```bash
nix-env -iA nixos.git
git clone https://github.com/r-agatsuma/nix-host-config.git /root/nix-host-config
cd /root/nix-host-config
```

### Step 3: On the New NixOS Machine (Run Setup as `root`)
1.  Log in as `root` again.
2.  Run the `setup-host.sh` script. This script will:
    * Back up the original `/etc/nixos`.
    * Copy the machine-specific `hardware-configuration.nix` from the backup.
    * Run the first build (which creates the `dev` user).
    * Move this config repository to its final home (`/home/dev/src/nix-host-config`).
    * Create the final system symlink (`/etc/nixos`).

```bash
cd /root/nix-host-config
./setup-host.sh
```

### Step 4: On the New NixOS Machine (Finalize as `dev`)
1.  Log out of `root` and **log in as the new `dev` user**.
2.  Navigate to your new config directory.
    ```bash
    cd ~/src/nix-host-config
    ```
3.  **Authenticate with GitHub.**
    ```bash
    gh auth login
    ```
4.  Your machine is now fully provisioned and linked to GitHub.

---

## 2. Daily Workflow (Updating the System)

This is a **pull-based** workflow, run *on the NixOS machine* as the `dev` user.

1.  Log in as `dev`.
2.  Navigate to the config directory.
    ```bash
    cd ~/src/nix-host-config
    ```
3.  Run the `update-host.sh` script to apply the changes.
    ```bash
    ./update-host.sh
    ```

This script runs `sudo nix flake update` (to get the latest `nixpkgs` and `nix-dev-base`) and then `sudo nixos-rebuild switch` to activate the new configuration.
