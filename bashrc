# johndrinkwater.name bashrc; nothing special, hope it breaks nothing if you try it

# 2015-06-06 configure our XDG locations (avoiding having .pam_environment as extra file, + .profile sources this)
export   XDG_DATA_HOME="${HOME}/settings/data"
export XDG_CONFIG_HOME="${HOME}/settings/config"
export  XDG_CACHE_HOME="${HOME}/settings/cache"
export  XDG_STATE_HOME="${HOME}/settings/state"
export XDG_RUNTIME_DIR="${HOME}/settings/.runtime"
export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME}/nv"
# 2017-10-11 consider disabling disk cache for these
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv/ComputeCache"

# 2018-10-09 add to PATH, remove previous entries. Fails for rightmost dir, but thats ok ¯\_(ツ)_/¯
function pathprepend () {
	PATH=$1:${PATH//$1:/}
}
# 2012-07-02 added for android
pathprepend "${HOME}/code/android-sdk/tools"
pathprepend "${HOME}/code/android-sdk/platform-tools"
# Allow access to our home-local binaries
pathprepend "${HOME}/bin"

# 2015-06-26 remind our system we are British
LANGUAGE=en_GB:en
LANG=en_GB.UTF-8

# 2015-06-09 Adjust our vim config into XDG locations
export VIM="${XDG_CONFIG_HOME}/vim"
# 2015-06-17 setting VIM kinda breaks things (syntax, gvim settings) and even though we set runtime
# in vimrc, it will still look for VIM/vim{version} to make VIMRUNTIME. You need to run
# `ln -s /usr/share/vim/vim74 vim74` inside ${XDG_CONFIG_HOME}/vim for which version your vim is
export VIMINIT=":so ${VIM}/vimrc"

# Runtime cruft
export ICEAUTHORITY="${XDG_RUNTIME_DIR}/ICEauthority"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
if [ -e "${HOME}/.Xauthority" ]
then
	mv -f "${HOME}/.Xauthority" "${XAUTHORITY}" &> /dev/null
fi

# 2015-06-24 too late to avoid ~/.xsession-errors, so we edit /etc/X11/Xsession:61 to be
# ERRFILE=$HOME/settings/cache/xsession-errors

# apps that are a pain in the butt
export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/gimp"
export MPLAYER_HOME="${XDG_CONFIG_HOME}/mplayer"
export LYNX_CFG="${XDG_CONFIG_HOME}/lynx/config"
export DVDCSS_CACHE="${XDG_CONFIG_HOME}/dvdcss"
export TASKRC="${XDG_CONFIG_HOME}/task/config"
export WINEPREFIX="${XDG_DATA_HOME}/wine"

# repo tools
export SUBVERSION_HOME="${XDG_CONFIG_HOME}/subversion"
export BZR_LOG="${XDG_STATE_HOME}/bazaar/log"

# Rust, unfortunately doesn’t have cleanly organised tree, everything → DATA
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
pathprepend "${CARGO_HOME}/bin"

# crown jewels
export GNUPGHOME="${HOME}/settings/keys"
export PASSWORD_STORE_DIR="${HOME}/settings/pass"

# let us try some user-based hostname config
export HOSTFILE="${XDG_CONFIG_HOME}/bash/extrahosts"

# bash files
export HISTFILE="${XDG_CONFIG_HOME}/bash/history"

# 2016-02-24 Tell Python politely to not make ~/.python_history by… monkey patching that code out
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/python_history"
alias pip="pip --log=${XDG_STATE_HOME}/pip/pip.log"

# 2016-01-02 attempt to restore unicode composition via ctrl+shift+u
unset GTK_IM_MODULE
unset QT4_IM_MODULE

# 2015-06-10 relocate our ssh config into our XDG location
SSH_HOME="${XDG_CONFIG_HOME}/ssh"
if [ -s "${SSH_HOME}/config" ]
then
	SSH_CONFIG="-F ${SSH_HOME}/config"
	export GIT_SSH_COMMAND="ssh ${SSH_CONFIG} "
	alias ssh="ssh ${SSH_CONFIG}"
fi
if [ -s "${SSH_HOME}/${HOSTNAME}_rsa" ]
then
	SSH_ID="-i ${SSH_HOME}/${HOSTNAME}_rsa"
	alias ssh-copy-id="ssh-copy-id ${SSH_ID}"
fi
# 2015-06-29 provide a function to run our agent and hook common keys
SSH_AGENT="${SSH_HOME}/environment"
function start_agent {
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_AGENT}"
	chmod 600 "${SSH_AGENT}"
	source "${SSH_AGENT}" > /dev/null
	# these two lines will prompt for passphrase in the first term after system restart
	/usr/bin/ssh-add "${SSH_HOME}/${HOSTNAME}_rsa"
	/usr/bin/ssh-add "${SSH_HOME}/${HOSTNAME}_github"
}

# 2015-06-26 for bootstrapping keyless new systems, have an alias
alias sshfp="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"

# 2015-06-23 move our ~/.gdbinit to XDG location
alias gdb="gdb -nh -x ~/settings/config/gdb/gdbinit"

# 2018-11-16 move our ~/.wget-hsts to XDG location
alias wget="wget --hsts-file=~/settings/config/wget/wget-hsts"

# 2016-01-31 move our ~/.java to a XDG location (or rather attempt)
alias java="java -Duser.home=\"${XDG_DATA_HOME}/openjdk\""

# 2014-08-07 over a year later, putting these in bashrc…
# yes Steam, really close to tray when I am done with you
export STEAM_FRAME_FORCE_CLOSE=1
# SDL2, stop minimising when I alt‐tab, I have multimon you know!
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
# SDL2, pick /this/ monitor as default please (not sure this works?)
export SDL_VIDEO_FULLSCREEN_DISPLAY=1

# 2014-08-07 My custom DS4 mapping (stop using share for start!)
export SDL_GAMECONTROLLERCONFIG="030000004c050000c405000011010000,Sony DualShock 4,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,leftstick:b10,rightstick:b11,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a5,lefttrigger:b6,righttrigger:b7,back:b13,"

# 2017-11-15 move our ~/.scummvmrc to XDG location, and relocate save files
alias scummvm="scummvm --config=~/settings/config/scummvm/config --savepath=~/settings/data/scummvm"

# make sure that PATH is exported before script ends
export PATH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# 2015-07-27 list files to pass to apps (vlc)
function lq { ls -Q1 "$@" | tr "\n" " " ; }

# 2014-07-01 make sure to retain all history, because we have >1 shell from http://ss64.com/bash/shopt.html
# 2018-10-17 put pwd into title, help disambiguate multiple windows
export PROMPT_COMMAND='history -a; echo -ne "\033]0;$(hostname -s):${PWD/$HOME/\~}\007"'

# 2018-10-17 look into `readonly` builtin for some envvars

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %H:%M≀%S "
# don't put duplicate lines in the history. See bash(1) for more options
# 2018-10-17 force erasure of previous duplicates (ignoredups only looks at last command run)
export HISTCONTROL=ignoredups:ignorespace:erasedups
# append to the history file, don't overwrite it
shopt -s histappend

# 2018-10-06 git tui interfaces don’t obey pager (obviously), set our tabs in term
# advice sought from https://stackoverflow.com/a/20453925/611349
TABWIDTH=4
tabs -${TABWIDTH}
tabs 1$(for i in {0..40}; do echo -n ",+${TABWIDTH}"; done)

# 2015-06-09 ask our pager not to make ~/.lesshst
export LESSHISTFILE="-"
# 2018-10-28 git pager usage was breaking on emoji, reread manual and this needed to be _r_
export LESS="-iFrSX"

# 2018-11-16 ask openssl not to put ~/.rnd in ~
export RANDFILE="${XDG_RUNTIME_DIR}/opensslrandomness"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# 2015-08-05 restrict terminal support for ^S so I stop accidentally breaking
# irssi inside tmux
stty -ixon
stty -ixoff
stty stop undef

# 2018-11-07 Inform tty input chars are UTF-8 encoded (why is this still not default?)
stty iutf8

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"



# TODO make the following settings/config/bash use a variable?
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/settings/config/bash/dircolours && eval "$(dircolors -b ~/settings/config/bash/dircolours)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# 2015-06-09 coloured GCC warnings and errors (pulled from latest default Ubuntu bashrc)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands. Use like so: `sleep 10; alert`
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -s ~/settings/config/bash/aliases ]; then
	source ~/settings/config/bash/aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -s /etc/bash_completion ] && ! shopt -oq posix; then
	source /etc/bash_completion
fi

# 2010-09-09 johndrinkwater.name from http://log.damog.net/2008/12/two-git-tips/ &
# others, see ~/Notes/Fedora/StandardChanges
if [ -s /etc/bash_completion.d/git ]; then
	source /etc/bash_completion.d/git
fi

# 2014-07-01 OSX doesn't have, so we sources from brew
if [ -d /usr/local/etc/bash_completion.d ]; then
	source /usr/local/etc/bash_completion.d/git-completion.bash
	source /usr/local/etc/bash_completion.d/git-prompt.sh
fi

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
# 2009-01-20 from http://log.damog.net/2008/12/two-git-tips
export GITPS1='$(__git_ps1 "±:%s")'

# 2011-02-10 http://stackoverflow.com/questions/4133904/ps1-line-with-git-current-branch-and-colors escape with []
# 2013-09-08 s/>/❯/g
export PS1="\[\e[2;92m\]\u\[\e[m\]\[\e[1m\]\[\e[2;37m\]@\[\e[m\]\[\e[1m\]\h\[\e[m\] \[\e[1;34m\]\w\[\e[0m\] \[\e[0;36m\]${GITPS1}\[\e[m\]❯ "

# vim is our <3
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

###### ALIASES
# 2009-01-27 johndrinkwater.name i’ve had ls have long-iso style for a while
# 2014-06-08 tweaked further, put dirs first, combine with above
# 2018-10-09 emit full multibyte characters to the terminal; could break some scripts, but prefer uniform output between ls + ls |
alias ls='ls -F --time-style=long-iso --color=always --group-directories-first --show-control-chars '
alias ll='ls -o --si'
alias la='ls -oA --si'
alias lal='la -L'
alias l='ls -C'
# interactive destruction
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias crontab='crontab -i'
# 2015-07-21 always make all dirs
alias mkdir='mkdir -p'
# 2015-06-07 Remove redundant /run, /dev/shm, /run/lock, /sys/fs/cgroup, /run/cmanager/fs, /run/user/%uid from df listing
# 2016-05-24 /dev is apparently devtmpfs, even though `stat -f /dev` returns… tmpfs https://bugs.launchpad.net/ubuntu/+source/coreutils/+bug/1219529
# 2018-10-28 Hide snap mounts, that are using squashfs
alias df='df -Hx tmpfs -x devtmpfs -x squashfs'
# 2015-06-08 Do the same with mount, hide ~30 lines o crap
# 2018-10-28 Update for newer systems, hide ~35 lines o crap
alias mount='mount -t notmpfs,nocgroup,nocgroup2,noconfigfs,nobinfmt_misc,nodebugfs,nosquashfs,nomqueue,nopstore,nosecurityfs,nohugetlbfs,nofusectl,nodevpts,nodevtmpfs,nofuse.gvfsd-fuse,nofuse.gvfs-fuse-daemon,noautofs,nosysfs,noproc'
# 2016-02-08 … and prevent spurious warnings from lsof due to gvfs + tracefs (RUNTIME for sudo, tracing for user)
# 2016-02-19 this causes noise in `script`, so disable for now
# alias lsof='lsof -e $XDG_RUNTIME_DIR/gvfs -e /sys/kernel/debug/tracing'
# lazy fingers
alias j='jobs'
alias h='history'
# development shortcuts, would prefer python default, but steamlug.org has made php return :<
# alias httpdhere="python -m SimpleHTTPServer"
alias httpdhere="php -S localhost:4000 &"
alias httpdhereheadless="php -S localhost:4000 > httpd.log 2> httpd.err < /dev/null &"

# 2015-08-17 wanting to make `script` output cleaner, so unset EDITOR
if [ $SHLVL -gt 1 ]; then
	if lsof -tac script "$(tty)" > /dev/null; then
		unset EDITOR
		unset VISUAL
	fi
fi

case "$(uname -s)" in

	Darwin)
	# 2015-05-19 on OSX, don't forget to set your `homebrew` token for github
	export HOMEBREW_GITHUB_API_TOKEN=

	# 2015-05-19 add homebrew to our PATH, for OSX
	# brew --prefix coreutils
	pathprepend "/usr/local/opt/coreutils/libexec/gnubin"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

	# 2015-05-20 add find to PATH; hope I don't have to do this for each util
	pathprepend "/usr/local/opt/findutils/bin"

	# 2015-05-26 put usr local binaries before system ones to expose brew
	pathprepend "/usr/local/bin:/usr/local/sbin"

	# 2015-05-30 expose php bins, like phpdoc
	# brew --prefix php54
	pathprepend "/usr/local/opt/php54/bin"
	export PATH

	;;
	Linux)

	# If set, the pattern "**" used in a pathname expansion context will
	# match all files and zero or more directories and subdirectories.
	shopt -s globstar

	# 2014-10-24 finally put my custom tweaks into my own keymap
	setxkbmap -I ~/.xkb john

	;;
	*)
	echo "oops, unmatched platform"
	;;
esac

# 2015-06-29 ssh-agent block, run late
if [ -s "${SSH_AGENT}" ]; then
	source "${SSH_AGENT}" > /dev/null
	ps -o pid= -p ${SSH_AGENT_PID} > /dev/null || {
		start_agent;
	}
else
	start_agent;
fi

#2014-10-25 stop the overlay gtk message noise (note for commit, was in ~/.profile on joran??)
export LIBOVERLAY_SCROLLBAR=0

