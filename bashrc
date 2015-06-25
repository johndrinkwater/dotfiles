# johndrinkwater.name bashrc; nothing special, hope it breaks nothing if you try it

# 2015-06-06 configure our XDG locations (avoiding having .pam_environment as extra file, + .profile sources this)
export   XDG_DATA_HOME="${HOME}/settings/data"
export XDG_CONFIG_HOME="${HOME}/settings/config"
export  XDG_CACHE_HOME="${HOME}/settings/cache"
export  XDG_STATE_HOME="${HOME}/settings/state"
export XDG_RUNTIME_DIR="${HOME}/settings/.runtime"
export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME}/nv"

# 2015-06-09 Adjust our vim config into XDG locations
export VIM="${XDG_CONFIG_HOME}/vim"
# 2015-06-17 setting VIM kinda breaks things (syntax, gvim settings) and even though we set runtime
# in vimrc, it will still look for VIM/vim{version} to make VIMRUNTIME. You need to run
# `ln -s /usr/share/vim/vim74 vim74` inside ${XDG_CONFIG_HOME}/vim for which version your vim is
export VIMINIT=":so ${XDG_CONFIG_HOME}/vim/vimrc"

# Runtime cruft
export ICEAUTHORITY="${XDG_RUNTIME_DIR}/ICEauthority"

# apps that are a pain in the butt
export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/gimp"
export LYNX_CFG="${XDG_CONFIG_HOME}/lynx/config"
export DVDCSS_CACHE="${XDG_CONFIG_HOME}/dvdcss"

# repo tools
export SUBVERSION_HOME="${XDG_CONFIG_HOME}/subversion"
export BZRPATH="${XDG_CONFIG_HOME}/bazaar"
export BZR_PLUGIN_PATH="${XDG_DATA_HOME}/bazaar"
export BZR_HOME="${XDG_CACHE_HOME}/bazaar"

# crown jewels
export GNUPGHOME="${HOME}/settings/keys"

# bash files
export HISTFILE="${XDG_CONFIG_HOME}/bash/history"

# 2015-08-10 relocate our ssh config into our XDG location
if [ -s "${XDG_CONFIG_HOME}/ssh/config" ]
then
	SSH_CONFIG="-F ${XDG_CONFIG_HOME}/ssh/config"
	export GIT_SSH_COMMAND="ssh ${SSH_CONFIG} "
	alias ssh="ssh ${SSH_CONFIG}"
fi
if [ -s "${XDG_CONFIG_HOME}/ssh/${HOSTNAME}_rsa" ]
then
	SSH_ID="-i ${XDG_CONFIG_HOME}/ssh/${HOSTNAME}_rsa"
	alias ssh-copy-id="ssh-copy-id ${SSH_ID}"
fi

# 2015-06-23 move our ~/.gdbinit to XDG location
alias gdb="gdb -nh -x ~/settings/config/gdb/gdbinit"

# 2014-08-07 over a year later, putting these in bashrc…
# yes Steam, really close to tray when I am done with you
export STEAM_FRAME_FORCE_CLOSE=1
# SDL2, stop minimising when I alt‐tab, I have multimon you know!
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
# SDL2, pick /this/ monitor as default please (not sure this works?)
export SDL_VIDEO_FULLSCREEN_DISPLAY=1

# 2014-08-07 My custom DS4 mapping (stop using share for start!)
export SDL_GAMECONTROLLERCONFIG="030000004c050000c405000011010000,Sony DualShock 4,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,leftstick:b10,rightstick:b11,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a5,lefttrigger:b6,righttrigger:b7,back:b13,"


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# 2014-07-01 make sure to retain all history, because we have >1 shell from http://ss64.com/bash/shopt.html
export PROMPT_COMMAND="history -a"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %H:%M≀%S "
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoredups:ignorespace
# append to the history file, don't overwrite it
shopt -s histappend

# 2015-06-09 ask our pager not to make ~/.lesshst
export LESSHISTFILE="-"
export LESS="-iFRSX"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
	;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi

# 2010-09-09 johndrinkwater.name from http://log.damog.net/2008/12/two-git-tips/ &
# others, see ~/Notes/Fedora/StandardChanges
if [ -f /etc/bash_completion.d/git ]; then
	source /etc/bash_completion.d/git
fi

# 2014-07-01 OSX doesn't have, so we sources from brew
if [ -d /usr/local/etc/bash_completion.d ]; then
	source /usr/local/etc/bash_completion.d/git-completion.bash
	source /usr/local/etc/bash_completion.d/git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
GITPS1='$(__git_ps1 "±:%s")'

# 2011-02-10 http://stackoverflow.com/questions/4133904/ps1-line-with-git-current-branch-and-colors escape with []
# 2013-09-08 s/>/❯/g
export PS1="\[\e[0;32m\]\u\[\e[m\]@\h \w \[\e[0;36m\]${GITPS1}\[\e[m\]❯ "

# vim is our <3
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

###### ALIASES
# 2009-01-27 johndrinkwater.name i’ve had ls have long-iso style for a while
# 2014-06-08 tweaked further, put dirs first, combine with above
alias ls='ls -F --time-style=long-iso --color=tty --group-directories-first'
alias ll='ls -o --si'
alias la='ls -oA --si'
alias l='ls -C'
# interactive destruction
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
# 2015-06-07 Tell whomever thought listing /run, /dev/shm, /run/lock, /sys/fs/cgroup, /run/cmanager/fs, /run/user/%uid to go fuck themselves
alias df='df -Hx tmpfs'
# 2015-06-08 Do the same with mount, hide crap ~30 lines o crap
alias mount='mount -t notmpfs,nocgroup,nodebugfs,nomqueue,nopstore,nosecurityfs,nohugetlbfs,nofusectl,nodevpts,nodevtmpfs,nofuse.gvfsd-fuse,noautofs,nosysfs,noproc'

# 2012-07-02 added for android
export PATH="${PATH}:${HOME}/bin:${HOME}/code/android-sdk/platform-tools:${HOME}/code/android-sdk/tools"

case "$(uname -s)" in

	Darwin)
	# 2015-05-19 on OSX, don't forget to set your `homebrew` token for github
	export HOMEBREW_GITHUB_API_TOKEN=

	# 2015-05-19 add homebrew to our PATH, for OSX
	export PATH="$(brew --prefix coreutils)/libexec/gnubin:${PATH}"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

	# 2015-05-20 add find to PATH; hope I don't have to do this for each util
	export PATH="/usr/local/opt/findutils/bin:${PATH}"

	# 2015-05-26 put usr local binaries before system ones to expose brew
	export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"

	# 2015-05-30 expose php bins, like phpdoc
	export PATH="$(brew --prefix php54)/bin:${PATH}"

	;;
	Linux)
	# 2014-10-24 finally put my custom tweaks into my own keymap
	setxkbmap -I ~/.xkb john

	;;
	*)
	echo "oops, unmatched platform"
	;;
esac

#2014-10-25 stop the overlay gtk message noise (note for commit, was in ~/.profile on joran??)
export LIBOVERLAY_SCROLLBAR=0

