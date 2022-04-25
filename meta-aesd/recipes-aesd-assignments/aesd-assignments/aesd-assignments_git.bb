# See http://git.yoctoproject.org/cgit.cgi/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# TODO: Set this  with the path to your assignments rep.  Use ssh protocol and see lecture notes
# about how to setup ssh-agent for passwordless access
SRC_URI = "git://git@github.com/cu-ecen-aeld/final-project-ajsanthosh14.git;protocol=ssh;branch=main"

PV = "1.0+git${SRCPV}"
# TODO: set to reference a specific commit hash in your assignment repo
SRCREV = "a929cc062e86d5b5925748d1af060c76d3fafebf"

# This sets your staging directory based on WORKDIR, where WORKDIR is defined at 
# https://www.yoctoproject.org/docs/latest/ref-manual/ref-manual.html#var-WORKDIR
# We reference the "server" directory here to build from the "server" directory
# in your assignments repo
S = "${WORKDIR}/git/tests"

# TODO: Add the aesdsocket application and any other files you need to install
# See http://git.yoctoproject.org/cgit.cgi/poky/plain/meta/conf/bitbake.conf?h=warrior for yocto path prefixes
FILES_${PN} += "${bindir}/serverPL1.sh"
FILES_${PN} += "${bindir}/serverPL1.sh"
# TODO: customize these as necessary for any libraries you need for your application

EXTRA_OEMAKE += "'CC=${CC}'"
TARGET_CC_ARCH += "${LDFLAGS}"
TARGET_LDFLAGS += "-pthread -lrt"

# configuring start script 
#inherit update-rc.d
RDEPENDS_${PN} += "bash"



do_configure () {
	:
}

do_compile () {
	:
}

do_install () {
	
	
	install -d ${D}${bindir}
	install -m 0755 ${S}/serverPL1.sh ${D}${bindir}/
	install -m 0755 ${S}/serverPL2.sh ${D}${bindir}/
	install -m 0755 ${S}/serverMPL1.sh ${D}${bindir}/
	install -m 0755 ${S}/utube.sh ${D}${bindir}/

}
