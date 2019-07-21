#!/bin/bash

# capture vars
me=$0;p=$1;h=`hostname`

# options
repo="iamninja"

# sub options-usually leave alone
app_desc="host-config (>hc)"
app="/usr/local/bin/hc"
hcwd="~/.host-config"
working="${hcwd}/${h}"
ed="$EDITOR"
[[ ! -s $ed ]] && ed=`which nano`

# colors
clr='\e[0m'; inv='\e[7m'


# verify git installed
git --version 2>&1 >/dev/null
if [ ! $? -eq 0 ];then
  echo "!!! [$app_desc] stopped, git required for use."
  exit 1
fi

msg(){ 
  echo -e "$inv$1$clr" 
}
msg "Starting ops for ${app_desc}"

info_hc() {
    msg "INFO: ${app_desc}"
    msg "app: $app"
    msg "p1: $p"
    msg "clone: $repo"
    msg "working: $working"
    msg "editor: $ed"
}

inst_bin() {
    msg "installing...\n\t${app_desc}...\n\t\tplease waqit..."
	echo "sudo cp $me $app"
	echo "sudo chmod +x $app"
    [[ ! -s $app ]] && msg "!!! [${app_desc}] binary not installed."
}

clone_hc() {
	msg "cloning from: $repo to: ${hcwd}"
	echo "git clone $repo ${hcwd} && mkdir ${working}"
	[[ ! -d $hcwd ]] && echo "Host config repo not cloned !!!"
}

implode_hc() {
    echo "uninstalling [${app_desc}]"
	sudo rm -rf ${hcwd}
	sudo rm -f ${app}
}

[[ ! -s $app ]] && inst_bin
[[ ! -d $hcd ]] && clone_hc

[[ -d ${working} ]] && cd ${working}
[[ "$p" == "-e" ]] && msg "editing..." && ${ed} *
[[ "$p" == "-l" ]] && msg "listing files..." && ls -ltr
[[ "$p" == "-i" ]] && info_hc

# final stuff
info_hc
msg "use: command -eli"
msg "[${app_desc}] process complete."
