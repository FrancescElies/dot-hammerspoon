-- DO NOT EDIT THIS FILE DIRECTLY
-- This is a file generated from a literate programing source file located at
-- https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org.
-- You should make any changes there and regenerate it from Emacs org-mode using C-c C-v t

hs.logger.defaultLogLevel="info"
logger = hs.logger.new("init.lua")

hyper = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}

hs.hotkey.bindSpec({ hyper, "r" }, "reload config", hs.reload)

col = hs.drawing.color.x11

workLogo = hs.image.imageFromPath(hs.configdir .. "/files/work.png")

homePath = hs.fs.pathToAbsolute('~')

local initStartupFile = hs.configdir .. "/init-local-startup.lua"
local initLocalStartup=loadfile(initStartupFile)
if initLocalStartup then
  logger.i("Loading", "init-local-startup.lua", "")
  initLocalStartup()
end

local appBeforeReloading = hs.application.frontmostApplication()

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.zzspoons = {
  url = "https://github.com/zzamboni/zzSpoons",
  desc = "zzamboni's spoon repository",
}

spoon.SpoonInstall.use_syncinstall = true

Install=spoon.SpoonInstall

Install:andUse("WindowHalfsAndThirds",
               {
                 config = {
                   use_frame_correctness = true
                 },
                 hotkeys = 'default'
               }
)

Install:andUse("WindowScreenLeftAndRight",
               {
                 hotkeys = 'default'
               }
)

Install:andUse("WindowGrid",
               {
                 config = { gridGeometries = { { "6x4" } } },
                 hotkeys = {show_grid = {hyper, "g"}},
                 start = true
               }
)

Install:andUse("ToggleScreenRotation",
               {
                 hotkeys = { first = {hyper, "f15"} }
               }
)

Install:andUse(
  "UniversalArchive",
  {
    disable = true,
    config = {
      evernote_archive_notebook = ".Archive",
      outlook_archive_folder = "Archive (diego.zamboni@swisscom.com)",
      archive_notifications = false
    },
    hotkeys = { archive = { { "ctrl", "cmd" }, "a" } }
  }
)

Install:andUse(
  "TextClipboardHistory",
  {
    config = {
      show_in_menubar = false,
    },
    hotkeys = {
      toggle_clipboard = { { "cmd", "shift" }, "v" } },
    start = true,
  }
)

Install:andUse("Caffeine", {
                 start = true,
                 hotkeys = {
                   toggle = { hyper, "1" }
                 }
})

Install:andUse("MenubarFlag",
               {
                 config = {
                   colors = {
                     ["U.S."] = { },
                     Spanish = {col.green, col.white, col.red},
                     German = {col.black, col.red, col.yellow},
                   }
                 },
                 start = true
               }
)

Install:andUse("MouseCircle",
               {
                 config = {
                   color = hs.drawing.color.x11.rebeccapurple
                 },
                 hotkeys = {
                   show = { hyper, "m" }
                 }
               }
)

Install:andUse("ColorPicker",
               {
                 disable = true,
                 hotkeys = {
                   show = { hyper, "c" }
                 },
                 config = {
                   show_in_menubar = false,
                 },
                 start = true,
               }
)

Install:andUse("TimeMachineProgress",
               {
                 start = true
               }
)

Install:andUse("ToggleSkypeMute",
               {
                 hotkeys = {
                   toggle_skype = { shift_hyper, "v" },
                   toggle_skype_for_business = { shift_hyper, "f" }
                 }
               }
)

Install:andUse("HeadphoneAutoPause",
               {
                 start = true
               }
)

hs.timer.doAt("12:58", function () hs.notify.show("Lunch Time", os.date():sub(1), "") end)
hs.timer.doAt("17:50", function () hs.notify.show("Time reminder", os.date():sub(1), "") end)

function getMousePosition()
  local position = hs.mouse.getAbsolutePosition()
  logger.i("Mouse Position", string.format("%s, %s", position.x, position.y), "")
  hs.notify.show("Mouse Position", "recorded", string.format("%s, %s", position.x, position.y))
  logger.i("Scripting help", string.format("hs.mouse.setAbsolutePosition(hs.geometry.point(%s, %s))", position.x, position.y), "")
  logger.i("Scripting help", string.format("hs.eventtap.leftClick(hs.geometry.point(%s, %s))", position.x, position.y), "")
  logger.i("Scripting help", string.format("hs.timer.doAfter(sec, fn) -> timer", position.x, position.y), "")
end
hs.hotkey.bindSpec({ shift_hyper, "m" }, "log mouse position", getMousePosition)

-- Register browser tab typist: Type URL of current tab of running
-- browser in org mode link format. i.e. [[link][title]]
-- TODO browser in markdown format. i.e. [title](link)
function getBrowserLinkAsOrgModeLink()
    local currentApp = hs.application.frontmostApplication()
    local brave_running = hs.application.applicationsForBundleID("Brave")
    local safari_running = hs.application.applicationsForBundleID("com.apple.Safari")
    local chrome_running = hs.application.applicationsForBundleID("com.google.Chrome")
    local firefox_running = hs.application.applicationsForBundleID("org.mozilla.firefox")

    function dataToOrgLink(data)
        return "[[" .. data[1] .. "][" .. data[2] .. "]]"
    end

    if #brave_running > 0 then
      local stat, data = hs.applescript('tell application "Safari" to get {URL, name} of current tab of window 1')
      if stat then hs.eventtap.keyStrokes(dataToOrgLink(data)) end
    elseif #safari_running > 0 then
      local stat, data = hs.applescript('tell application "Safari" to get {URL, name} of current tab of window 1')
      if stat then hs.eventtap.keyStrokes(dataToOrgLink(data)) end
    elseif #chrome_running > 0 then
      local stat, data = hs.applescript('tell application "Google Chrome" to get {URL, title} of active tab of window 1')
      if stat then hs.eventtap.keyStrokes(dataToOrgLink(data)) end
    elseif #firefox_running > 0 then
      succeeded, parsedOutput, rawOutputOrError = hs.osascript.applescriptFromFile(hs.configdir .. '/get-firefox-url.scpt')
      currentApp:activate()
      -- hs.pasteboard.setContents(dataToOrgLink(parsedOutput))
      -- hs.eventtap.keyStroke({"cmd"}, "v")
      if parsedOutput then hs.eventtap.keyStrokes(dataToOrgLink(parsedOutput)) end
    end
end
hs.hotkey.bindSpec({ hyper, "l" }, "browser URL as org mode link", getBrowserLinkAsOrgModeLink)

hs.hotkey.bindSpec({ hyper, "c" }, "toggle console",hs.toggleConsole)

Install:andUse("Seal",
               {
                 hotkeys = { show = { {"cmd"}, "space" } },
                 fn = function(s)
                   s:loadPlugins({"apps", "calc", "safari_bookmarks", "screencapture", "useractions"})
                   s.plugins.safari_bookmarks.always_open_with_safari = false
                   s.plugins.useractions.actions =
                     {
                         ["Hammerspoon docs webpage"] = {
                           url = "http://hammerspoon.org/docs/",
                           icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
                         },
                         ["Corrector català"] = {
                           url = "https://www.softcatala.org/corrector/",
                           icon = hs.image.imageFromName(hs.image.systemImageNames.Computer),
                         },
                         ["Set default browser to firefox"] = {
                           fn = function () setDefaultBrowser("firefox") end,
                           icon = hs.image.imageFromName(hs.image.systemImageNames.Computer),
                         },
                         ["Set default browser to chrome"] = {
                           fn = function () setDefaultBrowser( "chrome") end,
                           icon = hs.image.imageFromName(hs.image.systemImageNames.Computer),
                         },
                         ["Set default browser to brave"] = {
                           fn = function () setDefaultBrowser("browser") end,
                           icon = hs.image.imageFromName(hs.image.systemImageNames.Computer),
                         },
                         ["WIFI: Leave work (" .. workNetwork .. ")"] = {
                           fn = function()
                             spoon.WiFiTransitions:processTransition(homeNetwork, workNetwork)
                           end,
                           icon = workLogo,
                         },
                         ["WIFI: Arrive work (" .. workNetwork .. ")"] = {
                           fn = function()
                             spoon.WiFiTransitions:processTransition(workNetwork, nil)
                           end,
                           icon = workLogo,
                         },
                         ["WIFI: Arrive home (" .. homeNetwork .. ")"] = {
                           fn = function()
                             spoon.WiFiTransitions:processTransition(homeNetwork, nil)
                           end,
                           icon = workLogo,
                         },
                         ["Translate using Leo"] = {
                           url = "http://dict.leo.org/englisch-deutsch/${query}",
                           icon = 'favicon',
                           keyword = "leo",
                         }
                     }
                   s:refreshAllCommands()
                 end,
                 start = true,
               }
)

function startApp(appName)
  logger.i("start app", string.format("'%s'", appName), "")
  hs.application.launchOrFocus(appName)
end

function stopApp(appName)
  local app = hs.appfinder.appFromName(appName)
  if app then
    logger.i("quit app", string.format("'%s'", appName), "")
    app:kill()
  end
end

function backupToRaspberry()
  local cmd = "~/usr/bin/my-raspberry-sync"
  task = hs.task.new(
    cmd,
    function(exitCode, stdOut, stdErr)
      logger.i("Rsync", "finished", string.format("exitCode: '%s'", exitCode))
    end
  )
  task:start()
end

function manageDocker(action)
  logger.i("Docker", action, "")
  if (action == 'start') then
    output, status, t, rc = hs.execute("~/usr/bin/work-docker.sh", true)
  else
    output, status, t, rc = hs.execute("~/usr/bin/work-docker.sh stop", true)
  end
end

function homeTmuxStart()
  logger.i("Tmux", "start", "")
  output, status, t, rc = hs.execute("~/usr/bin/home-tmux.sh", true)
end

function workTmuxStart()
  logger.i("Tmux", "start", "")
  output, status, t, rc = hs.execute("~/usr/bin/work-tmux.sh", true)
end

function workTmuxStop()
  logger.i("Tmux", "stop", "")
  output, status, t, rc = hs.execute("tmux kill-session -twork", true)
end

function setDefaultBrowser(browserName)
  -- browserName: can be firefox, chrome or browser (brave)
  logger.i("setDefaultBrowser", browserName, "")
  -- defaultbrowser: https://github.com/kerma/defaultbrowser
  local home = hs.fs.pathToAbsolute('~')
  output, status, t, rc = hs.execute(string.format("defaultbrowser %s", browserName), true)
  hs.osascript.applescriptFromFile(hs.configdir .. '/confirm-yes-system-dialog.scpt')
end

function TableConcat(t1,t2)
    local tFinal = {}
    for i=1,#t1 do
        tFinal[#tFinal+1] = t1[i]
    end
    for i=1,#t2 do
        tFinal[#tFinal+1] = t2[i]
    end
    return tFinal
end

leaveWorkGroup = {
  hs.fnutils.partial(manageDocker, "stop"),
  hs.fnutils.partial(stopApp, "Slack"),
  hs.fnutils.partial(stopApp, "com.google.Chrome"),
  hs.fnutils.partial(workTmuxStop),
  hs.fnutils.partial(startApp, "Firefox"),
  hs.fnutils.partial(setDefaultBrowser, "firefox"),
  hs.fnutils.partial(hs.timer.doAfter, 60, hs.fnutils.partial(stopApp, "Docker")),
}

startWorkGroup = {
  hs.fnutils.partial(stopApp, "Firefox"),
  hs.fnutils.partial(startApp, "Slack"),
  hs.fnutils.partial(setDefaultBrowser, "chrome"),
  hs.fnutils.partial(startApp, "com.google.Chrome"),
  hs.fnutils.partial(homeTmuxStart),
  hs.fnutils.partial(startApp, "Docker"),
  hs.fnutils.partial(manageDocker, "start"),
  hs.fnutils.partial(hs.timer.doAfter, 150, workTmuxStart),  -- needs to wait for docker (x seconds)
}

arriveHomeGroup = {
  hs.fnutils.partial(homeTmuxStart),
  backupToRaspberry,
}

function recordTime(action)
  local fileName = homePath .. "/tmp/joined-wifi.txt"
  local file = io.open(fileName, "a")
  file:write(action)
  file:close()
end

Install:andUse(
  "WiFiTransitions",
  {
    config = {
      actions = {
        { -- Test action just to see the SSID transitions
          fn = function(_, _, prev_ssid, new_ssid)
            local date = os.date()
            local transition = string.format("%s from '%s' to '%s'\n", date, prev_ssid, new_ssid)
            recordTime(transition)
            hs.notify.show("SSID change", transition, "")
          end
        },
        {       -- when joining home network do:
          to = homeNetwork,
          fn = TableConcat(arriveHomeGroup, leaveWorkGroup)
        },
        {       -- when joining work network do:
          to = workNetwork,
          fn = startWorkGroup
        },
      }
    },
    start = true,
  }
)

local wm=hs.webview.windowMasks
Install:andUse(
  "PopupTranslateSelection",
  {
    config = {
      popup_style = wm.utility|wm.HUD|wm.titled|wm.closable|wm.resizable,
    },
    hotkeys = {
      translate = { hyper, "t" },
    }
  }
)

Install:andUse(
  "DeepLTranslate",
  {
    disable = true,
    config = {
      popup_style = wm.utility|wm.HUD|wm.titled|wm.closable|wm.resizable,
    },
    hotkeys = {
      translate = { hyper, "e" },
    }
  }
)

local localstuff=loadfile(hs.configdir .. "/init-local.lua")
if localstuff then
  localstuff()
end

hotkeys = hs.hotkey.getHotkeys()
for k, v in pairs(hotkeys) do
  -- idx - a string describing the keyboard combination for the hotkey
  -- msg - the hotkey message, if provided when the hotkey was created
  -- (prefixed with the keyboard combination)
  print(string.format("key %s", v.msg))
end

Install:andUse("FadeLogo",
               {
                 config = {
                   default_run = 1.0,
                 },
                 start = true
               }
)

-- hs.notify.show("Configuration reloaded", "Enjoy!", "")

appBeforeReloading:activate()
