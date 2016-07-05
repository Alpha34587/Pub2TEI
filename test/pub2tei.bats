#!/usr/bin/env bats
source "../lib/sh/retrieve_editor.sh"
source "../lib/sh/remove_dtd.sh"
xsl="../lib/xsl"
meta="../lib/metadata_to_xsl.json"
res="resources/pub2tei"

@test "apply the good xsl stylesheet" {
  result=`retrieve_editor $res/meta.json ../lib/metadata_to_xsl.json`
  echo $result
  [[ "$result" == "_oup.xsl" ]]
}

@test "do nothing if the metadata is empty" {
  result=`retrieve_editor $res/meta_empty.json ../lib/metadata_to_xsl.json`
  echo $result
  [[ "$result" == "null" ]]
}

@test "check if doctype is well remove" {
  b="test"
  tmp=`remove_dtd $res/test.xml`
  result=`diff $tmp $res/test-expected.xml`
  echo $result
  [[ "$result" == "" ]]
}
