# Lament Configuration specfile
#
# This specfile is designed to be built from a local git checkout.
#
# Macros that should be defined when calling rpmbuild:
# - version: The version of the code
# - release: The release number of the RPM
# - lament_source_root: The path to the local git checkout
# - buildroot:

Name:       lament-configuration
Version:    %version
Release:    %release
Summary:    If you were to want to Qonfigure some type of Qube, u might Lament the impulse.
License:    WTFPL
BuildArch:  noarch

%description
Hyperqube configuration package


%install
echo "INSTALL"
cd %{lament_source_root}
make install BUILDROOT=%{buildroot}

%files
/srv/*

%changelog
# let's skip this for now

