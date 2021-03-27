--[[Collection shortcuts plugin for darktable

  copyright (c) 2021  Rene Kowalke
  
  darktable is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  darktable is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with darktable.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[About this plugin
This plugin adds the possibility to assign shortcuts(s) in the preferences
to color labels. The shortcut will either add a new color label filter or
update the topmost color label filter in the collection module.

----REQUIRED SOFTWARE----
NA

----USAGE----
Install: (see here for more detail: https://github.com/darktable-org/lua-scripts )
 1) Copy this file in to your "lua/contrib" folder where all other scripts reside. 
 2) Require this file in your luarc file, as with any other dt plug-in

Select the photo you wish to change you collection based on.
In the "Selected Images" module click on "Collect on this Image"

----KNOWN ISSUES----
]]

local dt = require "darktable"
local previous = nil

-- for color labels we use global darktable translations
local label_red = dt.gettext.gettext('red')
local label_yellow = dt.gettext.gettext('yellow')
local label_green = dt.gettext.gettext('green')
local label_blue = dt.gettext.gettext('blue')
local label_purple = dt.gettext.gettext('purple')

local function clear_color_label_filter()
	local rules = dt.gui.libs.collect.filter()
	for _,rule in pairs(rules) do
		-- reuse the latest colorlabel rule
		if rule.item == "DT_COLLECTION_PROP_COLORLABEL" then
			rules[_] = nil
			-- no break, find latest
		end
	end
	previous = dt.gui.libs.collect.filter(rules)
end

local function set_color_label_filter(label)
	local rules = dt.gui.libs.collect.filter()
	local color_rule = nil
	for _,rule in pairs(rules) do
		-- reuse the latest colorlabel rule
		if rule.item == "DT_COLLECTION_PROP_COLORLABEL" then
			color_rule = rule
			-- no break, find latest
		end
	end
	if color_rule == nil then
		color_rule = dt.gui.libs.collect.new_rule()
	    color_rule.mode = "DT_LIB_COLLECT_MODE_AND"
		color_rule.item = "DT_COLLECTION_PROP_COLORLABEL"
		table.insert(rules, color_rule)
	end
	color_rule.data = label
	previous = dt.gui.libs.collect.filter(rules)
end

-- shortcuts for collection filters
dt.register_event("collection_shortcuts", "shortcut",
	function() clear_color_label_filter() end,
	'Remove color label from collection rules'
)
dt.register_event("collection_shortcuts", "shortcut",
	function() set_color_label_filter(label_red) end,
	'Apply red color label as collection rule'
)
dt.register_event("collection_shortcuts", "shortcut",
	function() set_color_label_filter(label_yellow) end,
	'Apply yellow color label as collection rule'
)
dt.register_event("collection_shortcuts", "shortcut",
	function() set_color_label_filter(label_green) end,
	'Apply green color label as collection rule'
)
dt.register_event("collection_shortcuts", "shortcut",
	function() set_color_label_filter(label_blue) end,
	'Apply blue color label as collection rule'
)
dt.register_event("collection_shortcuts", "shortcut",
	function() set_color_label_filter(label_purple) end,
	'Apply purple color label as collection rule'
)
