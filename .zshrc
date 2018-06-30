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

# key bindings

bindkey '\e[1~'   beginning-of-line  # Linux console
bindkey '\e[H'    beginning-of-line  # xterm
bindkey '\eOH'    beginning-of-line  # gnome-terminal
bindkey '\e[2~'   overwrite-mode     # Linux console, xterm, gnome-terminal
bindkey '\e[3~'   delete-char        # Linux console, xterm, gnome-terminal
bindkey '\e[4~'   end-of-line        # Linux console
bindkey '\e[F'    end-of-line        # xterm
bindkey '\eOF'    end-of-line        # gnome-terminal



fpath=( ~/.zprompts ${fpath[@]} )
autoload k s fr

alias ne="cd /etc/nginx && sudo nvim nginx.conf"
alias nr="systemctl restart nginx"
alias vim="nvim"
alias steam.exe="wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe > /dev/null 2>&1 &"

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
