{ pkgs, ... }: {
  environment.systemPackages = [(
    pkgs.writeScriptBin "system" ''
      CONFIG_PATH="$HOME/.config/nix"
      NIXOS_REBUILD="sudo nixos-rebuild"
      HOME_MANAGER="home-manager"
      TRACE_FLAG="--show-trace"

      function nixos_rebuild {
        local option=$1
        local verbose=$2
        local flake="$CONFIG_PATH"

        if [[ -n "$option" ]]; then
          flake="$flake#$option"
        fi

        if [[ "$verbose" == "-v" ]]; then
          $NIXOS_REBUILD --flake "$flake" switch $TRACE_FLAG
        else
          $NIXOS_REBUILD --flake "$flake" switch
        fi
      }

      function home_manager_rebuild {
        local option=$1
        local verbose=$2
        local flake="$CONFIG_PATH"

        if [[ -n "$option" ]]; then
          flake="$flake#$option"
        fi

        if [[ "$verbose" == "-v" ]]; then
          $HOME_MANAGER --flake "$flake" switch $TRACE_FLAG
        else
          $HOME_MANAGER --flake "$flake" switch
        fi
      }

      function system_clean {
        nix-collect-garbage
      }

      function system_update {
        nix flake update $CONFIG_PATH
      }

      case $1 in
        rebuild)
          case $2 in
            host)
              nixos_rebuild $3 $4
              ;;
            home)
              home_manager_rebuild $3 $4
              ;;
            all)
              nixos_rebuild $3 $4
              home_manager_rebuild $3 $4
              ;;
            *)
              echo "Usage: $0 rebuild {host|home|all} [option] [-v] | clean | update"
              ;;
          esac
          ;;
        clean)
          system_clean
          ;;
        update)
          system_update
          ;;
        *)
          echo "Usage: $0 rebuild {host|home|all} [option] [-v] | clean | update"
          ;;
      esac
    ''
  )];
}
