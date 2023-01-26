[ -d /tmp/zsh-1000/ ] && rm -rf /tmp/zsh-1000/* 2> /dev/null
ZPM_LOC="$HOME/.cache/zpm_data/"
if [[ ! -f "${ZPM_LOC}zpm.zsh" ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm $ZPM_LOC
fi
source "${ZPM_LOC}zpm.zsh"
zpm load zsh-users/zsh-history-substring-search
zpm load zsh-users/zsh-autosuggestions
zpm load zsh-users/zsh-syntax-highlighting
zpm load zsh-users/zsh-completions

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt notify
bindkey -e

# Set Keyboard Shortcuts
# Use 'showkey -a' if there is any issue with these keys
bindkey "^[[2~"   overwrite-mode
bindkey "^[[3~"   delete-char
bindkey "^[[1~"   beginning-of-line
bindkey "^[[4~"   end-of-line
bindkey "^[[A"    history-substring-search-up
bindkey "^[[B"    history-substring-search-down

# Auto suggestions
autoload -U compinit && compinit
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*:commands" rehash 1

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Alias & Functions
alias vim="nvim"
alias n="nnn -adHUioRu"
alias ls="ls --color=tty --group-directories-first "
alias grep="grep --color=auto"
# just add the state you want to check execute like this [ssmonit ESTABLISHED]
alias ssm="watch -n 1 \"ss -tuap state \""
alias psme="ps -fH -u $(whoami)"
alias trn="tr ' ' '\n'"
if command -v pacman &> /dev/null;then alias rem_orphans="PAC_ORP='$(pacman -Qdtq)';if [ -n '$PAC_ORP' ];then sudo pacman -Rsc '$PAC_ORP';else echo 'No Orphans'; fi"; fi
# Set Environment Variables
# To fix git gpg
export GPG_TTY=$(tty)
# To set nvim as default editor
export EDITOR=nvim
export VISUAL="$EDITOR"
# nnn config
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
export NNN_PLUG="p:preview-tui"
# Set Paths
# NPM path
export PATH=$HOME/.npm/packages/bin:$PATH
# Go Lang Path
export GOPATH=$HOME/.go

# Prompt is set here
# This makes the numbers with modified & untracked files & code insertions & code deletions
function _GIT_(){
  if [ -d .git ]; then
    echo -n "["
    echo -n "%F{cyan}"$(git branch 2> /dev/null|sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' -e 's/[a-z]/\U&/g')"%f"
    echo -n $(git status --porcelain|grep "??"|wc -l)
    echo -n $(git diff --stat|tail -n 1|sed 's/[^0-9]*/ /g'|awk '{print"%F{cyan}"$1"%f%F{green}"$2"%F{red}"$3"%f"}')
    echo -n "]"
  fi
}
# pre execution function
function preexec() {
  time_start=$(date +%s%3N)
}
# after command ends function
# count how long it took to execute
function precmd() {
  if [ $time_start ]; then
    local timer=$(($(date +%s%3N)-$time_start))
    timer_output=$(printf "%02d:%02d:%02d" $((($timer/(1000*60*60)))) $(((($timer/(1000*60)))%60)) $((($timer/1000)%60)))
    unset time_start
  fi
}

setopt PROMPT_SUBST

PROMPT='%F{236}%K{012}%n@%M%B%~ %f%b%k%f%B%F{012}%f%b '
RPROMPT='$(_GIT_)${timer_output}[%F{yellow}%?%f]'
