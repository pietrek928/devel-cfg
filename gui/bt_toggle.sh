#!/bin/bash

CARD_NAME=$(pactl list cards | grep -E 'Name: bluez_card\.' | head -n 1 | awk '{print $2}')

# --- 2. VALIDATION ---
if [ -z "$CARD_NAME" ]; then
    notify-send -t 3000 "Bluetooth Toggle Error" "No active Bluetooth audio device found."
    exit 1
fi

# Profiles
A2DP_TARGET="a2dp-sink"  # LDAC
HSP_TARGET="headset-head-unit"  # mSBC
CURRENT_PROFILE=$(pactl list cards | awk '/Name: '$CARD_NAME'/{flag=1;next}/Active Profile:/{if(flag){print $3; exit}}')

# Check if the current profile is Headset mode (e.g., headset-head-unit-msbc)
if [[ "$CURRENT_PROFILE" == headset-head-unit* ]]; then
    
    # Currently in Headset Mode (Mic ON), switch to A2DP (Music)
    if pactl set-card-profile "$CARD_NAME" "$A2DP_TARGET" ; then
        notify-send -t 1500 "Bluetooth Profile" "Switched to High Quality ($A2DP_TARGET)"
    else
        notify-send -t 1500 "Bluetooth Profile" "Setting High Quality ($A2DP_TARGET) failed"
    fi

# Check if the current profile is A2DP mode (e.g., a2dp-sink-ldac)
elif [[ "$CURRENT_PROFILE" == a2dp-sink* ]]; then
    
    # Currently in A2DP Mode (Music), switch to Headset (Mic ON)
    if pactl set-card-profile "$CARD_NAME" "$HSP_TARGET" ; then
        notify-send -t 1500 "Bluetooth Profile" "Switched to Headset Mode ($HSP_TARGET)"
    else
        notify-send -t 1500 "Bluetooth Profile" "Setting Headset Mode ($HSP_TARGET) failed"
    fi

else
    # Fallback/Error: Try to set A2DP and notify
    if pactl set-card-profile "$CARD_NAME" "$A2DP_TARGET" ; then
        notify-send -t 3000 "Bluetooth Profile" "Profile reset to High Quality. Current profile: $CURRENT_PROFILE"
    else
        notify-send -t 3000 "Bluetooth Profile" "Profile reset to High Quality. Setting profile $CURRENT_PROFILE failed"
    fi
fi

