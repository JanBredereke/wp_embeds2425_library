create_clock -period 10 [get_ports clk]  # 100 MHz clock
set_max_delay -from [get_ports s_axis_tdata] -to [get_ports m_axis_tdata] 10
