tname="Downloads"
if [ "$do_downloads" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_wxwidgets_extract" = "Y" ]; then
		echo "-- Extracting $tname"
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_wxwidgets_configure" = "Y" ]; then
		echo "-- Configuring $tname"
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_wxwidgets_make" = "Y" ]; then
		echo "-- Making $tname"
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
