if ! type "antibody" > /dev/null; then
  curl -sfL git.io/antibody |sudo sh -s - -b /usr/local/bin
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
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1

# Alias&Functions
alias vim="nvim"

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
    echo -n "["$(git status --porcelain|grep "??"|wc -l)
    git diff --stat|tail -n 1|sed 's/[^0-9]*/ /g'|awk '{print"%F{cyan}"$1"%f%F{green}"$2"%F{red}"$3"%f]"}'
  fi
}
setopt PROMPT_SUBST

PROMPT='%F{blue}%n@%m%f%F{cyan}$(loc)%f%F{white}~%f'
RPROMPT='[%F{yellow}%?%f]$(_GIT_)'
