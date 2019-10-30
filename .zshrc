if ! type "antibody" > /dev/null; then
  curl -sfL git.io/antibody|sudo sh -s - -b /usr/local/bin
fi

source <(antibody init)

antibody bundle zsh-users/zsh-history-substring-search
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle zsh-users/zsh-completions

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt notify
bindkey -e

# Set Keyboard Shortcuts
# Use 'showkey -a' and fix if there are any issue with these keys
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

# Alias&Functions
alias vim="nvim"
alias ls="ls --color=tty"
alias grep="grep --color=auto"

# Set Environment Variables
export GPG_TTY=$(tty)
export EDITOR=nvim
export VISUAL="$EDITOR"

# Set Paths
# NPM path
export PATH=$HOME/.npm-packages/bin:$PATH
# Go Lang Path
export GOPATH=$HOME/.go

# Prompt is set here
# This makes the location kinda like the one in fish shell
function loc() {
  echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}
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
setopt PROMPT_SUBST

PROMPT='%F{018}%K{150}%n@%M~$(loc)%k%f%F{150}%B❱➤%b%f '
RPROMPT='[%F{yellow}%?%f]$(_GIT_)'
