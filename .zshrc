# mkdir ~/.zsh&&curl -L git.io/antigen > ~/.zsh/antigen.zsh
source ~/.zsh/antigen.zsh

antigen use oh-my-zsh
antigen bundle git

# Helpers
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

# Key
bindkey "\e[2~"   overwrite-mode
bindkey "\e[3~"   delete-char
bindkey "\e[H"    beginning-of-line
bindkey "\e[F"    end-of-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Alias&Functions
alias nr="sudo systemctl restart nginx"

alias vim="nvim"

alias npm="yarn"

fpath=( ~/.zshf "${fpath[@]}" )
autoload k conf fr update_root_configs

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1

# yarn global modules doesnt work without yarn path
export PATH=$PATH:$(yarn global bin)

#prompt settings
function loc() {
  echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}
setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{cyan}$(loc) %f'
RPROMPT='[%F{yellow}%?%f]'
