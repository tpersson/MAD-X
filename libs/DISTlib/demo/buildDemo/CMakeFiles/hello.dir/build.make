# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake3

# The command to remove a file.
RM = /usr/bin/cmake3 -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/tobias/codes/DISTlib/demo

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/tobias/codes/DISTlib/demo/buildDemo

# Include any dependencies generated for this target.
include CMakeFiles/hello.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/hello.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/hello.dir/flags.make

CMakeFiles/hello.dir/demodist.f90.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/demodist.f90.o: ../demodist.f90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building Fortran object CMakeFiles/hello.dir/demodist.f90.o"
	/opt/rh/devtoolset-7/root/usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/tobias/codes/DISTlib/demo/demodist.f90 -o CMakeFiles/hello.dir/demodist.f90.o

CMakeFiles/hello.dir/demodist.f90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/hello.dir/demodist.f90.i"
	/opt/rh/devtoolset-7/root/usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/tobias/codes/DISTlib/demo/demodist.f90 > CMakeFiles/hello.dir/demodist.f90.i

CMakeFiles/hello.dir/demodist.f90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/hello.dir/demodist.f90.s"
	/opt/rh/devtoolset-7/root/usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/tobias/codes/DISTlib/demo/demodist.f90 -o CMakeFiles/hello.dir/demodist.f90.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.o: /home/tobias/codes/DISTlib/source/distgeneration.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.o"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.o   -c /home/tobias/codes/DISTlib/source/distgeneration.c

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.i"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tobias/codes/DISTlib/source/distgeneration.c > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.s"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tobias/codes/DISTlib/source/distgeneration.c -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.o: /home/tobias/codes/DISTlib/source/distinterface.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.o"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.o   -c /home/tobias/codes/DISTlib/source/distinterface.c

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.i"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tobias/codes/DISTlib/source/distinterface.c > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.s"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tobias/codes/DISTlib/source/distinterface.c -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.o: /home/tobias/codes/DISTlib/source/feigen.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.o"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.o   -c /home/tobias/codes/DISTlib/source/feigen.c

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.i"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tobias/codes/DISTlib/source/feigen.c > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.s"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tobias/codes/DISTlib/source/feigen.c -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.o: /home/tobias/codes/DISTlib/source/file_reader.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.o"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.o   -c /home/tobias/codes/DISTlib/source/file_reader.c

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.i"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tobias/codes/DISTlib/source/file_reader.c > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.s"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tobias/codes/DISTlib/source/file_reader.c -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.o: /home/tobias/codes/DISTlib/source/helper.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building C object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.o"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.o   -c /home/tobias/codes/DISTlib/source/helper.c

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.i"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tobias/codes/DISTlib/source/helper.c > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.s"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tobias/codes/DISTlib/source/helper.c -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.o: /home/tobias/codes/DISTlib/source/mod_dist.f90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building Fortran object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.o"
	/opt/rh/devtoolset-7/root/usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/tobias/codes/DISTlib/source/mod_dist.f90 -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.o

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.i"
	/opt/rh/devtoolset-7/root/usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/tobias/codes/DISTlib/source/mod_dist.f90 > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.s"
	/opt/rh/devtoolset-7/root/usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/tobias/codes/DISTlib/source/mod_dist.f90 -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.s

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.o: CMakeFiles/hello.dir/flags.make
CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.o: /home/tobias/codes/DISTlib/source/outputdist.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building C object CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.o"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.o   -c /home/tobias/codes/DISTlib/source/outputdist.c

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.i"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tobias/codes/DISTlib/source/outputdist.c > CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.i

CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.s"
	/opt/rh/devtoolset-7/root/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tobias/codes/DISTlib/source/outputdist.c -o CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.s

# Object files for target hello
hello_OBJECTS = \
"CMakeFiles/hello.dir/demodist.f90.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.o" \
"CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.o"

# External object files for target hello
hello_EXTERNAL_OBJECTS =

libhello.so: CMakeFiles/hello.dir/demodist.f90.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distgeneration.c.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/distinterface.c.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/feigen.c.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/file_reader.c.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/helper.c.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/mod_dist.f90.o
libhello.so: CMakeFiles/hello.dir/home/tobias/codes/DISTlib/source/outputdist.c.o
libhello.so: CMakeFiles/hello.dir/build.make
libhello.so: CMakeFiles/hello.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Linking Fortran shared library libhello.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/hello.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/hello.dir/build: libhello.so

.PHONY : CMakeFiles/hello.dir/build

CMakeFiles/hello.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/hello.dir/cmake_clean.cmake
.PHONY : CMakeFiles/hello.dir/clean

CMakeFiles/hello.dir/depend:
	cd /home/tobias/codes/DISTlib/demo/buildDemo && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tobias/codes/DISTlib/demo /home/tobias/codes/DISTlib/demo /home/tobias/codes/DISTlib/demo/buildDemo /home/tobias/codes/DISTlib/demo/buildDemo /home/tobias/codes/DISTlib/demo/buildDemo/CMakeFiles/hello.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/hello.dir/depend

