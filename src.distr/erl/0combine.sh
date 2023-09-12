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

file='otp_src_26.0.2.tar.gz'
echo "Combining $file..."
cat "$file".* | tar xzvf -
	fn_stoponerror $BASH_SOURCE $LINENO $?
rm "$file".*
	fn_stoponerror $BASH_SOURCE $LINENO $?
