{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.nfc-nci;

  defaultSettings = {
    nci = {
      APPL_TRACE_LEVEL = "0x00";
      PROTOCOL_TRACE_LEVEL = "0x00";
      HOST_LISTEN_TECH_MASK = "0x07";
      POLLING_TECH_MASK = "0xEF";
      P2P_LISTEN_TECH_MASK = "0xC5";
    };
    init = {
      NXPLOG_GLOBAL_LOGLEVEL = "0x00";
      NXPLOG_EXTNS_LOGLEVEL = "0x00";
      NXPLOG_NCIHAL_LOGLEVEL = "0x00";
      NXPLOG_NCIX_LOGLEVEL = "0x00";
      NXPLOG_NCIR_LOGLEVEL = "0x00";
      NXPLOG_FWDNLD_LOGLEVEL = "0x00";
      NXPLOG_TML_LOGLEVEL = "0x00";
      NXP_NFC_DEV_NODE = ''"/dev/pn544"'';
      NXP_ACT_PROP_EXTN = "{2F, 02, 00}";
      NXP_NFC_PROFILE_EXTN = ''{20, 02, 05, 01,
        A0, 44, 01, 00
      }'';
      NXP_CORE_STANDBY = "{2F, 00, 01, 00}";
      NXP_I2C_FRAGMENTATION_ENABLED = "0x00";
    };
    pn54x = {
      MIFARE_READER_ENABLE = "0x01";
      NXP_SYS_CLK_SRC_SEL = "0x01";
      NXP_SYS_CLK_FREQ_SEL = "0x00";
      NXP_SYS_CLOCK_TO_CFG = "0x01";
      NXP_CORE_CONF = ''{20, 02, 2B, 0D,
        28, 01, 00,
        21, 01, 00,
        30, 01, 08,
        31, 01, 03,
        33, 04, 04, 03, 02, 01,
        54, 01, 06,
        50, 01, 02,
        5B, 01, 00,
        60, 01, 0E,
        80, 01, 01,
        81, 01, 01,
        82, 01, 0E,
        18, 01, 01
      }'';
      NXP_CORE_CONF_EXTN = ''{20, 02, 09, 02,
        A0, 5E, 01, 01,
        A0, 40, 01, 00
      }'';
      NXP_NFC_PROPRIETARY_CFG = "{05:FF:FF:06:81:80:70:FF:FF}";
      NXP_EXT_TVDD_CFG = "0x01";
      NXP_EXT_TVDD_CFG_1 = ''{20, 02, 07, 01,
        A0, 0E, 03, 16, 09, 00
      }'';
      NXP_NFC_MAX_EE_SUPPORTED = "0x00";
    };
  };

  generateSettings = cfgName:
    let
      toKeyValueLines = obj: builtins.concatStringsSep "\n" (map (key: "${key}=${obj.${key}}") (builtins.attrNames obj));
    in
      toKeyValueLines (defaultSettings.${cfgName} // (cfg.settings.${cfgName} or {}));
in
{
  options.hardware.nfc-nci = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        PN5xx udev rules and ensure 'dialout' group exists.
      '';
    };

    blacklistedKernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "nxp_nci_i2c"
        "nxp_nci"
      ];
      description = ''
        Blacklist of kernel modules known to conflict with pn5xx.
      '';
    };

    settings = lib.mkOption {
      default = defaultSettings;
      description = ''
        Configuration to be written to the libncf-nci configuration files.
        To understand the configuration format, refer to https://github.com/NXPNFCLinux/linux_libnfc-nci/tree/master/conf.
      '';
      type = lib.types.attrs;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libnfc-nci
    ];

    environment.etc = {
      "libnfc-nci.conf".text = generateSettings "nci";
      "libnfc-nxp-init.conf".text = generateSettings "init";
      "libnfc-nxp-pn547.conf".text = generateSettings "pn54x";
      "libnfc-nxp-pn548.conf".text = generateSettings "pn54x";
    };

    services.udev.packages = [
      pkgs.linuxPackages.nxp-pn5xx
    ];

    boot.blacklistedKernelModules = cfg.blacklistedKernelModules;
    boot.extraModulePackages = [
      pkgs.linuxPackages.nxp-pn5xx
    ];
    boot.kernelModules = [
      "nxp-pn5xx"
    ];

    users.groups.dialout = { };
  };

  meta.maintainers = with lib.maintainers; [ stargate01 ];
}
