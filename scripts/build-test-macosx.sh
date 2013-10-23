# run:
# sh scripts/build-test-macosx.sh [cleanall]
# tail -f build-test-macosx.out

# I/O redirection
rm -f build-test-macosx.out
exec 1> build-test-macosx.out 2>&1
uname -n > build-test-macosx.run

# env settings
export LC_CTYPE="C"
export PATH=/Users/mad/Projects/madX:/opt/local/bin:$PATH

echo "\n===== Start of build and tests ====="
date
uname -m -n -r -s

echo "\n===== SVN update ====="
svn update
[ "$?" != "0" ] && echo "ERROR: svn update failed"

echo "\n===== Release number ====="
cat VERSION

echo "\n===== Clean build ====="
if [ "$1" = "cleanall" ] ; then
	make cleanall ; make cleanall ARCH=32
else
	echo "Skipped (no explicit request)."
fi 

echo "\n===== Gnu build ====="
gcc      --version
g++      --version
gfortran --version
make all-macosx-gnu
[ "$?" != "0" ] && echo "ERROR: make all-macosx-gnu failed"

echo "\n===== Intel build ====="
icc      --version
ifort    --version
make all-macosx-intel all-macosx
[ "$?" != "0" ] && echo "ERROR: make all-macosx-intel failed"

echo "\n===== Dependencies ====="
make infobindep

echo "\n===== Gnu tests (32 bit) ====="
make madx-macosx32-gnu && ls -l madx32 && make tests-all ARCH=32 NOCOLOR=yes
[ "$?" != "0" ] && echo "ERROR: make tests-all for madx-macosx32-gnu failed"

echo "\n===== Gnu tests (64 bit) ====="
make madx-macosx64-gnu && ls -l madx64 && make tests-all ARCH=64 NOCOLOR=yes
[ "$?" != "0" ] && echo "ERROR: make tests-all for madx-macosx64-gnu failed"

echo "\n===== Intel tests (32 bit) ====="
make madx-macosx32-intel && ls -l madx32 && make tests-all ARCH=32 NOCOLOR=yes
[ "$?" != "0" ] && echo "ERROR: make tests-all for madx-macosx32-intel failed"

echo "\n===== Intel tests (64 bit) ====="
make madx-macosx64-intel && ls -l madx64 && make tests-all ARCH=64 NOCOLOR=yes
[ "$?" != "0" ] && echo "ERROR: make tests-all for madx-macosx64-intel failed"

echo "\n===== End of build and tests ====="
date

echo "finished" > build-test-macosx.run
