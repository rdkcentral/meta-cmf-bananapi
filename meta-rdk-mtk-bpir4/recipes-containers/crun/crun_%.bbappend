# Remove seccomp from REQUIRED_DISTRO_FEATURES
REQUIRED_DISTRO_FEATURES := "${@' '.join([f for f in d.getVar('REQUIRED_DISTRO_FEATURES').split() if f != 'seccomp'])}"
