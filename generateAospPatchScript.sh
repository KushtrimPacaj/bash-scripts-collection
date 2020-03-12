
#Generates script to apply patches from folder structure 
#For example if you have the following structure:
#  ~/patch/A/subA/*.patch , and patches which have subA as "patch root",
#  meaning they should be applied like this: "cd subA ; patch -p1 < *.patch"
#  then this script generates a script with commands that will do exactly then in bulk.
#
# Sample script output:
#	echo "Entering directory: $PWD"
#	echo "Applying 0001-Fix-in-handling-header-decode-errors.bulletin.patch"
#	cd ./external/libmpeg2
#	patch -p1 < /home/kushtrim/Desktop/patches/platform/external/libmpeg2/0001-Fix-in-handling-header-decode-errors.bulletin.patch
#	cd - > /dev/null
#	echo "---------------------------------"
	

function generateAospPatchScript(){
echo ". build/envsetup.sh > /dev/null" > applyPatches.sh

find . -type f -name "*.patch" | sort -n | xargs -I '{}' sh -c '\
dName=$(dirname {}) ; \
rName=$(realpath {}) ; \
fName=$(basename $rName); \
echo "\n\
cd $dName\n\
echo \"Entering directory: \$PWD\"\n\
echo \"Applying $fName\"\n\
patch -p1 --no-backup-if-mismatch < $rName\n\
croot > /dev/null\n\
echo \"---------------------------------\"\n\n"' \; >> applyPatches.sh

chmod +x applyPatches.sh
}

