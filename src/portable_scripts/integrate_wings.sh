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

fn_delifexist "$pthis/$destop_file"
	fn_stoponerror $BASH_SOURCE $LINENO $?
fn_delifexist "$pdest/$destop_file"
	fn_stoponerror $BASH_SOURCE $LINENO $?
#fn_delifexist "$HOME/.config/Wings3D"
	#fn_stoponerror $BASH_SOURCE $LINENO $?
#fn_delifexist "$HOME/.cache/Wings3D"
	#fn_stoponerror $BASH_SOURCE $LINENO $?

content="
[Desktop Entry]
Name=Wings 3D $version
GenericName=A 3D Subdivision Modeler
Comment=A 3D modeler that is both powerful and easy to use
Exec=$pthis/run_wings.sh %F
Terminal=false
Type=Application
Icon=$pthis/lib/erlang/lib/wings/ebin/wings_icon_379x379.png
Categories=Graphics;
StartupNotify=true
"

echo "Creating desktop file \"$destop_file\" here and in \"$pdest\" with following content:"
echo "$content"
echo "$content">"$pthis/$destop_file"
	fn_stoponerror $BASH_SOURCE $LINENO $?
chmod +x "$pthis/$destop_file"
	fn_stoponerror $BASH_SOURCE $LINENO $?
cp --force "$pthis/$destop_file" "$pdest/"
	fn_stoponerror $BASH_SOURCE $LINENO $?
echo "Done."


