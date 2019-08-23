# vim: set filetype=zsh:

local check_mark='\xE2\x9C\x94'
local x_mark='\xE2\x9C\x98'

# User info.
function prompt_user(){
    echo "%{$fg[cyan]%}%n"
}

# Machine info.
function prompt_machine(){
    echo "%{$fg[green]%}%m"
}

# Directory info.
function prompt_dir(){
    echo "%{$fg_bold[yellow]%}${PWD/#$HOME/~}%{$reset_color%}"
}

# Git info
function prompt_git(){
    ZSH_THEME_GIT_PROMPT_PREFIX="git:%{$fg[cyan]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}$x_mark"
    ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}$check_mark"
    git_prompt_info
}

# Pyenv info
function prompt_pyenv(){
    if (( ${+commands[pyenv]} )); then
        local pyenv_version="$(pyenv version-name)"
        if [[ "$pyenv_version" != "system" ]]; then
            echo "pyenv:%{${fg[yellow]}%}$pyenv_version%{$reset_color%}"
        fi
    fi
}

# Venv info
function prompt_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "venv:%{${fg[yellow]}%}${VIRTUAL_ENV##*/}%{$reset_color%}"
    fi
}

# Rbenv info
function prompt_rbenv(){
    if (( ${+commands[rbenv]} )); then
        local rbenv_version="$(rbenv version-name)"
        if [[ "$rbenv_version" != "system" ]]; then
            echo "rbenv:%{${fg[yellow]}%}$rbenv_version%{$reset_color%}"
        fi
    fi
}

# Assemble additional info
function prompt_additional(){
    local -a array
    array=( \
        "$(prompt_git)" \
        "$(prompt_pyenv)" \
        "$(prompt_venv)" \
        "$(prompt_rbenv)" \
    )
    array=(${array[@]})
    if [[ $#array != 0 ]]; then
        echo "%{$reset_color%}on ${(pj:, :)array} "
    fi
}

# Prompt info.
function prompt_status(){
    local color="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})"
    if [[ $EUID -ne 0 ]]; then
        echo "${color}$ %{$reset_color%}"
    else
        echo "${color}# %{$reset_color%}"
    fi
}

# Main prompt
# Format: \n # USER at MACHINE in DIRECTORY on [git/hg] [pyenv] [rbenv] [TIME] \n $
PROMPT='
%{$fg_bold[blue]%}#%{$reset_color%} \
$(prompt_user) \
%{$reset_color%}at \
$(prompt_machine) \
%{$reset_color%}in \
$(prompt_dir) \
$(prompt_additional)\
%{$reset_color%}[%*]
$(prompt_status)'
