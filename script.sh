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
#    By: yrhandou <yrhandou@student.1337.ma>       #
#                                                  #
#    Created: 2025/04/21 17:58:37 by yrhandou      #
#    Updated: 2025/05/12 15:06:31 by yrhandou      #
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
	xrandr -s $RESOLUTION;
	gsettings set org.gnome.desktop.interface icon-theme Win10Sur;
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

update_favourites()
{
	declare -a APPLICATIONS;

	APPLICATIONS=(com.visualstudio.code org.mozilla.firefox)  # Applications That will be Updated
	flatpak update "${APPLICATIONS[@]}"  -y ;
}

default_settings()
{
	bluetooth_mangler
	display
	theme_switcher
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
	fi
	if [[ "$1" -eq 0 ]]; then
		echo -e "\e[33mNo Args Given ! Using default settings\e[0m"
		default_settings
	fi
}

main "$1"
