# For Kauff

Right off rip I can tell you this will **NOT** work and will need a lot of editing

1. Go through each of the files and replace stuff like "ur_hostname" with what you want your hostname to be  
2. Rename `/hosts/ur_hostname` to the same hostname from the last step  
    - This is an important step since `flake.nix` uses the folder name to set your hostname  
3. Delete the items in `/hosts/ur_hostname/secret.nix`  
    - If you don't you will get an error when you build since you won't have the secrets
    - Might also be ok to build, add them, and then build again idk  
4. Go through the rest of the files and change stuff like your domain name, your ssh, age, and wireguard keys, etc.  
    - I left you my yazi config to show you what you can do with it if you so choose  
    - If you have it on the server but not on your own system, your terminal emulator should still be able to use it when your ssh'd in  
5. Get everything to where you think its ready to build  
    - Even though i included tons of stuff, I think its best to disable most of the stuff to start and add on to it incrementely  
    - **DON'T** disable `termExtras` or anything in `modules/mediaServer/security`  
    - Change the path for `nh` in `termExtras` to where you will clone the repo
6. On your host, edit your current `/etc/nixos/configuration.nix` with:  

```nix
config = {
  networking.hostname = "<the hostname from steps 1 and 2>";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
};
```
8. Run `sudo nixos-rebuild switch`  
    - Verify your hostname changed to the one you set  
    - May have to reboot to fully see it  
9. Clone your new repo  
10. Copy `/etc/nixos/hardware-configuration.nix` to `./hosts/ur_hostname/hardware-configuration.nix`  
    - This system won't build if you forget this. I totally removed my config so you're forced to do it  
11. `cd` to your repo's root dir  
12. run `nix run github:manic-systems/tack -- update`  
    - I straight up copied my pins so this step might be unnecessary  
    - If you want to change to `nixpkgs-stable` then you will 100% need to do this  
13. run `nix flake check`  
14. Fix the remaining errors and rerun step 11 until it builds  
    - When that command has no output, then ur good to go   
15. Run `sudo nixos-rebuild switch --flake .`   

## Extras

### Editor
I added vim, configured it as the default editor, and disabled nano (cause it sux :P). If you have a vimrc you use already, you can place it in `/dotfiles` and link it in place with hjem. If not, you can also configure it in nix with `programs.vim.vimrcConfig`, but I reccomend against this since you can't share that with systems that aren't running nix. 

### nh

The nix command is incredibly verbose and rather difficult to remember. I added a program called `nh` that is a wrapper for it. Once you get your first successful build AND the path in `/modules/mediaServer/termExtras` if right, you can run `nh os switch` to rebuild instead.  

### nix-secrets
1. Once you've built the system and `nix-secrets` is installed, make `~/.age`  
2. Run `nix-secrets keygen > ~/.age/keys.txt`
3. Copy the public key from that file to `/modules/mediaServer/security/keys` 
4. Rebuild with `nh os switch`
5. Now you can add secrets with `nix-secrets edit ur/secret`  
    - It will open your default editor, which if no changes from here will be `vim`  

### ncro

You absolutely need to setup cache's on nix if you don't want to compile everything from source  

This is a different way to add cache substituters. It checks them all in parallel instead of one by one, reducing build and fetch times by quite a bit.

## Things that could go wrong

### ncro and tack

If for whatever reason ncro or tack decides it doesn't want to work (you'll get 404s when trying to rebuild), do:  
`nh os switch --option substituters "https://cache.nixos.org/" --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=`  
I've had this go wrong on me before. It should work off rip, but could cause some issues if you don't have a github PAT in `nix.settings`. Text me about this or go to the hyprland discord. #nix-nixos will hook you up  

### I'll add more later if I can think of any 
Happy NixOS :)  


