## Changes from most recent to oldest

** 19 Mar 2021 - wpferguson - fixed crash in contrib/HDRmerge.lua**
* Made generated filename routine gracefully handle names that
are not in the expected format.

** 15 Mar 2021 - scheckmedia - updated contrib/photils.lua**
* refactor print method
* add option to apply selected tags from a single image to multiple images
* add setting parameter to enable/disable the export of an image before tag suggestion

** 25 Feb 2021 - wpferguson - added detached mode to contrib/gimp.lua**

* Added run_detached checkbox to the exporter GUI.  Selecting run_detached
let's GIMP keep running and accepting additional images.  It does not return
the edited images to darktable.

**24 Feb 2021 - Mark64 - make ext_editor lib visible in darkroom view**

**17 Feb 2021 - wpferguson - API 6.2.3 register_action changes**

* Added check for API version and supplied a name argument if the 
API version was greater than or equal to 6.2.3 

**10 Feb 2021 - wpferguson - bugfix select_untagged**

* Fixed callback to return a list of images as expected instead of
doing the selection in the callback

**10 Feb 2021 - wpferguson - bugfix API 6.2.1 compatibility**

* The inline check for API version didn't handle argument return
correctly so added a transition library with a register_event function
override to check the API version and process the arguments correctly.

**9 Feb 2021 - wpferguson - bugfix API 6.2.2 compatibility**

* The inline check for API version didn't handle argument return
correctly so changed it to a full if/else block 

**4 Reb 2021 - wpferguson - API 6.2.2 compatibililty**

* Added check for API version and supplied a name argument to register_selection
if the API version was greater than or eqal to 6.2.2 

**1 Feb 2021 - wpferguson - API 6.2.1 compatibility**

* Added check for API version and supplied a name argument to register_event
if the API version was greater than or eqal to 6.2.1 

**21 Jan 2021 - wpferguson - Modified dtutils function find_image_by_id**

* For users with API 6.2.0 or greater - Enabled use of new API function
darktable.database_get_image() in find_image_by_id().

**19 Jan 2021 - schwerdf - Added dtutils library function find_image_by_id()**

* Added new library function to retrieve an image from the library based on it's ID instead
of it's row number in the database 

**10 Jan 2021 - chrisaga - copy_attach_detach_tags localization**

**7 Jan 2021 - dtorop - add contrib/fujifilm_dynamic_range**

* add a new contrib script, fujifilm_dynamic_range to adjust exposure
based on the exposure bias camera setting
