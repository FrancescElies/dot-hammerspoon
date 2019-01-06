-- https://github.com/kerma/defaultbrowser/issues/3#issuecomment-319434425
try
	tell application "System Events"
		tell application process "CoreServicesUIAgent"
			tell window 1
				tell (first button whose name starts with "use")
					perform action "AXPress"
				end tell
			end tell
		end tell
	end tell
end try
