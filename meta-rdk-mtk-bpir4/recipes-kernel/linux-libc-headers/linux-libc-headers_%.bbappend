FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "\
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6', 'file://cpu_procanalyzer_build_issues.patch', '', d)} \
"
