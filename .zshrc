ANTI_LOC="${HOME}/.cache/antidote/"
if [ ! -d "$ANTI_LOC" ];then
  mkdir -p "$ANTI_LOC"
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTI_LOC"
fi
source "${ANTI_LOC}antidote.zsh"
antidote bundle <~/.zsh_plugins.txt >~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

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
alias ls="ls --color=tty --group-directories-first "
alias grep="grep --color=auto"
# just add the state you want to check execute like this [ssmonit ESTABLISHED]
alias ssm="watch -n 1 \"ss -tuap state \""
alias trn="tr ' ' '\n'"
# Set Environment Variables

export GPG_TTY=$(tty)

export EDITOR=nvim
export VISUAL="$EDITOR"

# Prompt is set here
# This makes the numbers with modified & untracked files & code insertions & code deletions
function _GIT_(){
  if [ -d .git ]; then
    local branch=`git branch --show-current`
    local gstatus=`git status --porcelain`
    local shortstat=`git diff --shortstat`
    local modified=`echo "$gstatus" | grep -E "^ A|\?\?|^ M" | wc -l`
    local deleted=`echo "$gstatus" | grep "^ D" | wc -l`
    local inserts=`echo "$shortstat" |sed -n 's/.* \([0-9]\+\) insertion.*/\1/p'`
    local deletes=`echo "$shortstat" |sed -n 's/.* \([0-9]\+\) deletion.*/\1/p'`
    local git_status=""
    git_status+="[%F{cyan}$branch%f]"
    if (( ${modified:=0} > 0 || ${deleted:=0} > 0 )); then
      git_status+="F:[%F{green}$modified%F{red}$deleted%f]"
    fi
    if (( ${inserts:=0} > 0 || ${deletes:=0} > 0 )); then
      git_status+="T:[%F{green}$inserts%F{red}$deletes%f]"
    fi
    echo "${git_status}"
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
    timer_output=$(printf "[%02d:%02d:%02d]" $((($timer/(1000*60*60)))) $(((($timer/(1000*60)))%60)) $((($timer/1000)%60)))
    unset time_start
  fi
}
setopt PROMPT_SUBST

PROMPT='[%F{yellow}%?%f]${timer_output}$(_GIT_)[%n@%M][%B%~]
'
