#!/bin/bash
. lib.sh
# tputcolors

echo
echo -e "$(tput bold) reg  bld  und   tput-command-colors$(tput sgr0)"

for i in $(seq 1 7); do
  echo " $(tput setaf $i)Text$(tput sgr0) $(tput bold)$(tput setaf $i)Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Text$(tput sgr0)  \$(tput setaf $i)"
done

echo ' Bold            $(tput bold)'
echo ' Underline       $(tput sgr 0 1)'
echo ' Reset           $(tput sgr0)'
echo
echo " $(tput setaf 2)Text$(tput sgr0) " 
echo "Normal"
echo " $(tput bold)$(tput setaf 2)Text$(tput sgr0) " 
echo "Normal"
render 'I like linux very much.'