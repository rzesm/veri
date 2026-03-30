CURRENT=$(hyprctl activeworkspace -j | jq -r '.id')
FIRST=$((CURRENT - 4))
if [ "$FIRST" -lt 1 ]; then
    FIRST=1
fi

hyprctl keyword plugin:hyprexpo:workspace_method first $FIRST
hyprctl dispatch hyprexpo:expo toggle

# HYPRSPACE="/tmp/hyprspace_open"
# HYPRBARS="/tmp/hyprbars_enabled"
# 
# # If hyprspace overlay is open
# if [ -f "$HYPRSPACE" ]; then
# 	hyprctl dispatch overview:close
# 
# 	# If hyprbars were enabled
# 	if [ -f "$HYPRBARS" ]; then
# 		hyprctl plugin load /var/cache/hyprpm/rzes/hyprland-plugins/hyprbars.so
# 	fi
# 
# 	rm -f "$HYPRSPACE"
# else
# 	# If hyprbars are enabled
# 	if [ -f "$HYPRBARS" ]; then
# 		hyprctl plugin unload /var/cache/hyprpm/rzes/hyprland-plugins/hyprbars.so
#     	hyprctl dispatch overview:open
# 	else
#     	hyprctl dispatch overview:open
# 	fi
# 
# 	touch "$HYPRSPACE"
# fi
