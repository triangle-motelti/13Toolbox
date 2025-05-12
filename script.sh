#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    script.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yrhandou <yrhandou@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/21 17:58:37 by yrhandou          #+#    #+#              #
#    Updated: 2025/04/25 21:37:26 by yrhandou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# TODO Figure out how to do while loops, How to ork with arrays, how to use awk

app_nuker()
{
	flatpak remove
}

bluetooth_mangler()
{
	declare -i i=0;
	declare -i paired_devices_count;
	declare -a paired_devices;
	declare -a devices_array;

	devices=$( bluetoothctl paired-devices )
	paired_devices_count=$(echo "$devices" | grep -c "Device" )
	IFS=$'\n' read -r -d '' -a devices_array <<< "$devices"
	while [[ i -lt  $paired_devices_count ]] ;
	do
		device=$(echo "${devices_array[i]}" | awk ' {print $2}')
		paired_devices+=("$device");
		bluetoothctl remove "${paired_devices[i]}";
		printf "%s Removed !" "${devices_array[i]}";
		((i++));
	done
}


display()
{
	RESOLUTION=2560x1440
	xrandr -s $RESOLUTION;
	echo "Changed Resolution Successfully";
	gsettings set org.gnome.desktop.interface icon-theme Win10Sur;

}

theme_switcher()
{
	night_time="19:15"
	day_time="07:30"
	current_time=$(date +"%H:%M")

	if [[ "$current_time" > "$night_time" || "$current_time" < "$day_time" ]]; then
		darkmode
	elif [[ "$current_time" > "$day_time"  && "$current_time" < "$night_time" ]]; then
		lightmode
	fi

}
lightmode()
{
	echo "Setting Light Theme..."
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita
	gsettings set org.gnome.desktop.interface color-scheme prefer-light
	echo "Done !"
}
darkmode()
{
	echo "Setting Dark Theme..."
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark
	echo "Done !"
}

update()
{
	flatpak update com.visualstudio.code org.mozilla.firefox -y ;
}

default_settings()
{
	# bluetooth_mangler
	display
	theme_switcher
	update
}
main()
{
	if [[ "$#" -eq 0 ]]; then
		echo -e "\e[33mNo Args Given ! Using default settings\e[0m"
		default_settings
	elif [[ $1 = 'bth' ]]; then
		bluetooth_mangler
	fi
}

main $1
# echo $#;
