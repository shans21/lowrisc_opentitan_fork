// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "keymgr_base_vseq.sv"
`include "keymgr_smoke_vseq.sv"
`include "keymgr_common_vseq.sv"
`include "keymgr_sideload_vseq.sv"
`include "keymgr_sideload_one_intf_vseq.sv"
`include "keymgr_random_vseq.sv"
`include "keymgr_cfg_regwen_vseq.sv"
`include "keymgr_direct_to_disabled_vseq.sv"
`include "keymgr_lc_disable_vseq.sv"
`include "keymgr_sw_invalid_input_vseq.sv"
`include "keymgr_hwsw_invalid_input_vseq.sv"
`include "keymgr_kmac_rsp_err_vseq.sv"
`include "keymgr_custom_cm_vseq.sv"
`include "keymgr_sideload_protect_vseq.sv"
`include "keymgr_sync_async_fault_cross_vseq.sv"
`include "keymgr_stress_all_vseq.sv"
