# Lament Configuration

If you were to want to Qonfigure some type of Qube, u might Lament the impulse.

(Especially if doing so requires learning saltstack, amirite)

## Qubes Salt basics

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
you must unpack the Lament Configuration and enable its Salt top files.
This assumes you have already built the Lament Configuration with `make` in a builder qube.

```sh
# The name of the qube vm that contains the built Lament Configuration
builderqube=micahrl
# The path to the built Lament Configuration
lamentpath="/home/user/Documents/lament-configuration/dist/lament.conf.tar"

# Retrieve the Lament Configuration package from the builder vm
qvm-run --pass-io $builderqube "cat $lamentpath" > /srv/lament.conf.tar

# Extract the Lament Configuration Salt configuration files
# WARNING: this doesn't remove files that were removed from the build!
# TODO: maybe an RPM is the right thing to do here after all
tar -C /srv -xf /srv/lament.conf.tar

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

