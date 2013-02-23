#!/bin/sh

d=/tmp/scripts
sudo rm -r $d
mkdir -p $d
cd $d
cp -r /etc/pam.d .
mv pam.d test
chown -R lfs test
chmod -R o-rwx test
pwd
ls -l test

