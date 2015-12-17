
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name EightBitCounterLab -dir "X:/311Lab/EightBitCounterLab/planAhead_run_2" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "goodButtonCounter.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {EightCounter.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {debouncer.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {goodButtonCounter.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top goodButtonCounter $srcset
add_files [list {goodButtonCounter.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
