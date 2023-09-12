export LC_ALL=C

wings_version='v2.3.x.y.skyres'

pthis="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "$pthis"

#Erlang/OTP 25.3.1
#wxWidgets-3.2
pbuild="$pthis/build.ignore"
pinstall="$pthis/install.ignore"
distr="wings.$wings_version".ignore
distr_real="wings.$wings_version"


wx_name='wxWidgets-3.2.2.1'
	wx_ext='.tar.bz2'
erl_name='otp_src_26.0.2'
	erl_ext='.tar.gz'
rebar_name='3.22.1'
	rebar_ext='.tar.gz'
cl_name='cl-1.2.4'
	cl_ext='.tar.gz'
igl_name='0f8b991a46a1c97da305e7db4f311fa51e0c36ca'
	igl_ext='.tar.gz'
eigen_name='eigen-3.3.7'
	eigen_ext='.tar.gz'
wings_name='skyres-2.3.x.y.WINGS'
	wings_ext='.tar.lzma'

do_download='nY'
	do_download_wx='Y'
	do_download_erl='Y'
	do_download_rebar='Y'
	do_download_wings='Y'
	do_download_cl='Y'
	do_download_igl='Y'
	do_download_eigen='Y'

do_wxwidgets='nY'
	dirsrc_wxwidgets="wxWidgets.ignore"
	do_wxwidgets_extract='Y'
	do_wxwidgets_configure='Y'
	do_wxwidgets_make='Y'

do_erlang='nY'
	dirsrc_erlang="erlang.ignore"
	do_erlang_extract='Y'
	do_erlang_configure='Y'
	do_erlang_make='Y'

do_wings='nY'
	dirsrc_wings="wings.ignore"
	do_rebar='Y'
		dirsrc_rebar="rebar.ignore"
		do_rebar_extract='Y'
		do_rebar_configure='Y'
		do_rebar_make='Y'
	do_cl='Y'
		dirsrc_cl="cl.ignore"
		do_cl_extract='Y'
		do_cl_configure='Y'
		do_cl_make='Y'
	do_igl='Y'
		dirsrc_igl="igl.ignore"
		do_igl_extract='Y'
		do_igl_configure='Y'
		do_igl_make='Y'
	do_eigen='Y'
		dirsrc_eigen="eigen.ignore"
		do_eigen_extract='Y'
		do_eigen_configure='Y'
		do_eigen_make='Y'
	do_wings_extract='Y'
	do_wings_configure='Y'
	do_wings_make='Y'

deploy_wings='nY'
start_wings='nY'
pack_wings='Y'


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
fn_dep_check ()
{
	REQUIRED_PKG=$1
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo "Checking for $REQUIRED_PKG"
	if [ "" = "$PKG_OK" ]; then
		echo "-- No $REQUIRED_PKG. Installing..."
		sudo apt-get install $REQUIRED_PKG
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- $REQUIRED_PKG installed."
	fi
}
fn_stop_on_no_elib()
{
	# Usage:
	# fn_stop_on_no_elib "elibname" $BASH_SOURCE $LINENO
	a_name=$1
	a_bsource=$2
	a_line=$3
	loc="$a_bsource: line $a_line: "
	echo $loc"Testing erl lib $a_name"
	result=$(erl -noshell -eval "io:fwrite(code:which($a_name))" -s erlang halt)
		fn_stoponerror $BASH_SOURCE $LINENO $?
	if [ "$result" = "non_existing" ]; then
		echo $loc"-- Not found. Stop"
		exit 1
	else
		echo $loc"-- Found"
	fi
}


mkdir -p "$pbuild"
	fn_stoponerror $BASH_SOURCE $LINENO $?

tname="download"
if [ "$do_download" = "Y" ]; then
	echo "Doing $tname"
	wgetcmd='wget --quiet --show-progress'
	cd "$pbuild"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	if [ "$do_download_wx" = "Y" ]; then
		echo "-- Downloading wxWidgets"
		fn_delifexist "$wx_name$wx_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.2.1/"$wx_name$wx_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of wxWidgets"
	fi
	if [ "$do_download_erl" = "Y" ]; then
		echo "-- Downloading Erlang/OTP"
		fn_delifexist "$erl_name$erl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://github.com/erlang/otp/releases/download/OTP-26.0.2/"$erl_name$erl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of Erlang/OTP"
	fi
	if [ "$do_download_rebar" = "Y" ]; then
		echo "-- Downloading Rebar"
		fn_delifexist "$rebar_name$rebar_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://github.com/erlang/rebar3/archive/refs/tags/"$rebar_name$rebar_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of Rebar"
	fi
	if [ "$do_download_cl" = "Y" ]; then
		echo "-- Downloading CL"
		fn_delifexist "$cl_name$cl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://github.com/tonyrog/cl/archive/refs/tags/"$cl_name$cl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of CL"
	fi
	if [ "$do_download_igl" = "Y" ]; then
		echo "-- Downloading IGL"
		fn_delifexist "$igl_name$igl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://github.com/dgud/libigl/archive/"$igl_name$igl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of IGL"
	fi
	if [ "$do_download_eigen" = "Y" ]; then
		echo "-- Downloading Eigen"
		fn_delifexist "$eigen_name$eigen_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://gitlab.com/libeigen/eigen/-/archive/3.3.7/"$eigen_name$eigen_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of Eigen"
	fi
	if [ "$do_download_wings" = "Y" ]; then
		echo "-- Downloading Wings"
		fn_delifexist "$wings_name$wings_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		$wgetcmd https://github.com/sallecta/skyres/releases/download/v2.3.x.y.WINGS/"$wings_name$wings_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping download of Wings"
	fi
else
	echo "Skipping $tname"
fi


tname="wxWidgets"
if [ "$do_wxwidgets" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_wxwidgets_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd "$pbuild"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pbuild/$dirsrc_wxwidgets"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$wx_name$wx_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv "$wx_name" "$dirsrc_wxwidgets" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
		cp "$pthis/src.mods/wx/tbarbase.h" "$dirsrc_wxwidgets/include/wx/tbarbase.h" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_wxwidgets_configure" = "Y" ]; then
		echo "-- Configuring $tname"
		fn_dep_check 'libwebkit2gtk-4.0-dev'
		cd "$pbuild/$dirsrc_wxwidgets"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		#./configure --enable-compat28  --with-gtk=3  --enable-webview --prefix="$pinstall"
		./configure --enable-compat28  --with-gtk=3 --enable-webview --disable-tests --prefix="$pinstall"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_wxwidgets_make" = "Y" ]; then
		echo "-- Making $tname"
		cd "$pbuild/$dirsrc_wxwidgets"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		make -j4
			fn_stoponerror $BASH_SOURCE $LINENO $?
		#sudo ldconfig
			#fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pinstall"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		make install
			fn_stoponerror $BASH_SOURCE $LINENO $?
		make clean
			fn_stoponerror $BASH_SOURCE $LINENO $?
		cd "$pthis"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		#rm -r "$psrc_wxwidgets"
			#fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi

#wx-config --libs' or 'wx-config --static --libs' command out must be in
#in LD_LIBRARY_PATH

tname="Erlang/OTP"
if [ "$do_erlang" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_erlang_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd $pbuild
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$psrc_erlang"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$erl_name$erl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv "$erl_name" "$dirsrc_erlang" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
		if [ "$wx_name" = "wxWidgets-3.2.2.1" ]; then
			cp "$pbuild/$dirsrc_wxwidgets/include/wx/generic/colrdlgg.h" "$pinstall/include/wx-3.2/wx/generic/"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fi
	else
		echo "-- Skipping $tname extract"
	fi
	
	if [ "$do_erlang_configure" = "Y" ]; then
		echo "-- Configuring $tname"
		export ERL_TOP="$psrc_erlang"
		#Please check that wx-config is in path, the directory
		#where wxWidgets libraries are installed (returned by
		#'wx-config --libs' or 'wx-config --static --libs' command)
		#is in LD_LIBRARY_PATH or equivalent variable and
		#wxWidgets version is 3.0.2 or above.
		export PATH="$pinstall/bin":$PATH
		export LD_LIBRARY_PATH="$pinstall/lib":$LD_LIBRARY_PATH
			fn_stoponerror $BASH_SOURCE $LINENO $?
		cd "$pbuild/$dirsrc_erlang"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		#Threads must be enabled to make sure that Erlang emulator
		#is linked with reentrant libraries.
		#HiPE is not used by Wings, but disabling HiPE also disables 
		#the use of floating point exceptions.
		#which have caused Wings to crash occasionally.
		./configure --enable-threads --disable-hipe --prefix="$pinstall" --exec-prefix="$pinstall"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_erlang_make" = "Y" ]; then
		echo "-- Making $tname"
		export ERL_TOP="$psrc_erlang"
		export PATH="$pinstall/bin":$PATH
		export LD_LIBRARY_PATH="$pinstall/lib":$LD_LIBRARY_PATH
		cd "$pbuild/$dirsrc_erlang"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		make -j4
			fn_stoponerror $BASH_SOURCE $LINENO $?
		make install
			fn_stoponerror $BASH_SOURCE $LINENO $?
		make clean
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
tname="Rebar"
if [ "$do_rebar" = "Y" ] && [ "$do_wings" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_rebar_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd "$pbuild"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pbuild/$dirsrc_rebar"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$rebar_name$rebar_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv rebar3-"$rebar_name" "$dirsrc_rebar" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_rebar_configure" = "Y" ]; then
		echo "-- Configuring $tname"
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_rebar_make" = "Y" ]; then
		echo "-- Making $tname"
		cd "$pbuild/$dirsrc_rebar"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		export ERLHOME="$pinstall"
		#export ERLINCL="$pinstall/lib/erlang/usr/include"
		export PATH="$pinstall/bin":$PATH
			fn_stoponerror $BASH_SOURCE $LINENO $?
		./bootstrap
			fn_stoponerror $BASH_SOURCE $LINENO $?
		cp --force rebar3 "$pinstall"/bin/
			fn_stoponerror $BASH_SOURCE $LINENO $?
		echo "-- Testing $tname"
		rebar3 --version
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
tname="CL"
if [ "$do_cl" = "Y" ] && [ "$do_wings" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_cl_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd "$pbuild"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pbuild/$dirsrc_cl"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$cl_name$cl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv cl-"$cl_name" "$dirsrc_cl" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_cl_configure" = "Y" ]; then
		echo "-- Configuring $tname"
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_cl_make" = "Y" ]; then
		echo "-- Making $tname"
		cd "$pbuild/$dirsrc_cl"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		export ERLHOME="$pinstall"
		#export ERLINCL="$pinstall/lib/erlang/usr/include"
		export PATH="$pinstall/bin":$PATH
			fn_stoponerror $BASH_SOURCE $LINENO $?
		rebar3 compile
			fn_stoponerror $BASH_SOURCE $LINENO $?
		cp --force --recursive --dereference _build/default/lib/cl "$pinstall/lib/erlang/lib"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_stop_on_no_elib 'cl' $BASH_SOURCE $LINENO
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
tname="IGL"
if [ "$do_igl" = "Y" ] && [ "$do_wings" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_igl_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd "$pbuild"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pbuild/$dirsrc_igl"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$igl_name$igl_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv libigl-"$igl_name" "$dirsrc_igl" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_igl_configure" = "Y" ]; then
		echo "-- Configuring $tname"
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_igl_make" = "Y" ]; then
		echo "-- Making $tname"
		cd "$pbuild/$dirsrc_igl"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
tname="Eigen"
if [ "$do_eigen" = "Y" ] && [ "$do_wings" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_eigen_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd "$pbuild"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pbuild/$dirsrc_eigen"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$eigen_name$eigen_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv "$eigen_name" "$dirsrc_eigen" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_eigen_configure" = "Y" ]; then
		echo "-- Configuring $tname"
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_eigen_make" = "Y" ]; then
		echo "-- Making $tname"
		cd "$pbuild/$dirsrc_eigen"
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
tname="Wings"
if [ "$do_wings" = "Y" ]; then
	echo "Doing $tname"
	if [ "$do_wings_extract" = "Y" ]; then
		echo "-- Extracting $tname"
		cd "$pbuild"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_delifexist "$pbuild/$dirsrc_wings"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		tar -xf "$wings_name$wings_ext"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		mv "$wings_name" "wings" 
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping $tname extract"
	fi
	if [ "$do_wings_configure" = "Y" ]; then
		echo "-- Configuring $tname"
		if [ ! -d "$dirsrc_wings" ]; then
			mkdir "$dirsrc_wings" 
				fn_stoponerror $BASH_SOURCE $LINENO $?
		fi
		if [ ! -e "$pbuild/$dirsrc_wings"/wings/Makefile ]; then
			mv "wings" "$dirsrc_wings/" 
				fn_stoponerror $BASH_SOURCE $LINENO $?
		fi
		dirsrc_wings="$dirsrc_wings/wings"
		echo "---- The dirsrc_wings var updated to $dirsrc_wings"
		cd "$pbuild/$dirsrc_wings"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		fn_dep_check 'opencl-headers'
		fn_dep_check 'ocl-icd-libopencl1'
		fn_dep_check 'ocl-icd-opencl-dev'
		if [ ! -d "$pbuild/$dirsrc_wings"/_deps ]; then
			echo "Wings Deps not installed, setting up"
			mkdir _deps
				fn_stoponerror $BASH_SOURCE $LINENO $?
			mv "$pbuild/$dirsrc_igl" "$pbuild/$dirsrc_wings"/_deps/libigl 
				fn_stoponerror $BASH_SOURCE $LINENO $?
			mv "$pbuild/$dirsrc_eigen" "$pbuild/$dirsrc_wings"/_deps/eigen 
				fn_stoponerror $BASH_SOURCE $LINENO $?
		else
			echo "Wings Deps installed"
			ls _deps
				fn_stoponerror $BASH_SOURCE $LINENO $?
		fi
	else
		echo "-- Skipping configuring $tname"
	fi
	if [ "$do_wings_make" = "Y" ]; then
		echo "-- Making $tname"
		cd "$pbuild/$dirsrc_wings"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		export ERLHOME="$pinstall"
		#export ERLINCL="$pinstall/lib/erlang/usr/include"
		export PATH="$pinstall/bin":$PATH
		cp --verbose --force "$pthis/src.mods/wings/wings.mk" "$pbuild/$dirsrc_wings/Makefile"
		echo "$wings_version" > "$pbuild/$dirsrc_wings/version"
			fn_stoponerror $BASH_SOURCE $LINENO $?
		#cp --force "$pbuild/wings_frame.erl" "$psrc_wings/src/wings_frame.erl"
			#fn_stoponerror $BASH_SOURCE $LINENO $?
		make -j4
			fn_stoponerror $BASH_SOURCE $LINENO $?
	else
		echo "-- Skipping making $tname"
	fi
else
	echo "Skipping $tname"
fi
if [ "$deploy_wings" = "Y" ]; then
	echo "Deploing Wings"
	copy="cp --force --recursive --dereference"
	dirsrc_wings="wings.ignore/wings"
	echo "-- The dirsrc_wings var updated to $dirsrc_wings"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	cd "$pthis"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	fn_delifexist "$distr"
	mkdir "$distr"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	mkdir "$distr"/lib
		fn_stoponerror $BASH_SOURCE $LINENO $?
	echo "-- Copying lib/libwx_*"
	$copy "$pinstall"/lib/libwx_* "$distr"/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	
	echo "-- Copying lib/erlang"
	mkdir --parent "$distr"/lib/erlang/lib
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/lib/cl "$distr"/lib/erlang/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/lib/compiler-8.3.2 "$distr"/lib/erlang/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/lib/kernel-9.0.2 "$distr"/lib/erlang/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/lib/stdlib-5.0.2 "$distr"/lib/erlang/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/lib/wx-2.3 "$distr"/lib/erlang/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/lib/xmerl-1.3.32 "$distr"/lib/erlang/lib/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	
	echo "-- Copying lib/erlang/bin"
	mkdir --parent "$distr"/lib/erlang/bin
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/bin/start.boot "$distr"/lib/erlang/bin/
		fn_stoponerror $BASH_SOURCE $LINENO $?
		
	echo "-- Copying lib/erlang/erts-14.0.2/bin"
	mkdir --parent "$distr"/lib/erlang/erts-14.0.2/bin
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/erts-14.0.2/bin/beam.smp "$distr"/lib/erlang/erts-14.0.2/bin/beam.smp
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/erts-14.0.2/bin/erl_child_setup "$distr"/lib/erlang/erts-14.0.2/bin/erl_child_setup
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/erts-14.0.2/bin/erlexec "$distr"/lib/erlang/erts-14.0.2/bin/erlexec
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/erts-14.0.2/bin/escript "$distr"/lib/erlang/erts-14.0.2/bin/escript
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pinstall"/lib/erlang/erts-14.0.2/bin/inet_gethost "$distr"/lib/erlang/erts-14.0.2/bin/inet_gethost
		fn_stoponerror $BASH_SOURCE $LINENO $?
	
	echo "-- Copying wings"
	mkdir "$distr"/lib/erlang/lib/wings
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pbuild/$dirsrc_wings"/version "$distr"/lib/erlang/lib/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pbuild/$dirsrc_wings"/ebin "$distr"/lib/erlang/lib/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pbuild/$dirsrc_wings"/plugins "$distr"/lib/erlang/lib/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pbuild/$dirsrc_wings"/priv "$distr"/lib/erlang/lib/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pbuild/$dirsrc_wings"/shaders "$distr"/lib/erlang/lib/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	$copy "$pbuild/$dirsrc_wings"/textures "$distr"/lib/erlang/lib/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	mkdir --parent "$distr"/share/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	echo "-- Copying wings_samples"
	$copy "$pthis"/wings_samples "$distr"/share/wings/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	echo "-- Copying portable scripts"
	$copy "$pthis"/src/portable_scripts/*.sh "$distr"/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	chmod +x "$distr"/*.sh
		fn_stoponerror $BASH_SOURCE $LINENO $?
else
	echo "Skipping deploing Wings"
fi
if [ "$start_wings" = "Y" ]; then
	echo "Starting Wings"
	cd "$distr"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	./shell_wings.sh
		fn_stoponerror $BASH_SOURCE $LINENO $?
else
	echo "Skipping starting Wings"
fi
if [ "$pack_wings" = "Y" ]; then
	echo "Packing Wings"
	dirsrc_wings="wings.ignore/wings"
	echo "---- The dirsrc_wings var updated to $dirsrc_wings"
	cd "$pthis"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	archname="$distr".tar.lzma
	echo "-- Packing to $archname..."
	fn_delifexist "$archname"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	mv "$distr" "$distr_real"
		fn_stoponerror $BASH_SOURCE $LINENO $?
	tar -c --lzma -f "$archname" "$distr_real"/
		fn_stoponerror $BASH_SOURCE $LINENO $?
	mv "$distr_real" "$distr"
		fn_stoponerror $BASH_SOURCE $LINENO $?
else
	echo "Skipping packing Wings"
fi

cd "$pthis"
	fn_stoponerror $BASH_SOURCE $LINENO $?

echo "Done"
