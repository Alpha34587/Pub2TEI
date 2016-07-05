function remove_dtd {
  tmp="/tmp/$b.xml"
  xsltproc --novalid $xsl/remove_dtd.xsl $1 > $tmp
  echo $tmp
}
