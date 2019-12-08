#!/bin/bash

#sh MODIS_data_fetch.sh e4ftl01.cr.usgs.gov//DP107/MOLA/MYD13Q1.006 /home/pushkar/Desktop/test/

# date_str=$3

mkdir $2/Temperature

start=2019-10-08
end=2019-10-31
while ! [[ $start > $end ]]; do
	date_str="$(echo "$start" | cut -d'-' -f1)"."$(echo "$start" | cut -d'-' -f2)"."$(echo "$start" | cut -d'-' -f3)"
	echo $date_str
	data_path=$2$1
	wget -A "*h0[8-9]v0[4-6]*hdf" -m -p -E -k -K -np https://$1/$date_str/ -P $2
	wget -A "*h1[0-4]v0[4-6]*hdf" -m -p -E -k -K -np https://$1/$date_str/ -P $2
	start=$(date -d "$start + 8 day" +%F)

	for filename in $data_path/$date_str/*.hdf; do
		old_file_name="$(echo "$filename" | cut -d'/' -f12)"
		new_file_name=$date_str."$(echo "$old_file_name" | cut -d'.' -f3)"."$(echo "$old_file_name" | cut -d'.' -f4)"."$(echo "$old_file_name" | cut -d'.' -f5)"
		mv "$filename" "$data_path/$date_str/$new_file_name.hdf"
	done

	mv $data_path/$date_str/* $2/Temperature
done
rm -rf $2/"$(echo "$1" | cut -d'/' -f1)"