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
	day_time="07:15"
	current_time=$(date +"%H:%M")

	if [[ "$current_time" > "$night_time" ]]; then
		darkmode
		echo "Switched TO Dark Mode"
	elif [[ "$current_time" < "$night_time"  && "$current_time" > "$day_time" ]]; then
		lightmode
		echo "Switched TO Light"
	fi

}
lightmode()
{
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita
	gsettings set org.gnome.desktop.interface color-scheme prefer-light
}
darkmode()
{
	gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark
}

update()
{
	flatpak update com.visualstudio.code org.mozilla.firefox;
}

default_settings()
{
	display
	update
	theme_switcher
}
main()
{
	default_settings
}
main
