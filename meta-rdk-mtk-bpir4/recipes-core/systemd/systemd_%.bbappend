# Prevent systemd from forcing /etc/resolv.conf via update-alternatives
# and remove the resolv-conf.systemd symlink created during do_install.

do_install:append() {
    # Remove the resolv-conf.systemd symlink so update-alternatives won't try to
    # convert /etc/resolv.conf into a link to it (which fails if resolv.conf is
    # already a regular file provided by another package).
    rm -f ${D}${sysconfdir}/resolv-conf.systemd || true

    # Remove any lines in the tmpfiles etc.conf that directly reference resolv.conf
    # to avoid runtime tmpfiles rules pointing to a missing resolv-conf.systemd
    if [ -f ${D}${exec_prefix}/lib/tmpfiles.d/etc.conf ]; then
        sed -i '/resolv.conf/d' ${D}${exec_prefix}/lib/tmpfiles.d/etc.conf || true
    fi
}

python __anonymous() {
    # Safely remove update-alternatives lines for resolv.conf from pkg postinst/prerm
    postinst = d.getVar('pkg_postinst:systemd') or ''
    if postinst:
        postinst = postinst.replace('update-alternatives --install /etc/resolv.conf resolv-conf /etc/resolv-conf.systemd 50\\n', '')
        postinst = postinst.replace('update-alternatives --remove  resolv-conf /etc/resolv-conf.systemd\\n', '')
        d.setVar('pkg_postinst:systemd', postinst)

    prerm = d.getVar('pkg_prerm:systemd') or ''
    if prerm:
        prerm = prerm.replace('update-alternatives --remove  resolv-conf /etc/resolv-conf.systemd\\n', '')
        d.setVar('pkg_prerm:systemd', prerm)
}
