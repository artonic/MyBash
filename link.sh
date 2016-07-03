#!/bin/bash
PWD=$(pwd)

rm /bin/git-completion.bash
rm ~/.bashrc
rm ~/.nanorc
rm -r ~/.nano
rm ~/.config/openbox/rc.xml

ln -s $PWD/git-completion.bash /bin/git-completion.bash
ln -s $PWD/my.bashrc ~/.bashrc
ln -s $PWD/my.nanorc ~/.nanorc
ln -s $PWD/my.nano ~/.nano
ln -s $PWD/my.openbox ~/.config/openbox/rc.xml
