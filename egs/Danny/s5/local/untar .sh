#!/usr/bin/env bash

# Copyright   2014  Johns Hopkins University (author: Daniel Povey)
#             2017  Luminar Technologies, Inc. (author: Daniel Galvez)
#             2017  Ewald Enzinger
# Apache 2.0

# Adapted from egs/mini_librispeech/s5/local/download_and_untar.sh (commit 1cd6d2ac3a935009fdc4184cb8a72ddad98fe7d9)

remove_archive=false

if [ "$1" == --remove-archive ]; then
  remove_archive=true
  shift
fi

if [ $# -ne 2 ]; then
  echo "Usage: $0 [--remove-archive] <data-base> <url>"
  echo "e.g.: $0 /export/data/ https://common-voice-data-download.s3.amazonaws.com/cv_corpus_v1.tar.gz"
  echo "With --remove-archive it will remove the archive after successfully un-tarring it."
fi

data=$1


if [ ! -d "$data" ]; then
  echo "$0: no such directory $data"
  exit 1;
fi


if [ -f $data/cv_corpus_v1/.complete ]; then
  echo "$0: data was already successfully extracted, nothing to do."
  exit 0;
fi

filepath="$data/cv_corpus_v1.tar.gz"
filesize="5423510"

if [ -f $filepath ]; then
  size=$(/bin/ls -l $filepath | awk '{print $5}')
  size_ok=false
  if [ "$filesize" -eq "$size" ]; then size_ok=true; fi;
  if ! $size_ok; then
    echo "$0: removing existing file $filepath because its size in bytes ($size)"
    echo "does not equal the size of the archives ($filesize)."
    rm $filepath
  else
    echo "$filepath exists and appears to be complete."
  fi
fi

cd $data

if ! tar -xzf $filepath; then
  echo "$0: error un-tarring archive $filepath"
  exit 1;
fi

touch $data/cv_corpus_v1/.complete

echo "$0: Successfully downloaded and un-tarred $filepath"

if $remove_archive; then
  echo "$0: removing $filepath file since --remove-archive option was supplied."
  rm $filepath
fi
