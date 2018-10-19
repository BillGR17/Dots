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

# Fix Paths
# Yarn Path
export PATH=$PATH:$(yarn global bin)
# Go Lang Path
export GOPATH=$HOME/.go

# Prompt is set here
# This makes the location kinda like the one in fish shell
function loc() {
  echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}
# This makes the numbers with modified & untracked files & code insertions & code deletions
function _g_i_t_(){
  IFS=$'\n' # Array split is breakline instead of space
  if [ -d .git ]; then
    out+=$(git status --porcelain|grep "??"|wc -l) #get all Untracked files
    for i in $(git diff --stat|awk 'END{print}'|tr "," "\n"); do
      case $i in
        (*"file"*) out+="%F{cyan}$(echo $i| sed 's/[^0-9]*//g')%f";;
        (*"+"*) out+="%F{green}$(echo $i| sed 's/[^0-9]*//g')%f";;
        (*"-"*) out+="%F{red}$(echo $i| sed 's/[^0-9]*//g')%f";;
      esac
    done
    echo "[$out]"
  fi
	unset out #No longer needed
  unset IFS
}
setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f%F{cyan}$(loc)%f%F{white}~%f'
RPROMPT='[%F{yellow}%?%f]$(_g_i_t_)'
