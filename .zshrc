# git clone https://github.com/zplug/zplug .zplug
source ~/.zplug/init.zsh

zplug zsh-users/zsh-history-substring-search
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-syntax-highlighting
zplug zsh-users/zsh-completions

zplug load

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
  echo -n ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}
function _g_i_t_(){
  IFS=$'\n'
  if [ -d .git ]; then
    for i in $(git diff --stat|awk 'END{print}'|tr "," "\n"); do
      case $i in
        (*"file"*) _f=$(echo $i| sed 's/[^0-9]*//g') ;;
        (*"+"*) _in=$(echo $i| sed 's/[^0-9]*//g') ;;
        (*"-"*) _d=$(echo $i| sed 's/[^0-9]*//g') ;;
      esac
    done
    _un_=$(git status --porcelain|grep "??"|wc -l)
    echo "[%F{cyan}$_f%f%F{grey}$_un_%f%F%F{green}$_in%f%F{red}$_d%f]"
  fi
  unset IFS
}
setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{cyan}$(loc) %f'
RPROMPT='[%F{yellow}%?%f]$(_g_i_t_)'
