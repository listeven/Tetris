
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name EightBitCounterLab -dir "X:/311Lab/EightBitCounterLab/planAhead_run_1" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "X:/311Lab/EightBitCounterLab/EightCounter.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {X:/311Lab/EightBitCounterLab} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "EightCounter.ucf" [current_fileset -constrset]
add_files [list {EightCounter.ucf}] -fileset [get_property constrset [current_run]]
link_design
