require! fs
muniIDs = fs.readFileSync "#__dirname/../data/okresy_obce.tsv"
  .toString!
  .split "\n"
  .map parseInt _, 10

module.exports.serialize = (input) ->
  | \object is typeof input
    serializeJson input
  | input == "obce"
    String.fromCharCode 1
  | input == "senat"
    String.fromCharCode 2
  | otherwise
    muniId = parseInt input, 10
    id = muniIDs.indexOf muniId
    if id == -1
      null
    else
      String.fromCharCode id + 20

serializeJson = (data) ->
  json = JSON.stringify data
  len = json.length
  prefix = String.fromCharCode 3, len
  prefix + json
