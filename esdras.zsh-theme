autoload -U colors && colors

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"

ZSH_THEME_RVM_PROMPT_PREFIX="$fg[blue]["
ZSH_THEME_RVM_PROMPT_SUFFIX="]$reset_color"

ZSH_THEME_KIEX_PROMPT_PREFIX="$fg[red]["
ZSH_THEME_KIEX_PROMPT_SUFFIX="]$reset_color"

ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]COMMIT"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]OK"

ZSH_THEME_GIT_PROMPT_ADDED="$fg[green]ADD$reset_color"
ZSH_THEME_GIT_PROMPT_MODIFIED="$fg[yellow]MOD$reset_color"
ZSH_THEME_GIT_PROMPT_DELETED="$fg[red]DEL$reset_color"
ZSH_THEME_GIT_PROMPT_RENAMED="$fg[blue]REN$reset_color"
ZSH_THEME_GIT_PROMPT_UNMERGED="$fg[cyan]UNM$reset_color"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$fg[grey]UNT$reset_color"

function git_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function rvm_prompt_info() {
  ref=$(rvm-prompt) || return
  echo "$ZSH_THEME_RVM_PROMPT_PREFIX$(rvm-prompt i v g)$ZSH_THEME_RVM_PROMPT_SUFFIX"
}

function kiex_prompt_info() {  
  ref=$(kiex 2> /dev/null) || return
  version=$(which iex | cut -d '/' -f 6)
  echo "$ZSH_THEME_KIEX_PROMPT_PREFIX$version$ZSH_THEME_KIEX_PROMPT_SUFFIX"
}

function precmd() {

  local git_info=$(git_info)
  local git_status=$(git_prompt_status)
  local rvm=$(rvm_prompt_info)
  local kiex=$(kiex_prompt_info)
  local battery=$(battery_pct_prompt)
  
  local size_color=0

  if [ ${#git_info} != 0 ]; then
    ((size_color+=10))
  fi

  if [ ${#git_status} != 0 ]; then
    ((size_color+=10))
  fi

  if [ ${#rvm} != 0 ]; then
    ((size_color+=10))
  fi

  if [ ${#kiex} != 0 ]; then
    ((size_color+=10))
  fi
  
  if [ ${#battery} != 1 ]; then
    ((size_color+=20))
  fi

  local datesize=11
  local spacesize=12
  local name=`hostname -s`
  local logname=`logname`
  local termwidth= 
  (( termwidth = ${COLUMNS} + ${size_color} - ${spacesize} -${datesize} - ${#${logname}} - ${#${name}} - ${#${PWD}} - ${#git_info} - ${#git_status} - ${#rvm} - ${#kiex} - ${#battery} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} " 
  done
  
  print -rP '$fg[red][%*]${reset_color} $fg[cyan]${logname}@${name}: $fg[yellow]${PWD}${spacing} ${git_status} ${git_info} ${rvm} ${kiex} ${battery}'
}

PROMPT='%{$reset_color%}> '
