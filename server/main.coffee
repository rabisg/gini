if _.isUndefined Gini
  console.log "Fatal Error! Variable Gini not defined"
  process.abort

startup = ->
  console.log "Started"
  return

Gini.startup startup