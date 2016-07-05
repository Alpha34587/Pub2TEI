function retrieve_editor {
  editor=`jq -r ".corpusName" $1`
  echo `jq -r ".$editor" $meta`
}
