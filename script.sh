#!/bin/bash
# ************************************************ #
#												   #
#			              %%%					   #
#			            %%+ %					   #
#			             : %@					   #
#			         %%@@@*@					   #
#			      %%%%:  .-@@@					   #
#			     %% @+%%:   +%					   #
#			   @     @ @#+: =@@					   #
#			   @    @+   =+-% %%%				   #
#			    @-   @@@+.+@@@@					   #
#			  #@@@+     .@@  ++ =@				   #
#			     #@   @+     #%%+ @				   #
#			       @+@+@@@@@@@   @#+@*			   #
#			     @@  @@++++=+=+@@   @*			   #
#			       @@* +@@%@== #@@+@			   #
#			        @@+@     @+  +@				   #
#			    :@@@-  @      %@+@*@			   #
#			  @@%%%%%@@@@@@=        @  :		   #
#			                @@@@@@@@@@@			   #
#                                                  #
#                                                  #
#                                                  #
#    Created: 2025/04/21 17:58:37 by yrhandou      #
#                                                  #
# *************************************************#

bluetooth_mangler()
{
	declare -i i=0;
	declare -i paired_devices_count;
	declare -a paired_devices;
	declare -a devices_array;

	printf "Removing Bluetooth Devices\n"
	devices=$( bluetoothctl paired-devices )
	paired_devices_count=$(echo "$devices" | grep -c "Device" )
	IFS=$'\n' read -r -d '' -a devices_array <<< "$devices"
	if [[ $paired_devices_count -eq 0 ]]; then
		echo -e "\e[33mNO bluethooth device Paired , Exiting!\e[0m"
		return;
	fi;
	while [[ i -lt  $paired_devices_count ]] ;
	do
		device=$(echo "${devices_array[i]}" | awk ' {print $2}')
		paired_devices+=("$device");
		bluetoothctl remove "${paired_devices[i]}";
		((i++));
	done
	printf "\nDone :)\n"
}


display()
{
	RESOLUTION=2560x1440
	ICON="Win10Sur"
	xrandr -s $RESOLUTION;
	gsettings set org.gnome.desktop.interface icon-theme "$ICON";
	echo "Changed Resolution Successfully ✅";

}

theme_switcher()
{
	night_time="20:15"
	day_time="07:00"
	current_time=$(date +"%H:%M")
	if [[ "$current_time" > "$night_time" || "$current_time" < "$day_time" ]]; then
		darkmode
	elif [[ "$current_time" > "$day_time"  && "$current_time" < "$night_time" ]]; then
		lightmode
	fi
	echo "Done ✅"
}
lightmode()
{
	LIGHT_THEME="Adwaita";
	echo "Setting Light Theme..."
	gsettings set org.gnome.desktop.interface gtk-theme $LIGHT_THEME
	gsettings set org.gnome.desktop.interface color-scheme prefer-light
}
darkmode()
{
	DARK_THEME="Adwaita";
	echo "Setting Dark Theme..."
	gsettings set org.gnome.desktop.interface gtk-theme $DARK_THEME
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark
}

spotify_fix()
{
	rm -rf "$HOME/.var/app/com.spotify.Client"
	flatpak override --user --nosocket=wayland com.spotify.Client
	flatpack run com.spotify.Client
}

create_alias()
{
	declare -a FILES
	declare  SH_ENV

	FILES=($(ls -d .*shrc 2>/dev/null))
	count=${#FILES[@]}
	if [[ $count -eq 1 ]] ; then
		SH_ENV=${FILES[0]}
		echo "alias code=\"flatpack run com.visualstudio.code\""
		return 1
	elif [[ $count -eq 0 ]]; then
		echo "NO shell config found :("
		return 0
	fi

}

update_favourites()
{
	declare -a APPLICATIONS;

	APPLICATIONS=(com.visualstudio.code org.mozilla.firefox com.spotify.Client)  # Applications That will be Updated
	flatpak update "${APPLICATIONS[@]}"  -y ;
}

default_settings()
{
	bluetooth_mangler
	display
	update_favourites
}

main()
{
	if [[ $1 = '-bth' ]]; then
		bluetooth_mangler
	elif [[ $1 = '-t' ]]; then
		theme_switcher
	elif [[ $1 = '-u' ]]; then
		update_favourites
	elif [[ $1 = '-d' ]]; then
		display
	elif [[ $1 = '-s' ]]; then
		spotify_fix
	elif [[ $1 = '-p' ]]; then
		create_alias
	else
		return 1
	fi
	# if [[ "$1" -eq 0 ]]; then
	# 	echo -e "\e[33mNo Args Given ! Using default settings\e[0m"
	# 	default_settings

}

main "$1"
