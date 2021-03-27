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
to apply a collection filter rule a for color label.
The shortcut will either add a new color label filter or
update the last color label filter in the collection module.

I recommend to set keyboard shortcuts analogous to the ones that set the color label
to the image metadata:
  - `red filter` Shift + F1
  - `yellow filter` Shift + F2
  - `green filter` Shift + F3
  - `blue filter` Shift + F4
  - `purple filter` Shift + F5
  - `clear filter` Shift + F6

this will speed up workflows that are based on color labels.
the idea behind is that a user will mark each step in
his workflow with a dedicated color label.

between each step, the user needs to add/update a filter
rule in the `collect images` module, mainly to reduce
the number of images for the next - more complex - step.

the shortcut functions will search in the actual filter
set for an existing rule for `color label`:
  - if one is found, its value will be updated according
     to the shortcut.
  - if more than one color label rule is present, it will
    update the last one.
  - otherwise a new rule will be added and connected by 
    logical `AND` to the last rule. 

the `clear` shortcut will remove any `color label` rule(s).

an example workflow - starting from selecting a collection
in the `collect images` module:

  - quality culling
    use culling mode for initial quality control (reject/keep, rough star ratings).
    mark images with `red color label`

  - series culling / review in darkroom
    basic adjustments for side-by-side comparisons as needed (i.e. exposure).
    some images may be not sharp enough or should be rejected by other reasons.
    the goal is to select a small subset of images from shooting series.
    mark images with `yellow color label`

  - basic image processing
    apply basic adjustments to your taste, such that the
    result is good enough for external selection/reviewing.
    mark images with `green color label`

  - color grading and retouch
    adjust contrast, color calibration and balance, local contrast,
    denoising, retouch etc.
    all artistic processing to make the image more beautiful.
    only a small subset of all collection images should enter this step.
    mark images with `blue color label`

  - final review, tagging and export
    edit image metadata, tagging and export
    mark images with `purple color label`

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
