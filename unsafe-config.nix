{ config, lib, ... }: with lib; {

  # Running dyalogscript currently requires /bin/dyalogscript
  options.environment.bindyalogscript = mkOption {
    default = null;
    type = types.nullOr types.path;
    description = ''
      Include a /bin/dyalogscript in the system.
    '';
  };
  config.system.activationScripts.bindyalogscript =
    if config.environment.bindyalogscript != null
    then ''
      mkdir -m 0755 -p /bin
      ln -sfn ${config.environment.bindyalogscript} /bin/.dyalogscript.tmp
      mv /bin/.dyalogscript.tmp /bin/dyalogscript # atomically replace /usr/bin/env
    ''
    else "rm -f /bin/dyalogscript";
}