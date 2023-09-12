pthis="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
fn_stoponerror ()
{
	# Usage:
	# fn_stoponerror $BASH_SOURCE $LINENO $?
	from=$1
	line=$2
	error=$3
	if [ $error -ne 0 ]; then
		printf "\n$from: line $line: error: $error\n"
		exit $error
	fi
}
#apt-get install libwxgtk-webview3.0-gtk3-0v5 libwxgtk-media3.0-gtk3-0v5
fn_delifexist ()
{
	a_name=$1
	if [ -e $a_name ]
	then
		rm -r --force $a_name
	fi
}
fn_delifexist "$HOME/.config/Wings3D"
fn_delifexist "$HOME/.cache/Wings3D"

export BINDIR="$pthis/lib/erlang/erts-14.0.2/bin"
export LD_LIBRARY_PATH="$pthis/lib":$LD_LIBRARY_PATH
#"$BINDIR"/erlexec  -noshell -pa "$pthis"/bin -run wings_start start_halt ${1+"$@"}
"$BINDIR"/erlexec -pa "$pthis"/bin -run wings_start start_halt ${1+"$@"}
fn_stoponerror $BASH_SOURCE $LINENO $?
