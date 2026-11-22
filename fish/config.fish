# Fish config, adapted from github.com/thearpankumar/dotfiles for this Omarchy machine.
# fish + starship + tmux, as in the dotfiles. Machine-specific paths are guarded,
# so missing tools are skipped instead of erroring.

### PATH ###
# The Hyprland session already provides Omarchy's PATH (mise shims, ~/.local/bin).
# fish_add_path skips directories that don't exist and never duplicates entries.
set -q OMARCHY_PATH; or set -gx OMARCHY_PATH /usr/share/omarchy
fish_add_path -g $HOME/.bin $HOME/.local/bin $HOME/.cargo/bin $HOME/go/bin $HOME/Applications $HOME/.deno/bin

# Optional SDKs from the old machine: only added when they are installed here.
if test -d $HOME/Android/Sdk
    set -gx ANDROID_HOME $HOME/Android/Sdk
    set -gx ANDROID_SDK_ROOT $ANDROID_HOME
    fish_add_path -g $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools $ANDROID_HOME/cmdline-tools/latest/bin
end
test -d $HOME/flutter/bin; and fish_add_path -g $HOME/flutter/bin
test -d /usr/local/go/bin; and fish_add_path -g /usr/local/go/bin
if test -d $HOME/.pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path -g $PYENV_ROOT/bin
end
if test -d /opt/cuda/bin
    fish_add_path -g /opt/cuda/bin
end

### EXPORTS ###
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim
set -gx BROWSER omarchy-launch-browser
set -gx BAT_THEME ansi
set -gx MANPAGER "nvim +Man!"
set -gx PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium   # mermaid-cli (mmdc) uses system Chromium
set -gx HEADROOM_TELEMETRY off   # no Headroom usage beacon

# Everything below is only for interactive shells.
status is-interactive; or return

set fish_greeting   # no intro message

### VI MODE ###
function fish_user_key_bindings
    fish_vi_key_bindings
    # CTRL+V pastes in every vi mode (fzf.fish had taken it for "search variables").
    for mode in insert default visual
        bind -M $mode ctrl-v fish_clipboard_paste
    end
end

# fzf.fish (from omarchy-fish): move "search variables" off CTRL+V to CTRL+ALT+V.
functions -q fzf_configure_bindings; and fzf_configure_bindings --variables=ctrl-alt-v

### COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

### OMARCHY TOOLING (what Omarchy's bash setup provided) ###
command -q mise; and mise activate fish | source
command -q zoxide; and zoxide init fish | source
command -q fzf; and fzf --fish | source

### FUNCTIONS ###

# !! and !$ history expansion
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

bind -M insert ! __history_previous_command
bind -M insert '$' __history_previous_command_arguments
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# backup file.txt -> file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# copy, recursive when the source is a directory
function copy
    if test (count $argv) = 2; and test -d "$argv[1]"
        command cp -r (string trim -r -c / -- $argv[1]) $argv[2]
    else
        command cp $argv
    end
end

# echo 1 2 3 | coln 3  -> 3
function coln
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

# seq 3 | rown 3  -> 3
function rown --argument index
    sed -n "$index p"
end

# seq 10 | skip 5  -> 6..10
function skip --argument n
    tail -n +(math 1 + $n)
end

# seq 10 | take 5  -> 1..5
function take --argument number
    head -$number
end

function tmux_attach_or_create
    set session_name mysession
    if tmux has-session -t $session_name 2>/dev/null
        tmux attach -t $session_name
    else
        tmux new -s $session_name
    end
end

# Open files with their default app, detached from the terminal
function open
    xdg-open $argv >/dev/null 2>&1 &
    disown
end

### ALIASES ###
# navigation (cd uses zoxide when available, like Omarchy)
command -q zoxide; and alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# editor
alias vim='nvim'
alias nv='nvim'

# ls -> eza
alias ls='eza -al --color=always --group-directories-first --icons=auto'
alias la='eza -a --color=always --group-directories-first --icons=auto'
alias ll='eza -l --color=always --group-directories-first --icons=auto'
alias lt='eza -aT --color=always --group-directories-first --icons=auto'
alias l.='eza -a | grep -E "^\."'

# pacman / AUR (yay is Omarchy's AUR helper)
alias pacsyu='sudo pacman -Syu'
alias yaysua='yay -Sua'
alias yaysyu='yay -Syu'
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'   # remove orphaned packages

# grep colours
alias grep='grep --color=auto'

# human-readable sizes
alias df='df -h'
alias free='free -m'

# processes
alias psa='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# logs
alias jctl='journalctl -p 3 -xb'

# gpg
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

# switch default shell
alias tobash="chsh -s /usr/bin/bash && echo 'Now log out.'"
alias tofish="chsh -s /usr/bin/fish && echo 'Now log out.'"

# misc
alias cls='clear'
alias venv='source .venv/bin/activate.fish'
alias pfzf="fzf --preview 'bat --color=always {}'"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cx='printf "\033[2J\033[3J\033[H"; and claude --permission-mode auto'

# conda, only if installed
test -f $HOME/miniconda3/etc/fish/conf.d/conda.fish; and source $HOME/miniconda3/etc/fish/conf.d/conda.fish

### PROMPT ###
command -q starship; and starship init fish | source

### TMUX ###
# Start tmux in every new terminal, as in the dotfiles. Skipped inside tmux
# already and in VS Code/JetBrains terminals. Apps Omarchy launches directly in a
# terminal (btop, etc.) don't start an interactive shell, so they're unaffected.
if not set -q TMUX; and isatty stdin; and not set -q VSCODE_PID; and not set -q TERMINAL_EMULATOR; and command -q tmux
    tmux
end
