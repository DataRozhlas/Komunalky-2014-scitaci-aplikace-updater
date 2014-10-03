require! {
  http
  request
}
http.globalAgent.maxSockets = 1000
# setTimeout process.exit, 100000
for i in [0 til 1000]
  req = http.request do
    * host: "localhost"
      port: 8080
      path: "/sse"
    * (res) ->
        res.on \data ->
          it .= toString!
          out = for i in [0 til it.length]
            it.charCodeAt i
          console.log it, out

  req.end!


  request.get "http://localhost:8080/sse", (err, res, body) ->
    console.log err
