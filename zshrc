export CLICOLOR=1
export PROMPT='%B%F{green}%m%f:%F{magenta}%~%f%b %# '

precmd () { print -Pn "\e]2;%~\a" } # title bar prompt

# alacritty
bindkey "^[[1;3C" end-of-line
bindkey "^[[1;3D" beginning-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# mac terminal
bindkey "^[f" forward-word
bindkey "^[b" backward-word

export PATH=$HOME/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
