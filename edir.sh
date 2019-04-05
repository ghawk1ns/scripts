#!/usr/bin/env bash

d_flag=''
targetDir=''

print_usage() {
  printf "Usage: encrypt your dropbox data or whevever it lives in the cloud
  -d  decrypt an encrypted directory
  -f  directory name"
}

encrypt() {
  fName=$(basename "$targetDir")
  parentDir=$(dirname "$targetDir")
  compressedFName="$fName.tar.gz"
  encryptedFname="$parentDir/$compressedFName"
  compressedPath="$parentDir/$compressedFName"

  if [[ -e "$compressedPath" ]]; then
    tmpCompressed="$compressedPath+$(date +"%s")"
    cp $compressedPath $tmpCompressed
  fi

  tar czf $compressedPath $targetDir
  # TODO: Support GPG Key
  gpg -c $encryptedFname
  rm $compressedPath

  if [[ -e "$tmpCompressed" ]]; then
    cp $tmpCompressed $compressedPath
    rm $tmpCompressed
  fi
}

decrypt() {
  # TODO: untar decrypted tarball
  gpg $targetDir
}

while getopts 'df:' flag; do
  case "${flag}" in
    d) d_flag=1 ;;
    f) targetDir="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [[ -z $targetDir ]]; then
  print_usage
  exit
fi

if [ $d_flag ]; then
  decrypt
else
  encrypt
fi
