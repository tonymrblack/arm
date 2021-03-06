# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ETYPE="sources"
KPATCH_DIR="${WORKDIR}/tegra-patches/"
K_DEFCONFIG="nyan-big_steev_test_defconfig"
K_DEBLOB_AVAILABLE="0"
K_NOUSEPR="1"
K_SECURITY_UNSUPPORTED="1"
EXTRAVERSION="-${PN}/-*"

EGIT_REPO_URI=https://github.com/Gnurou/linux.git
EGIT_PROJECT="nouveau-linux.git"
EGIT_BRANCH="staging/nouveau"
EGIT_COMMIT="d211d87e14d0c1b28a60cb6b512d162634ca6a99"

inherit kernel-2
detect_version
detect_arch

inherit git-2 versionator
NV_PV="20150723-r1"
NV_PATCHES="tegra-patches-${NV_PV}.tar.gz"
NV_URI="mirror://gentoo/${NV_PATCHES}"

DESCRIPTION="The latest staging version of the Tegra-nouveau Linux kernel"
HOMEPAGE="https://github.com/NVIDIA/tegra-nouveau-rootfs"

SRC_URI="${NV_URI}"

KEYWORDS="~arm"
IUSE="deblob"

K_EXTRAELOG="This kernel is not supported by Gentoo due to its unstable and
experimental nature, and although it's very recent, may still have security
vulnerabilities. See gentoo-embedded on IRC if you have questions, or feel
free to file an issue on github: https://github.com/gentoo/arm/issues.
A copy of the latest steev config has been installed as ${K_DEFCONFIG}.
If you are reading this, you know what to do..."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

src_prepare() {
	update_config

	for p in "${KPATCH_DIR}"/*.patch* ; do
		UNIPATCH_LIST+=" ${p}"
	done

	UNIPATCH_EXCLUDE="drm-tegra-dpaux-Fix-transfers-larger-than-4-bytes.patch"

	unipatch "${UNIPATCH_LIST}"

	git config user.email "arm@gentoo.org"
	git config user.name "Portage git-2"
	git commit -a -n -m"removing -dirty flag"
}

update_config() {
	cp -f "${WORKDIR}"/steev_nyan-big_config \
		"${S}"/arch/arm/configs/${K_DEFCONFIG} \
		|| die "failed to install custom config!"
}

