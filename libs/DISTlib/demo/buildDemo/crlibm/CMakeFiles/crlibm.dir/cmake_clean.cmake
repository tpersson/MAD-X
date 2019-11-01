file(REMOVE_RECURSE
  "libcrlibm.pdb"
  "libcrlibm.a"
)

# Per-language clean rules from dependency scanning.
foreach(lang C)
  include(CMakeFiles/crlibm.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
