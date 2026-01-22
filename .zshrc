# --- 1. Plugin Management (Antidote) ---
ANTI_LOC="${HOME}/.cache/antidote/"
if [ ! -d "$ANTI_LOC" ];then
  mkdir -p "$ANTI_LOC"
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTI_LOC"
fi
source "${ANTI_LOC}antidote.zsh"
antidote bundle <~/.config/zsh/plugins.txt >~/.config/zsh/plugins.zsh

# --- 2. Completion System ---
autoload -U compinit
compinit -d ~/.zshdump

source ~/.config/zsh/plugins.zsh

# --- 3. History Settings ---
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt notify

# --- 4. FZF Configuration ---
source <(fzf --zsh)

autoload -U down-line-or-beginning-search
autoload -U up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N up-line-or-beginning-search

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle      -N      fzf-history-widget-accept
bindkey '^P'     fzf-history-widget-accept

bindkey '^[[A' fzf-history-widget
bindkey '^[[B' down-line-or-beginning-search

bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

bindkey "^?" backward-delete-char

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# --- 5. Environment & Aliases ---
export GPG_TTY=$(tty)
export EDITOR=nvim
export VISUAL="$EDITOR"

alias vim="nvim"
alias ls="ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias ssm="watch -n 1 \"ss -tuap state \""
alias trn="tr ' ' '\n'"

# --- 6. Prompt & Functions ---
function _GIT_(){
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    [[ -z "$branch" ]] && return

    local gstatus=$(git status --porcelain 2>/dev/null)
    local shortstat=$(git diff --shortstat 2>/dev/null)

    local modified=$(echo "$gstatus" | grep -E "^ A|\?\?|^ M" | wc -l)
    local deleted=$(echo "$gstatus" | grep "^ D" | wc -l)
    local inserts=$(echo "$shortstat" | sed -n 's/.* \([0-9]\+\) insertion.*/\1/p')
    local deletes=$(echo "$shortstat" | sed -n 's/.* \([0-9]\+\) deletion.*/\1/p')

    local git_status="[%F{cyan}$branch%f]"

    if (( ${modified:=0} > 0 || ${deleted:=0} > 0 )); then
      git_status+="F:[%F{green}$modified%F{red}$deleted%f]"
    fi
    if (( ${inserts:=0} > 0 || ${deletes:=0} > 0 )); then
      git_status+="T:[%F{green}$inserts%F{red}$deletes%f]"
    fi
    echo "${git_status}"
  fi
}

function preexec() {
  time_start=$(date +%s%3N)
}

function precmd() {
  timer_output=""
  if [ -n "$time_start" ]; then
    local now=$(date +%s%3N)
    local timer=$((now - time_start))
    if (( timer > 100 )); then
      local formatted_time=$(printf "%02d:%02d:%02d" $((timer/(1000*60*60))) $(( (timer/(1000*60))%60 )) $(( (timer/1000)%60 )))
      timer_output="[%F{yellow}${formatted_time}%f]"
    fi
    unset time_start
  fi
}

setopt PROMPT_SUBST
PROMPT='[%F{yellow}%?%f]${timer_output}$(_GIT_)[%n@%M][%B%~]
'
