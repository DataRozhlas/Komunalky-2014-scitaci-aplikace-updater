require! {
  './config'
  './Serializer'
  './UpdateEmitter'
  http
  redis
  SSE: sse
}
keepAlive = String.fromCharCode 4
hello = String.fromCharCode 5
clients = []
redisSubscriber = redis.createClient config.redis.port, config.redis.host
(err) <~ redisSubscriber.auth config.redis.key

updateEmitter = new UpdateEmitter config.UpdateEmitter, redisSubscriber
updateEmitter.on \updates (messages) ->
  out = messages.map Serializer.serialize .join ''
  console.log "Sending message to #{clients.length} clients"
  clients.forEach -> it.send out

sendKeepAlive = ->
  console.log "Keeping alive #{clients.length} clients"
  clients.forEach -> it.send keepAlive

setInterval sendKeepAlive, 30000
server = http.createServer (req, res) ->
  console.log "Normal request, shouldn't happen"
  res.writeHead do
    * 200
    * "OK"
    * "Content-type": "text/plain"
      "Access-Control-Allow-Origin": "*"

  res.end!

<~ server.listen config.server.port
sse = new SSE server
console.log "Listening, probably"
sse.on \connection (client) ->
  clients.push client
  client.send hello
  console.log "+1 = #{clients.length}"
  client.on \close ->
    index = clients.indexOf client
    return if index == -1
    clients.splice index, 1
    console.log "-1 = #{clients.length}"
