#!/bin/bash

# capture vars
me=$0;p=$1;h=`hostname`;inst=$2

# options - todo: autodetect reponame
repo="git://github.com/iamzenninja/host-config.git"

# sub options-usually leave alone
app_desc="host-config (>hc)"
app="/usr/local/bin/hc"
hcwd="~/.host-config"
working="${hcwd}/${h}"
ed="$EDITOR"
[[ ! -s $ed ]] && ed=`which nano`

# colors
clr='\e[0m'; inv='\e[7m'; err='\e[5m'

msg(){ 
  echo -e "$inv$1$clr" 
}

emsg() {
  echo -e "$err$1$clr"
}

# verify git installed
git --version 2>&1 >/dev/null
if [ ! $? -eq 0 ];then
  emsg "!!! [$app_desc] stopped, git required for use."
  exit 1
fi

msg "Starting ops for ${app_desc}"

info_hc() {
    msg "INFO: ${app_desc}"
    msg "app: $app"
    msg "working: $working"
    msg "editor: $ed"
    msg "p1: $p"
    msg "inst: $inst"
    msg "clone: $repo"
}

inst_bin() {
    info_hc    
    msg "installing...\n\t${app_desc}...\n\t\tplease waqit..."
    curl ${inst} | sudo tee ${app} 2>&1 >/dev/null
    sudo chmod +x $app
    [[ ! -s $app ]] && emsg "!!! [${app_desc}] binary not installed."
}

check_mrc_helper() {
  helper='alias mm="micro ~/.mrc";echo "!@#$>mmm=refresh";alias mmm=". ~/.mrc";. ~/.mrc'
  echo $helper
  [[ ! -r ~/.mrc ]] && echo "# .bashrc .zshrc: $helper" > ~/.mrc
  cat ~/.bashrc | grep '.mrc'
  [[ ! $? -eq 0 ]] && echo $helper >> ~/.bashrc
}

clone_hc() {
	msg "cloning from: $repo to: ${hcwd}"
	git clone $repo ${hcwd} && mkdir ${working}
	if [[ ! -d $hcwd ]];then
	  emsg "Host config repo not cloned !!!"
	else
	  cd ${working}
	  ln -s ~/.bashrc ./dot_bashrc
	fi
}

implode_hc() {
    echo "uninstalling [${app_desc}]"
	sudo rm -rf ${hcwd}
	sudo rm -f ${app}
}

[[ ! -s $app ]] && inst_bin
[[ ! -d $hcwd ]] && clone_hc

[[ -d ${working} ]] && cd ${working}
[[ "$p" == "-e" ]] && msg "editing..." && ${ed} *
[[ "$p" == "-l" ]] && msg "listing files..." && ls -ltr
[[ "$p" == "-i" ]] && info_hc
[[ "$p" == "-r" ]] && implode_hc
check_mrc_helper

# final stuff
msg "use: command -elir"
msg "[${app_desc}] process complete."
