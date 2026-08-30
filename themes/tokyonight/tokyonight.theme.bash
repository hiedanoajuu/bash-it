# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.

SCM_THEME_PROMPT_PREFIX="  "
SCM_THEME_PROMPT_SUFFIX=" "
SCM_THEME_PROMPT_DIRTY=" ?"
SCM_THEME_PROMPT_CLEAN=" ✓"

function distro_prompt_info() {
	if [[ -f /etc/os-release ]]; then
        . /etc/os-release
    else
        echo ""
        return
    fi

	local ID_lower=$(echo "$ID" | tr '[:upper:]' '[:lower:]')

	case "$ID_lower" in
        *ubuntu*)	echo "" ;;
        *debian*)	echo "" ;;
        *fedora*)	echo "" ;;
        *arch*|*archarm*)	echo "" ;;
        *manjaro*)	echo "" ;;
        *centos*)	echo "" ;;
        *rhel*)	echo "" ;;
        *alpine*)	echo "" ;;
        *opensuse*)	echo "" ;;
        *nixos*)	echo "" ;;
        *void*)	echo "" ;;
        *gentoo*)	echo "" ;;
        *slackware*)	echo "" ;;
        *)	echo "" ;;
    esac
}

function nodejs_prompt_info() {
	if [[ -d "node_modules" ]]; then
		echo "  $(node -v) "
	else
		echo ""
	fi
}

function python_prompt_info() {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo "  ${VIRTUAL_ENV##*/} "
	else
		echo ""
	fi
}

function rust_prompt_info() {
	if [[ -f "Cargo.toml" ]]; then
		echo "  ${rustc --version} "
	else
		echo ""
	fi
}

function prompt_command() {
	local scm_prompt_info
	local distro_prompt_info
	local time_prompt_info
	local nodejs_prompt_info
	local python_prompt_info
	local rust_prompt_info

	dir_color="\[\033[38;2;227;229;229m\]\[\033[48;2;118;159;240m\]"
	distro_color="\[\033[48;2;163;174;210m\]\[\033[38;2;9;12;12m\]"
	scm_color="\[\033[38;2;118;159;240m\]\[\033[48;2;57;66;96m\]"
	clock_color="\[\033[38;2;160;169;203m\]\[\033[48;2;29;34;48m\]"
	other_color="\[\033[38;2;57;66;96m\]\[\033[48;2;33;39;54m\]"

	if [[ "${USER:-${LOGNAME?}}" = root ]]; then
		cursor_color="${bold_red?}"
		user_color="${green?}"
	else
		cursor_color="${bold_green?}"
		user_color="${white?}"
	fi

	scm_prompt_info="$(scm_prompt_info)"
	distro_prompt_info=" $(distro_prompt_info) "
	time_prompt_info="  $(date +%H:%M) "
	nodejs_prompt_info="$(nodejs_prompt_info)"
	python_prompt_info="$(python_prompt_info)"
	rust_prompt_info="$(rust_prompt_info)"

	PS1="\n\[\033[38;2;163;174;210m\]░▒▓${distro_color}${distro_prompt_info}\[\033[48;2;118;159;240m\]\[\033[38;2;163;174;210m\]${dir_color} \w \[\033[38;2;118;159;240m\]\[\033[48;2;57;66;96m\]${scm_color}${scm_prompt_info}\[\033[38;2;57;66;96m\]\[\033[48;2;33;39;54m\]${other_color}${nodejs_prompt_info}${python_prompt_info}${rust_prompt_info}\[\033[38;2;33;39;54m\]\[\033[48;2;29;34;48m\]${clock_color}${time_prompt_info}\[\033[38;2;29;34;48m\]\[\033[49m\] \n${cursor_color}❯ ${normal?}"
}

safe_append_prompt_command prompt_command
