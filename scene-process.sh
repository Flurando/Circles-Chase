#! /usr/bin/bash

echo "running script"
echo "setting variables of the directories"
DIR_SRC="scenes-wisp"
DIR_DEST="scenes"
echo "variables set"
echo "dealing with backup files"
set +e
rm "$DIR_SRC/*.w~"
rm "$DIR_DEST/*.scm~"
set -e
echo "iterating over the directory"
for FILE in `ls $DIR_SRC`;
do
    echo $FILE
    real="${FILE%.*}"
    echo $real
    wisp2lisp "${DIR_SRC}/${real}.w" > "${DIR_DEST}/${real}.scm"
done
echo "finished"
