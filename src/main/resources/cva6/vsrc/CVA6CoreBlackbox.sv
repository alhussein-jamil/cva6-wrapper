`define WT_DCACHE
`define DISABLE_TRACER
`define SRAM_NO_INIT

// ******************************************************************
// Wrapper for the CVA6 Core
// ******************************************************************

`define HARTID_LEN 64

module CVA6CoreBlackbox
    #(
        parameter integer FREQ_HZ = 100000000,  // Default 100 MHz
        parameter TRACEPORT_SZ = 0,
        parameter XLEN = 64,
        parameter RAS_ENTRIES = 2,
        parameter BTB_ENTRIES = 32,
        parameter BHT_ENTRIES = 128,
        parameter [63:0] EXEC_REG_CNT = 0,
        parameter [63:0] EXEC_REG_BASE_0 = 0,
        parameter [63:0] EXEC_REG_SZ_0 = 0,
        parameter [63:0] EXEC_REG_BASE_1 = 0,
        parameter [63:0] EXEC_REG_SZ_1 = 0,
        parameter [63:0] EXEC_REG_BASE_2 = 0,
        parameter [63:0] EXEC_REG_SZ_2 = 0,
        parameter [63:0] EXEC_REG_BASE_3 = 0,
        parameter [63:0] EXEC_REG_SZ_3 = 0,
        parameter [63:0] EXEC_REG_BASE_4 = 0,
        parameter [63:0] EXEC_REG_SZ_4 = 0,
        parameter [63:0] CACHE_REG_CNT = 0,
        parameter [63:0] CACHE_REG_BASE_0 = 0,
        parameter [63:0] CACHE_REG_SZ_0 = 0,
        parameter [63:0] CACHE_REG_BASE_1 = 0,
        parameter [63:0] CACHE_REG_SZ_1 = 0,
        parameter [63:0] CACHE_REG_BASE_2 = 0,
        parameter [63:0] CACHE_REG_SZ_2 = 0,
        parameter [63:0] CACHE_REG_BASE_3 = 0,
        parameter [63:0] CACHE_REG_SZ_3 = 0,
        parameter [63:0] CACHE_REG_BASE_4 = 0,
        parameter [63:0] CACHE_REG_SZ_4 = 0,
        parameter [63:0] DEBUG_BASE = 0,
        parameter AXI_ADDRESS_WIDTH = 64,
        parameter AXI_DATA_WIDTH = 64,
        parameter AXI_USER_WIDTH = 0,
        parameter AXI_ID_WIDTH = 0,
        parameter PMP_ENTRIES = 0,
        parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH/8
     )
(
    (* X_INTERFACE_PARAMETER = "FREQ_HZ FREQ_HZ, ASSOCIATED_RESET Reset, ASSOCIATED_BUSIF M_AXI" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *)
    input Clk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST Reset" *)
    input Reset,
    input [XLEN - 1:0] BootAddr,
    input [`HARTID_LEN - 1:0] HartId,
    input [1:0] Interrupt,
    input Ipi,
    input TimeIrq,
    input DebugReq,
    output [TRACEPORT_SZ-1:0] Trace,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWREADY" *)
    input  axi_resp_i_aw_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWVALID" *)
    output axi_req_o_aw_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWID" *)
    output [AXI_ID_WIDTH-1:0] axi_req_o_aw_bits_id,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWADDR" *)
    output [AXI_ADDRESS_WIDTH-1:0] axi_req_o_aw_bits_addr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWLEN" *)
    output [7:0] axi_req_o_aw_bits_len,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWSIZE" *)
    output [2:0] axi_req_o_aw_bits_size,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWBURST" *)
    output [1:0] axi_req_o_aw_bits_burst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWLOCK" *)
    output axi_req_o_aw_bits_lock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWCACHE" *)
    output [3:0] axi_req_o_aw_bits_cache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWPROT" *)
    output [2:0] axi_req_o_aw_bits_prot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWQOS" *)
    output [3:0] axi_req_o_aw_bits_qos,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWREGION" *)
    output [3:0] axi_req_o_aw_bits_region,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWUSER" *)
    output [AXI_USER_WIDTH-1:0] axi_req_o_aw_bits_user,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WREADY" *)
    input axi_resp_i_w_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WVALID" *)
    output axi_req_o_w_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WDATA" *)
    output [AXI_DATA_WIDTH-1:0] axi_req_o_w_bits_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WSTRB" *)
    output [(AXI_DATA_WIDTH/8)-1:0] axi_req_o_w_bits_strb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WLAST" *)
    output axi_req_o_w_bits_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WUSER" *)
    output [AXI_USER_WIDTH-1:0] axi_req_o_w_bits_user,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARREADY" *)
    input axi_resp_i_ar_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARVALID" *)
    output axi_req_o_ar_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARID" *)
    output [AXI_ID_WIDTH-1:0] axi_req_o_ar_bits_id,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARADDR" *)
    output [AXI_ADDRESS_WIDTH-1:0] axi_req_o_ar_bits_addr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARLEN" *)
    output [7:0] axi_req_o_ar_bits_len,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARSIZE" *)
    output [2:0] axi_req_o_ar_bits_size,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARBURST" *)
    output [1:0] axi_req_o_ar_bits_burst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARLOCK" *)
    output axi_req_o_ar_bits_lock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARCACHE" *)
    output [3:0] axi_req_o_ar_bits_cache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARPROT" *)
    output [2:0] axi_req_o_ar_bits_prot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARQOS" *)
    output [3:0] axi_req_o_ar_bits_qos,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARREGION" *)
    output [3:0] axi_req_o_ar_bits_region,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARUSER" *)
    output [AXI_USER_WIDTH-1:0] axi_req_o_ar_bits_user,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BREADY" *)
    output axi_req_o_b_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BVALID" *)
    input axi_resp_i_b_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BID" *)
    input [AXI_ID_WIDTH-1:0] axi_resp_i_b_bits_id,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BRESP" *)
    input [1:0] axi_resp_i_b_bits_resp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BUSER" *)
    input [AXI_USER_WIDTH-1:0] axi_resp_i_b_bits_user,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RREADY" *)
    output axi_req_o_r_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RVALID" *)
    input axi_resp_i_r_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RID" *)
    input [AXI_ID_WIDTH-1:0] axi_resp_i_r_bits_id,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RDATA" *)
    input [AXI_DATA_WIDTH-1:0] axi_resp_i_r_bits_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RRESP" *)
    input [1:0] axi_resp_i_r_bits_resp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RLAST" *)
    input axi_resp_i_r_bits_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RUSER" *)
    input [AXI_USER_WIDTH-1:0] axi_resp_i_r_bits_user
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI, \
    ID_WIDTH AXI_ID_WIDTH, \
    ADDR_WIDTH AXI_ADDRESS_WIDTH, \
    DATA_WIDTH AXI_DATA_WIDTH, \
    AWUSER_WIDTH 0, \
    ARUSER_WIDTH 0, \
    WUSER_WIDTH 0, \
    RUSER_WIDTH 0, \
    BUSER_WIDTH 0, \
    PROTOCOL AXI4, \
    READ_WRITE_MODE READ_WRITE, \
    HAS_BURST 1, \
    HAS_LOCK 1, \
    HAS_PROT 1, \
    HAS_CACHE 1, \
    HAS_REGION 1, \
    HAS_QOS 1, \
    HAS_WSTRB 1, \
    HAS_BRESP 1, \
    HAS_RRESP 1, \
    FREQ_HZ FREQ_HZ" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI CLK" *)
localparam ariane_pkg::ariane_cfg_t CVA6SocCfg = '{
        RASDepth: RAS_ENTRIES,
        BTBEntries: BTB_ENTRIES,
        BHTEntries: BHT_ENTRIES,
        // idempotent region
        NrNonIdempotentRules:  0,
        NonIdempotentAddrBase: {64'b0},
        NonIdempotentLength:   {64'b0},
        // execute region
        NrExecuteRegionRules:  EXEC_REG_CNT,
        ExecuteRegionAddrBase: {EXEC_REG_BASE_4, EXEC_REG_BASE_3, EXEC_REG_BASE_2, EXEC_REG_BASE_1, EXEC_REG_BASE_0},
        ExecuteRegionLength:   {  EXEC_REG_SZ_4,   EXEC_REG_SZ_3,   EXEC_REG_SZ_2,   EXEC_REG_SZ_1,   EXEC_REG_SZ_0},
        // cached region
        NrCachedRegionRules:   CACHE_REG_CNT,
        CachedRegionAddrBase:  {CACHE_REG_BASE_4, CACHE_REG_BASE_3, CACHE_REG_BASE_2, CACHE_REG_BASE_1, CACHE_REG_BASE_0},
        CachedRegionLength:    {  CACHE_REG_SZ_4,   CACHE_REG_SZ_3,   CACHE_REG_SZ_2,   CACHE_REG_SZ_1,   CACHE_REG_SZ_0},
        //  cache config
        Axi64BitCompliant:      1'b1,
        SwapEndianess:          1'b0,
        // debug
        DmBaseAddress:          DEBUG_BASE,
        NrPMPEntries:           PMP_ENTRIES
    };

    // connect ariane
    ariane_axi::req_t  ariane_axi_req;
    ariane_axi::resp_t ariane_axi_resp;

    `ifdef FIRESIM_TRACE
        traced_instr_pkg::trace_port_t tp_if;
(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "yes" *)
        ariane #(
            .ArianeCfg ( CVA6SocCfg )
        ) i_ariane (
            .clk_i(Clk),
            .rst_ni(~Reset),
            .boot_addr_i(BootAddr),
            .hart_id_i(HartId),
            .irq_i(Interrupt),
            .ipi_i(Ipi),
            .time_irq_i(TimeIrq),
            .debug_req_i(DebugReq),
            .trace_o ( tp_if ),
            .axi_req_o ( ariane_axi_req ),
            .axi_resp_i ( ariane_axi_resp )
        );
    `else
        ariane #(
            .ArianeCfg ( CVA6SocCfg )
        ) i_ariane (
            .clk_i(Clk),
            .rst_ni(~Reset),
            .boot_addr_i(BootAddr),
            .hart_id_i(HartId),
            .irq_i(Interrupt),
            .ipi_i(Ipi),
            .time_irq_i(TimeIrq),
            .debug_req_i(DebugReq),
            .axi_req_o ( ariane_axi_req ),
            .axi_resp_i ( ariane_axi_resp )
        );
    `endif

    `ifdef FIRESIM_TRACE
        // roll all trace signals into a single bit array (and pack according to rocket-chip)
        for (genvar i = 0; i < ariane_pkg::NR_COMMIT_PORTS; ++i) begin : gen_tp_roll
            assign Trace[(TRACEPORT_SZ*(i+1)/ariane_pkg::NR_COMMIT_PORTS)-1:(TRACEPORT_SZ*i/ariane_pkg::NR_COMMIT_PORTS)] = {
                tp_if[i].tval[39:0],
                tp_if[i].cause[7:0],
                tp_if[i].interrupt,
                tp_if[i].exception,
                { 1'b0, tp_if[i].priv[1:0] },
                tp_if[i].insn[31:0],
                tp_if[i].iaddr[39:0],
                tp_if[i].valid,
                ~tp_if[i].reset,
                tp_if[i].clock
            };
        end
    `else
        // set all the trace signals to 0
        assign Trace = '0;
    `endif

    AXI_BUS #(
        .AXI_ADDR_WIDTH(AXI_ADDRESS_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .AXI_ID_WIDTH(AXI_ID_WIDTH),
        .AXI_USER_WIDTH(AXI_USER_WIDTH)
    ) axi_slave_bus();

    // convert ariane axi port to normal axi port
    axi_master_connect i_axi_master_connect_ariane (
        .axi_req_i(ariane_axi_req),
        .axi_resp_o(ariane_axi_resp),
        .master(axi_slave_bus)
    );

    AXI_BUS #(
        .AXI_ADDR_WIDTH(AXI_ADDRESS_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .AXI_ID_WIDTH(AXI_ID_WIDTH),
        .AXI_USER_WIDTH(AXI_USER_WIDTH)
    ) axi_master_bus();

    // deal with atomics using arianes wrapper
    axi_riscv_atomics_wrap #(
        .AXI_ADDR_WIDTH(AXI_ADDRESS_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .AXI_ID_WIDTH(AXI_ID_WIDTH),
        .AXI_USER_WIDTH(AXI_USER_WIDTH),
        .AXI_MAX_WRITE_TXNS (1),
        .RISCV_WORD_WIDTH(XLEN)
    ) i_axi_riscv_atomics (
        .clk_i(Clk),
        .rst_ni(~Reset),
        .slv(axi_slave_bus),
        .mst(axi_master_bus)
    );

    // connect axi_master_bus to the outgoing signals
    assign axi_master_bus.aw_ready = axi_resp_i_aw_ready;
    assign axi_req_o_aw_valid = axi_master_bus.aw_valid;
    assign axi_req_o_aw_bits_id = axi_master_bus.aw_id;
    assign axi_req_o_aw_bits_addr = axi_master_bus.aw_addr;
    assign axi_req_o_aw_bits_len = axi_master_bus.aw_len;
    assign axi_req_o_aw_bits_size = axi_master_bus.aw_size;
    assign axi_req_o_aw_bits_burst = axi_master_bus.aw_burst;
    assign axi_req_o_aw_bits_lock = axi_master_bus.aw_lock;
    assign axi_req_o_aw_bits_cache = axi_master_bus.aw_cache;
    assign axi_req_o_aw_bits_prot = axi_master_bus.aw_prot;
    assign axi_req_o_aw_bits_qos = axi_master_bus.aw_qos;
    assign axi_req_o_aw_bits_region = axi_master_bus.aw_region;
    assign axi_req_o_aw_bits_user = axi_master_bus.aw_user;

    assign axi_master_bus.w_ready = axi_resp_i_w_ready;
    assign axi_req_o_w_valid = axi_master_bus.w_valid;
    assign axi_req_o_w_bits_data = axi_master_bus.w_data;
    assign axi_req_o_w_bits_strb = axi_master_bus.w_strb;
    assign axi_req_o_w_bits_last = axi_master_bus.w_last;
    assign axi_req_o_w_bits_user = axi_master_bus.w_user;

    assign axi_master_bus.ar_ready =  axi_resp_i_ar_ready;
    assign axi_req_o_ar_valid = axi_master_bus.ar_valid;
    assign axi_req_o_ar_bits_id = axi_master_bus.ar_id;
    assign axi_req_o_ar_bits_addr = axi_master_bus.ar_addr;
    assign axi_req_o_ar_bits_len = axi_master_bus.ar_len;
    assign axi_req_o_ar_bits_size = axi_master_bus.ar_size;
    assign axi_req_o_ar_bits_burst = axi_master_bus.ar_burst;
    assign axi_req_o_ar_bits_lock = axi_master_bus.ar_lock;
    assign axi_req_o_ar_bits_cache = axi_master_bus.ar_cache;
    assign axi_req_o_ar_bits_prot = axi_master_bus.ar_prot;
    assign axi_req_o_ar_bits_qos = axi_master_bus.ar_qos;
    assign axi_req_o_ar_bits_region = axi_master_bus.ar_region;
    assign axi_req_o_ar_bits_user = axi_master_bus.ar_user;

    assign axi_req_o_b_ready = axi_master_bus.b_ready;
    assign axi_master_bus.b_valid = axi_resp_i_b_valid;
    assign axi_master_bus.b_id = axi_resp_i_b_bits_id;
    assign axi_master_bus.b_resp = axi_resp_i_b_bits_resp;
    assign axi_master_bus.b_user = axi_resp_i_b_bits_user;

    assign axi_req_o_r_ready = axi_master_bus.r_ready;
    assign axi_master_bus.r_valid = axi_resp_i_r_valid;
    assign axi_master_bus.r_id = axi_resp_i_r_bits_id;
    assign axi_master_bus.r_data = axi_resp_i_r_bits_data;
    assign axi_master_bus.r_resp = axi_resp_i_r_bits_resp;
    assign axi_master_bus.r_last = axi_resp_i_r_bits_last;
    assign axi_master_bus.r_user = axi_resp_i_r_bits_user;

endmodule

// existing aribtration interface
interface AXI_ARBITRATION
(
  input wire clk,
  input wire rst_n
);

  // Forward path
  logic [1:0]atop_req;
  logic [1:0]atop_gnt;

  // Backward path
  logic       req_gnt;

  modport master (
    output atop_req,
    input atop_gnt,
    output req_gnt
  );

  modport slave (
    input atop_req,
    output atop_gnt,
    input req_gnt
  );

endinterface

// AXI routing information
interface AXI_ROUTING_RULES
(
  input wire clk,
  input wire rst_n
);

  // typedef struct packed {
  //   logic [63:0] start_addr;
  //   logic [63:0] end_addr;
  // } xbar_rules_t;

  // xbar_rules_t [1:0] rules;
  logic [127:0] rules;

  modport master (
    // output xbar_rules_t rules
    output rules
  );

  modport slave (
    // input xbar_rules_t rules
    input rules
  );

endinterface
