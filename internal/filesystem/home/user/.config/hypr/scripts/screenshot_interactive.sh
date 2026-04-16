#!/bin/bash

TEMP_IMG="/tmp/ssm.png"
SAVE_DIR="$HYPRSHOT_DIR"
rm "$TEMP_IMG"
mkdir -p "$SAVE_DIR"

# Take the screenshot and check for output
wayfreeze & PID=$!; sleep .1; grim -g "$(slurp -b 000000b3 -c ffffff20)" $TEMP_IMG; kill $PID
if [ ! -f "$TEMP_IMG" ]; then
    exit 0
fi

PREVIEW_IMG="/tmp/ssm_padded.png"
magick "$TEMP_IMG" -resize 300x300 -background transparent -gravity center -extent 300x300 "$PREVIEW_IMG"

OPTION_OPEN="View"
OPTION_SAVE="Save"
OPTION_COPY="Copy image"
OPTION_OCR="Copy text"

# Launch Rofi and get the option
CHOICE=$(echo -en "$OPTION_OPEN\n$OPTION_SAVE\n$OPTION_COPY\n$OPTION_OCR" | rofi -dmenu -i -theme-str "
	window {
		width: 320px;
	}
	
    mainbox {
        children: [preview /* instead of inputbar */, listview];
    }

    preview /* instead of inputbar */ {
        background-image: url(\"$PREVIEW_IMG\", both);
        background-color: rgba(0, 0, 0, 0.6);
        padding: 140px;
        border-radius: 25px;
        expand: false;
    }

    listview {
    	expand: true;
    }

    entry { enabled: false; }
    prompt { enabled: false; }

    element-text {
        horizontal-align: 0.5;
        margin: 0 20 0 -20; 
    }
")

# Handle selection
case "$CHOICE" in
    *"$OPTION_OPEN"*)
        qview "$TEMP_IMG"
        ;;
    *"$OPTION_SAVE"*)
        wl-copy < $TEMP_IMG
        TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
        SAVE_PATH="$SAVE_DIR/${TIMESTAMP}_hyprshot.png"
        mv "$TEMP_IMG" "$SAVE_PATH"
        notify-send "Image saved"
        ;;
    *"$OPTION_COPY"*)
        wl-copy < $TEMP_IMG
        notify-send "Image copied"
        ;;
    *"$OPTION_OCR"*)
        TEXT=$(tesseract "$TEMP_IMG" stdout)
        if [[ -z $TEXT ]]; then
            notify-send "No text detected"
        else
            wl-copy $TEXT
            notify-send "Text copied" "$TEXT"
        fi
        ;;
esac

rm "$TEMP_IMG"
rm "$PREVIEW_IMG"
