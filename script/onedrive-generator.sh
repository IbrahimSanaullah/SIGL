#!/bin/bash
spade_bin="./SPADE/bin/spade"
spade_cfg="./SPADE/cfg/spade.client.Control.config"


clear_spade_cfg(){
  truncate -s 0 "${spade_cfg}"
}


is_spade_running(){
  "${spade_bin}" status | grep -q "Running"
}


stop_spade(){
  "${spade_bin}" stop
}


kill_spade(){
  "${spade_bin}" kill
}


try_stop_kill_spade(){
  #if is_spade_running; then
   # stop_spade
  ##fi
  #sleep 5
  if is_spade_running; then
    kill_spade
  fi
}


start_spade(){
  "${spade_bin}" start
}


send_spade_command(){
  local cmd="${1}"
  echo "${cmd}" | "${spade_bin}" control
  if [ "${debug}" -eq 1 ]; then
  echo "list all" | "${spade_bin}" control
  fi
}


add_graphviz_storage(){
  local output_path="${1}"
  local cmd="add storage Graphviz ${output_path}"
  send_spade_command "${cmd}"
}


remove_graphviz_storage(){
  local cmd="remove storage Graphviz"
  send_spade_command "${cmd}"
}


add_cdm_reporter(){
  local input_log="${1}"
  local cmd="add reporter CDM ${input_log}"
  send_spade_command "${cmd}"
}

exec_skype(){
  wget https://go.skype.com/skypeforlinux-64.deb
  sudo apt install ./skypeforlinux-64.deb
}

main()
{
  clear_spade_cfg
  "${spade_bin}" start
  sleep 2
  send_spade_command "add repoter Quickstep"
  exec_skype
  send_spade_command "remove reporter Quickstep"
  "${spade_bin}" stop
}


main
