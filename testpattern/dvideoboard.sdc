create_clock -period 20.000 -name clk50 [get_ports {CLK50}]
create_clock -period 200.000 -name clkdvideo [get_ports {GPIO0}]
derive_pll_clocks