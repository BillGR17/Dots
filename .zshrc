# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/awesomename/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\e[3~" delete-char

alias ne="cd /etc/nginx && sudo nvim nginx.conf"
alias nr="systemctl restart nginx"

#https://github.com/jwilm/alacritty/issues/684
#meh
alias vim="env TERM="" nvim"
alias nvim="env TERM="" nvim"

alias npm="yarn"

#fpath=( ~/.zfunc $fpath )
fpath=( ~/.zfuncs "${fpath[@]}" )
autoload k s fr

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1

function loc() {
  echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}

#yarn global modules doesnt work without yarn path
export PATH=$PATH:$(yarn global bin)

setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{cyan}$(loc) %f'
RPROMPT='[%F{yellow}%?%f]'

# pacman -S zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
