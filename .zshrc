# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\e[3~" delete-char

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

fpath=( ~/.zprompts ${fpath[@]} )
autoload k
autoload s

alias ne="cd /etc/nginx && sudo nvim nginx.conf"
alias nr="systemctl restart nginx"
alias vim="nvim"

function loc() {
  echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}


setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{cyan}$(loc) %f'
RPROMPT='[%F{yellow}%?%f]'



source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
