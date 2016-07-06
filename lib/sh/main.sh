#!/bin/bash
function main {
for f in $1/*.xml
do
  b=`basename $f .xml`
  stylesheet=`retrieve_editor $2/$b.json`
  if [[ "$stylesheet" != "null" ]] && [[ "$stylesheet" != "_oup.xsl" ]]
  then
    echo "---------------------------------------------"
    echo "processing $b.xml ..."
    tmp=`remove_dtd $f`
    saxonb-xslt -s:$tmp -xsl:$xsl/$stylesheet -o:$3/$b.xml
  fi
done
xlo $schema $2
}
