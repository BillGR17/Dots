# pacman -S zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh


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

#Key
bindkey "\e[2~"   overwrite-mode
bindkey "\e[3~"   delete-char
bindkey "\e[H"    beginning-of-line
bindkey "\e[F"    end-of-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
#Alias&Functions
alias nr="sudosystemctl restart nginx"

#https://github.com/jwilm/alacritty/issues/684
#meh
alias vim="env TERM="" nvim"
alias nvim="env TERM="" nvim"

alias npm="yarn"

fpath=( ~/.zshf "${fpath[@]}" )
autoload k conf fr

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1


#yarn global modules doesnt work without yarn path
export PATH=$PATH:$(yarn global bin)
xset s off&&xset -dpms

#prompt settings
function loc() {
  echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}
setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{cyan}$(loc) %f'
RPROMPT='[%F{yellow}%?%f]'
