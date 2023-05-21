# Lament Configuration

If you were to want to Qonfigure some type of Qube, u might Lament the impulse.

(Especially if doing so requires learning saltstack, amirite)

## Qubes Salt basics

You only have to do this once:

```sh
# install the user configuration
# (creates /srv/user_salt etc)
dnf install qubes-mgmt-salt-base-config

# enable the user configuration
# this lets us place salt files in /srv/user_salt and /srv/user_pillar
qubesctl top.enable qubes.user-dirs

# verify that the user-dirs are enabled
qubesctl top.enabled

# apply the state - create the user_* directories
# You can re-run this if you ever delete the /srv/user_{salt,pillar,formulas} dirs
qubesctl state.apply
```

## Using the Lament Configuration

After enabling user-dirs (per previous section),
you must install the Lament Configuration RPM and enable its Salt top files.
This assumes you have already built the Lament Configuration with `make` in a builder qube.

```sh
# The name of the qube vm that contains the built Lament Configuration
builderqube=micahrl

# Retrieve the Lament Configuration package from the builder vm
# Find the path, including RPM version number etc, from the output of 'make'
qvm-run --pass-io $builderqube "cat /home/user/rpmbuild/RPMS/noarch/lament-configuration-0.1.BUILDNUM-0.noarch.rpm" > /srv/lament.rpm

# Install/upgrade the Lament Configuration Salt files
rpm -Uvh /srv/lament.rpm

# Enable the top files from the Lament Configuration
qubesctl top.enable micahrl-template
qubesctl top.enable ...

# Apply all states in the user environment (/srv/user_salt)
# Takes a long time
qubesctl --all state.highstate saltenv=user

# Apply just dom0 states
# The implicit target is localhost, which is dom0
# dom0 states include vm creation and settings
# Gets all states from all top files in both local (/srv/salt) AND user (/srv/user_salt) environments
# Does not require or support saltenv=user
qubesctl state.apply
```

## Building the Lament Configuration

```sh
# Show a nice help message with all make targets
make

# Install the files to ./build/root for inspection
make install

# Make a new RPM with a new version number
make newrpm

# Just increment the version number (don't build an RPM)
make incver

# Just build an RPM with the same version number
make rpm
```

RPM stuff:

```sh
# Unpack an RPM to the current directory (for testing)
rpm2cpio whatever.rpm | cpio -idmv
```

### Versioning

Summary:
The RPM will be versioned as `0.1.BUILDNUM-0`,
where `BUILDNUM` is the content of the `BUILDNUM` file.
The `BUILDNUM` file is added to git so that version numbers are tracked.
See below for details.

The version of the RPM has four components:

* The major component, set in Makefile (probably 0)
* The minor component, set in Makefile (probably 1)
* The patch component,
  defined in the BUILDNUM file which should be committed to git,
  and incremented automatically by the Makefile
* The RPM release component, set in Makefile (probably 0)

The major.minor.patch version is a generic software versioning convention.
The RPM release component is a standard RPM convention,
designed to allow the RPM to be versioned separately from the artifacts inside of it;
we don't really need this in this case, so we set it to 0.

## Diagram: how does Salt work exactly

* Top files are a Salt thing, typically called `top.sls`
* Qubes has its own convention of having top files called `whatever.top`
  but AFAICT they work the same way
* In Qubes, each top file must be enabled with `qubesctl top.enable whatever`
  (omit the `.top` extension)
* Note that this is all top files, including ones you might create in `/etc/user_pillar` !
* Qubes top files must contain the environment (`user`), a list of machines,
  and then may reference other state files.
* Other state files are referenced by directory, like `reusable/software/vscode.sls`
  is referenced as `reusable.software.vscode`.

e.g. here's a top file:

```yaml
user: # The name of the environment, which is 'user'
  dom0: # The name of the machine
    dom0.osconfig # Looks for a file called dom0/osconfig.sls
  somevm: # The name of another machine
    reusable.software.vscode # Looks for a file called reusable/software/vscode.sls
```

## Directory layout

```text
/srv
  /user_salt
    /hypervisor
      (VM creation etc, executes on dom0 to control the hypervisor)
      (commands in this section run states like qvm.clone and qvm.prefs)
      /appvms
      /templates
    /reusable
      (reusable state files, referenced in other state files)
    /vms
      (VM configuration etc, executes in each VM to configure it)
      /appvms
      /dom0
        (Configure the dom0 VM, eg by installing packages)
      /templates
  (... top files etc)
```

## Encrypting data

It's useful to keep this repo in Git, maybe even stored on github or other remote service,
but to do this we need a secure way to store secrets.

* Generate a GPG key, I couldn't do this in dom0 because it complained about pinentry, whatever. You probably want to do `gpg --full-generate-key` so you have control over encryption algorithms and expiration. I used the full name `hyperqube` and did not enter an email address.
* Copy it to dom0 and import it.
* Save it somewhere like a password manager (for backups etc)
* Remove the secret key to your builder VM if you didn't generate it in dom0.
* Copy the public key to your builder VM
* Encrypt secrets with that: `echo "secretvalue" | gpg --encrypt --armor --recipient hyperqube > secretvalue.asc`

<https://fabianlee.org/2016/10/18/saltstack-keeping-salt-pillar-data-encrypted-using-gpg/>
