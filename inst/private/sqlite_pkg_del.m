## Copyright (C) 2022 John Donoghue <john.donoghue@ieee.org>
##
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {} sqlite_pkg_del()
## private function
## @end deftypefn
function sqlite_pkg_del ()

  # on package unload, attempt to unload docs
  try
    pkg_dir = fileparts (fullfile (mfilename ("fullpath")));
    doc_file = fullfile (pkg_dir, "..", "doc", "octave-sqlite.qch");
    doc_file = strrep (doc_file, '\', '/');
    if exist(doc_file, "file")
      if exist("__event_manager_unregister_documentation__")
        __event_manager_unregister_documentation__ (doc_file);
      elseif exist("__event_manager_unregister_doc__")
        __event_manager_unregister_doc__ (doc_file);
      endif
    endif
  catch
    # do nothing
  end_try_catch

  # unload any compatibility functions
  try
    pkg_dir = fileparts (fullfile (mfilename ("fullpath")));
    remove_path_if_exists(fullfile(pkg_dir, "..", "compatibility", "table"));
    remove_path_if_exists(fullfile(pkg_dir, "..", "compatibility", "rowfilter"));
  catch
    # do nothing
  end_try_catch

endfunction

function remove_path_if_exists(f)
  # find the full name in path list and if exsists, remove it
  f = canonicalize_file_name(f);
  found = [];
  curr_paths = strsplit(path(), pathsep());
  for idx = 1:length(curr_paths)
    if strcmp(f, curr_paths{idx})
      found = f;
      break;
    endif
  endfor
  if ! isempty(found)
    rmpath (found);
  endif
endfunction
