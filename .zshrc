# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#autoload -Uz promptinit
#promptinit
#prompt elite2 blue

# Partial Completion
zstyle ':completion:*' completer _complete
#zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

setopt NO_BEEP
setopt auto_remove_slash #remove trailing slash from completions on typing

# Git integration
autoload -Uz vcs_info


# Aliases
alias ls='echo "You should be using Rust!"; ls --color=auto'
alias vim='nvim'
alias pkgupg='sudo pacman -Syu'
alias cower='cower -c'
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gp='git push'
alias gpl='git pull'
alias grep='rg'
alias android-studio='_JAVA_AWT_WM_NONREPARENTING=1 android-studio'
alias firefox='MOZ_GTK_TITLEBAR_DECORATION=client firefox'
alias dotconfig='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


#prompt
my_precmd() {
    vcs_info
	_USERNAME="%B%F{green}%n@%m%f%b"
    _PATH="%~"
    print -rP "$_USERNAME | $_PATH ${vcs_info_msg_0_}"
}

setprompt() {
    setopt prompt_subst
    p_host='%F{green}%M%f'
      PS1=${(j::Q)${(Z:Cn:):-$'
    %(!.%F{red}%#%f.%F{cyan}λ%f)
    " "
  '}}

  PS2=$'%_>'
}

chpwd() ls

setprompt
autoload -U add-zsh-hook
add-zsh-hook precmd my_precmd
LC_CTYPE=en_US.UTF-8
export VISUAL=nvim
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export QT_QPA_PLATFORM=wayland-egl


# Alias command for running/compiling kotlin code more script like
kotrun() {
    kotlinc $@ -include-runtime -d tmp_out.jar && java -jar tmp_out.jar
}
