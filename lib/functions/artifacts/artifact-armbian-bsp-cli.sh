#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-2.0
#
# Copyright (c) 2013-2023 Igor Pecovnik, igor@armbian.com
#
# This file is a part of the Armbian Build Framework
# https://github.com/armbian/build/

function artifact_armbian-bsp-cli_prepare_version() {
	artifact_version="undetermined"        # outer scope
	artifact_version_reason="undetermined" # outer scope

	declare short_hash_size=4

	declare fake_unchanging_base_version="1"

	# get the hashes of the lib/ bash sources involved...
	declare hash_files="undetermined"
	calculate_hash_for_files "${SRC}"/lib/functions/bsp/armbian-bsp-cli-deb.sh
	declare bash_hash="${hash_files}"
	declare bash_hash_short="${bash_hash:0:${short_hash_size}}"

	# outer scope
	artifact_version="${artifact_prefix_version}${fake_unchanging_base_version}-B${bash_hash_short}"

	declare -a reasons=(
		"Armbian armbian-bsp-cli"
		"framework bash hash \"${bash_hash}\""
	)

	artifact_version_reason="${reasons[*]}" # outer scope

	artifact_map_packages=(
		["armbian-bsp-cli"]="armbian-bsp-cli"
	)

	artifact_map_debs=(
		["armbian-bsp-cli"]="armbian-bsp-cli-${BOARD}${EXTRA_BSP_NAME}_${artifact_version}_${ARCH}.deb"
	)

	artifact_name="armbian-bsp-cli"
	artifact_type="deb"
	artifact_base_dir="${DEB_STORAGE}"
	artifact_final_file="${DEB_STORAGE}/armbian-bsp-cli-${BOARD}${EXTRA_BSP_NAME}_${artifact_version}_${ARCH}.deb"

	return 0
}

function artifact_armbian-bsp-cli_build_from_sources() {
	LOG_SECTION="compile_armbian-bsp-cli" do_with_logging compile_armbian-bsp-cli
}

function artifact_armbian-bsp-cli_cli_adapter_pre_run() {
	declare -g ARMBIAN_COMMAND_REQUIRE_BASIC_DEPS="yes" # Require prepare_host_basic to run before the command.

	# "gimme root on a Linux machine"
	cli_standard_relaunch_docker_or_sudo
}

function artifact_armbian-bsp-cli_cli_adapter_config_prep() {
	use_board="no" prep_conf_main_minimal_ni < /dev/null # no stdin for this, so it bombs if tries to be interactive.
}

function artifact_armbian-bsp-cli_get_default_oci_target() {
	artifact_oci_target_base="ghcr.io/armbian/cache-firmware/"
}

function artifact_armbian-bsp-cli_is_available_in_local_cache() {
	is_artifact_available_in_local_cache
}

function artifact_armbian-bsp-cli_is_available_in_remote_cache() {
	is_artifact_available_in_remote_cache
}

function artifact_armbian-bsp-cli_obtain_from_remote_cache() {
	obtain_artifact_from_remote_cache
}

function artifact_armbian-bsp-cli_deploy_to_remote_cache() {
	upload_artifact_to_oci
}
