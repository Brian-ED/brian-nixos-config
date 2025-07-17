# I used these settings for setting up an ubuntu server virtual machine.
# I didn't need it after all, but I might need it later so am saving it here.
# This isn't well optimized, but it worked.
{ pkgs, ... }: let
  defaultNetworkFile = pkgs.writeText "default.xml" ''
    <network>
      <name>default</name>
      <uuid>9a05da11-e96b-47f3-8253-a3a482e445f5</uuid>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <mac address='52:54:00:0a:cd:21'/>
      <ip address='192.168.1.57' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.122.2' end='192.168.122.254'/>
        </dhcp>
      </ip>
    </network>
  '';
in {
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      qemu.runAsRoot = false;
      enable = true;
      hooks.network = {
        "default.xml" = "${defaultNetworkFile}";
      };
    };
  };
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "brian" ];
  users.users.brian.extraGroups = [ "libvirtd" ];

  environment.systemPackages = [
    pkgs.libvirt-glib
  ];
}