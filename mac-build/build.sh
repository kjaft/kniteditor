#!/bin/bash

set -e

HERE="`dirname \"$0\"`"
cd "$HERE"

(
  cd ..

  echo "# removing old installation of kniteditor"
  python3 -m pip uninstall -y kniteditor || true

  echo "# build the distribution"
  python3 -m pip install --user wheel
  python3 setup.py sdist --formats=zip
  python3 setup.py bdist_wheel
  python3 -m pip uninstall -y wheel

  echo "# install the current version from the build"
  python3 -m pip install --user --upgrade dist/kniteditor-*.zip

  echo "# install test requirements"
  python3 -m pip install --user --upgrade -r test-requirements.txt
)

echo "# build the app"
python3 -m PyInstaller KnitEditor.spec

echo "# create the .dmg file"
# see http://stackoverflow.com/a/367826/1320237
# create the .dmg file
rm -f dist/KnitEditor.dmg
hdiutil create -srcfolder dist/KnitEditor.app dist/KnitEditor.dmg
