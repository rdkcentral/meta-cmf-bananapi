FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI:append = "\
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6', 'file://cpu_procanalyzer_build_issues.patch', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-12', 'file://cpu_procanalyzer_build_issues_v6.patch', '', d)} \
"
