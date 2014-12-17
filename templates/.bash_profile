[ -f ~/.bashrc ] && . ~/.bashrc
export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
