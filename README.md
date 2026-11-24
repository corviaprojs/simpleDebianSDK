# simpleLinuxSDK
A building environment specially for Debian, with config and migrate system.<br>
**Getting Started with:**<br>
> [How the config (system) work?](#how-the-config-system-work) <br>
> [Createing a custom config](#custom-config)<br>
> [Commands](#commands)<br>
> [Schematic/Working](#schematic)<br>
> [Contribute](#contribute)<br>

### How the config (system) work?
A config is created from 3 things:
`config.mk` *file* - Configuration
`migrate` *folder* - Migrate Shell scripts
`grub` *folder* - Grub files

**`config.mk`** file: Your settings for the config.
**Required:**
`ISO_OUTPUT_NAME` - The ISO file name<br>
`CHROOT_PKGS` - Packages that be installed<br>
`DEBIAN_VERSION` - Debian version that be used as the base.<br>
`ARCH` - The architecure ofcourse<br>
**Not required:**<br>
`APT_ARG` - APT install arguments that be appended when installing the `CHROOT_PKGS`
`DEBOOTSTRAP_ARGS` - Debootstrap arguments that be gonna get appended

### Custom Config
*one min*

### Commands
All commands are applied to the specified configuration: `CONFIG=[config_name]`

**Setup:**  
Creates the system based on the defined configuration.
```sh
sudo make CONFIG=[config_name] setup
```

**Migration:**  
Runs the shell scripts located in the config's `migrate` directory in numerical order.  
*(Note: The `setup` command runs this automatically.)*
```sh
sudo make CONFIG=[config_name] migrate
```

**Build ISO:**  
Generates an ISO file named after the `ISO_OUTPUT_NAME` variable defined in your configuration. Once the process is complete, a message will display the output path.
```sh
sudo make CONFIG=[config_name] iso
```
If you only need to rebuild the ISO, run:
```sh
sudo make CONFIG=[config_name] reiso
```

**Chroot:**  
Opens a Bash shell inside the environment for manual configuration.
```sh
sudo make CONFIG=[config_name] chroot
```

**Install Packages:**  
Re-runs the package installation step for the selected configuration.
```sh
sudo make CONFIG=[config_name] install_pkgs
```

### Schematic
*soon...*

### Contribute
If you has any problem, question please open a issue.
Choose the right tag for the thing.