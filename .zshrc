if [[ ! -e ~/.antigen ]];then
  mkdir ~/.antigen&&curl -L git.io/antigen > ~/.antigen/antigen.zsh
fi
source ~/.antigen/antigen.zsh
antigen bundle git
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen apply

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt notify
bindkey -e
# End of lines configured by zsh-newuser-install

# Fix Keys
bindkey "\e[2~"   overwrite-mode
bindkey "\e[3~"   delete-char
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Alias&Functions
alias vim="nvim"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1

#Fix Env
export GPG_TTY=$(tty)
export EDITOR=nvim
export VISUAL="$EDITOR"

# Fix Paths
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
function _g_i_t_(){
  if [ -d .git ]; then
    echo -n "["$(git status --porcelain|grep "??"|wc -l)
    git diff --stat|tail -n 1|sed 's/[^0-9]*/ /g'|awk '{print"%F{cyan}"$1"%f%F{green}"$2"%F{red}"$3"%f]"}'
  fi
}
setopt PROMPT_SUBST

PROMPT='%F{blue}%n@%m%f%F{cyan}$(loc)%f%F{white}~%f'
RPROMPT='[%F{yellow}%?%f]$(_g_i_t_)'
