pthis="$(dirname "$0")"
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

export BINDIR="$pthis/lib/erlang/erts-14.0.2/bin"
export LD_LIBRARY_PATH="$pthis/lib":$LD_LIBRARY_PATH
"$BINDIR"/erlexec  -noshell -pa "$pthis"/bin -run wings_start start_halt ${1+"$@"}
	fn_stoponerror $BASH_SOURCE $LINENO $?
