#!/bin/bash
MOV='/srv/dev-disk-by-uuid-10C4B9617AABC62B/dusty/_Movies/'
OVE='/srv/dev-disk-by-uuid-10C4B9617AABC62B/dusty/_Movies/'
while true; do
	cd "$MOV"
	for dir in */; do
		cd "$MOV$dir"
		pwd

		flink=$(readlink -f poster.jpg)
		creatortool=$(exiftool -f -s3 -"creatortool" "$flink")
		printf "%s\n" "${creatortool}"

		if [ "${creatortool}" != "993" ]; then
			mlink=$(readlink -f *.mkv)
			langs=$(ffprobe "$mlink" -show_entries stream=index:stream_tags=language -select_streams a -v 0 -of json=c=1 | jq --raw-output '.streams[].tags.language')

			GER='ger'
			DUT='dut'
			ENG='eng'
			HUN='hun'
			printf "%s\n" "$langs"

			case $langs in

			*"$ENG"*)
				widthposter=$(exiftool -f -s3 -"ImageWidth" "$flink")
				convert "$OVE"dut_overlay.png -resize "$widthposter" "$OVE"dut_overlay_tmp.png
				convert "$flink" "$OVE"dut_overlay_tmp.png -flatten "$flink"
				chmod +644 "$flink"
				chown nobody "$flink"
				exiftool -creatortool="993" -overwrite_original "$flink"
				;;

			*"$GER"*)
				widthposter=$(exiftool -f -s3 -"ImageWidth" "$flink")
				convert "$OVE"ger_overlay.png -resize "$widthposter" "$OVE"ger_overlay_tmp.png
				convert "$flink" "$OVE"ger_overlay_tmp.png -flatten "$flink"
				chmod +644 "$flink"
				chown nobody "$flink"
				exiftool -creatortool="993" -overwrite_original "$flink"
				;;
			esac
		fi
	done
	sleep 90000
done