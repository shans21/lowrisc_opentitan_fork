# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load(
    "//rules/opentitan:defs.bzl",
    "cw310_params",
    "opentitan_test",
)
load(
    "//rules:const.bzl",
    "CONST",
    "get_lc_items",
    "hex",
    "hex_digits",
)
load(
    "//rules:opentitan.bzl",
    "RSA_ONLY_KEY_STRUCTS",
    "filter_key_structs_for_lc_state",
)
load(
    "//rules:otp.bzl",
    "STD_OTP_OVERLAYS",
    "otp_bytestring",
    "otp_image",
    "otp_json",
    "otp_partition",
)
load(
    "//rules:rom_e2e.bzl",
    "maybe_skip_in_ci",
)
load(
    "//rules:splice.bzl",
    "bitstream_splice",
)
load(
    "//sw/device/silicon_creator/rom/e2e:defs.bzl",
    "MSG_PASS",
    "MSG_TEMPLATE_BFV",
    "MSG_TEMPLATE_BFV_LCV",
)

package(default_visibility = ["//visibility:public"])

otp_json(
    name = "otp_json_sigverify_key_validity",
    partitions = [
        otp_partition(
            name = "CREATOR_SW_CFG",
            items = {
                "CREATOR_SW_CFG_SIGVERIFY_RSA_KEY_EN": otp_bytestring([
                    CONST.HARDENED_BYTE_FALSE,  # key0
                    0x00,  # key1
                    0xff,  # key2
                    CONST.HARDENED_BYTE_FALSE,  # key3
                    CONST.HARDENED_BYTE_FALSE,  # key4
                    CONST.HARDENED_BYTE_FALSE,  # key5
                    CONST.HARDENED_BYTE_FALSE,  # key6
                    CONST.HARDENED_BYTE_FALSE,  # key7
                ]),
            },
        ),
    ],
)

[
    otp_image(
        name = "otp_img_sigverify_key_validity_{}".format(lc_state),
        src = "//hw/ip/otp_ctrl/data:otp_json_{}".format(lc_state),
        overlays = STD_OTP_OVERLAYS + [":otp_json_sigverify_key_validity"],
    )
    for lc_state, _ in get_lc_items()
]

[
    opentitan_test(
        name = "sigverify_key_validity_{}_{}".format(
            lc_state,
            key.rsa.name,
        ),
        srcs = ["//sw/device/silicon_creator/rom/e2e:empty_test"],
        cw310 = cw310_params(
            exit_failure = MSG_PASS if lc_state_val != CONST.LCV.TEST_UNLOCKED0 else MSG_TEMPLATE_BFV_LCV.format(
                hex_digits(CONST.BFV.SIGVERIFY.BAD_RSA_KEY),
                hex_digits(lc_state_val),
            ),
            exit_success = MSG_TEMPLATE_BFV_LCV.format(
                hex_digits(CONST.BFV.SIGVERIFY.BAD_RSA_KEY),
                hex_digits(lc_state_val),
            ) if lc_state_val != CONST.LCV.TEST_UNLOCKED0 else MSG_PASS,
            otp = ":otp_img_sigverify_key_validity_{}".format(lc_state),
            tags = maybe_skip_in_ci(lc_state_val),
        ),
        exec_env = {
            "//hw/top_earlgrey:fpga_cw310_rom_with_fake_keys": None,
        },
        rsa_key = {key.rsa.label: key.rsa.name},
        deps = [
            "//sw/device/lib/testing/test_framework:ottf_main",
        ],
    )
    for lc_state, lc_state_val in get_lc_items()
    for key in filter_key_structs_for_lc_state(RSA_ONLY_KEY_STRUCTS, lc_state_val)
]

test_suite(
    name = "rom_e2e_sigverify_key_validity",
    tags = ["manual"],
    tests = [
        "sigverify_key_validity_{}_{}".format(
            lc_state,
            key.rsa.name,
        )
        for lc_state, lc_state_val in get_lc_items()
        for key in filter_key_structs_for_lc_state(RSA_ONLY_KEY_STRUCTS, lc_state_val)
    ],
)
