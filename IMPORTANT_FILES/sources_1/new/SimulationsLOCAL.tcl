set username $::env(USERNAME)
cd "C:/users/$username/appdata/roaming/xilinx/vivado"


if {![info exists prjName] } {
    set prjName [get_property NAME [current_project]]
}

set impFiles "./$prjName/IMPORTANT_FILES"
set sourcesRoot "$impFiles/sources_1/new"
set simRoot "$impFiles/sim_1/new"
set sims "$prjName/sims"
file mkdir "$sims"
set modules {}



#Adding every source to the project, first design sources and secondly the simulation sources
foreach file [glob -nocomplain -directory $sourcesRoot *.vhd] {
    add_files -norecurse -scan_for_includes $file
}
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
foreach file [glob -nocomplain -directory $simRoot *.vhd] {
    add_files -fileset sim_1 -norecurse -scan_for_includes $file
    set filename [file tail $file]
    set modulename [file rootname $filename]
    lappend modules $modulename
}
update_compile_order -fileset sim_1

foreach module $modules {
    if {[catch {current_sim} simName] == 0 && $simName ne ""} {
    close_sim
    }
}




#Now that the project is set, we must run synthesis and implementation as usual 
    #.tcl files can't be included in the project, we add it and remove it for developing purposes
remove_files "$sourcesRoot/simulationsLOCAL.tcl" 

reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1

reset_run impl_1
launch_runs impl_1 -jobs 2
wait_on_run impl_1
 


#Vivado wants every simulation previously opened to be closed before running simulations
foreach module $modules {
    if {[catch {close_sim}]} {
        puts "-----No active Sim to close-----"
    } else {
        puts "-----Closed Sim-----"
    }
}



#now for the simulations we must save a project for EACH simulation module, and each one will launch its simulation
foreach module $modules {
    puts "-----SAVING PROJECT-----"
    save_project_as "$sims/${module}" -force
    set_property top stack [current_fileset]
    update_compile_order -fileset sources_1
    
    set_property top ${module} [get_filesets sim_1]
    set_property top_lib xil_defaultlib [get_filesets sim_1]
    update_compile_order -fileset sim_1
    
    launch_simulation -mode post-implementation -type timing
    run 4000ns
}
add_files -norecurse -scan_for_includes "$sourcesRoot/simulationsLOCAL.tcl"
puts "-----Simulations completed-----"

#set_property top memory [current_fileset]
#set_property source_mgmt_mode DisplayOnly [current_project]
#set UserName $env(USERNAME)
#set basePath "C:/Users/${UserName}/AppData/Roaming/Xilinx/Vivado/project.sim"
#    save_wave_config "./${module}_time_impl.wcfg"
#    close_sim
#foreach mod $modules {
#    open_wave_database "./project_1.sim/sim_1/impl/timing/xsim/${mod}_time_impl.wdb"
#    open_wave_config "./${mod}_time_impl.wcfg"
#    puts "type anything to continue the simulations..."
#    gets stdin answer

#}
