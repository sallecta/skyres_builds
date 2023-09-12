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
fn_delifexist ()
{
	a_name=$1
	if [ -e $a_name ]
	then
		rm -r --force $a_name
	fi
}
version=$(cat $pthis/lib/erlang/lib/wings/version)
	fn_stoponerror $BASH_SOURCE $LINENO $?
if [ -z $version ]
then
	echo "$BASH_SOURCE: $LINENO: Failed to get version. Stop."
	exit
fi
destop_file="Wings_$version.desktop"
pdest="$HOME/.local/share/applications"
fn_delifexist "$pdest/$destop_file"
	fn_stoponerror $BASH_SOURCE $LINENO $?
fn_delifexist "$HOME/.config/Wings3D"
	fn_stoponerror $BASH_SOURCE $LINENO $?
fn_delifexist "$HOME/.cache/Wings3D"
	fn_stoponerror $BASH_SOURCE $LINENO $?
