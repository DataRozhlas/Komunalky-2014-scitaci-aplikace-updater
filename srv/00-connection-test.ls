require! {
  http
  https
  request
  async
}
http.globalAgent.maxSockets = 3000
https.globalAgent.maxSockets = 3000
process.on \uncaughtException -> console.log it
async.eachLimit [0 til 3000], 5, (i, cb) ->
  opts1 =
    mod: https.request
    host: "samizdat.cz"
    port: 443
    path: "/sse/"
  opts2 =
    mod: http.request
    host: "samizdatcz.cloudapp.net"
    port: 8081
    path: "/sse"

  opt = if i % 2 then opts1 else opts2
  req = opt.mod do
    * opt
    * (res) ->
        console.log 'a'
        res.on \data ->
          it .= toString!
          out = for i in [0 til it.length]
            it.charCodeAt i
          # console.log it, out
          # console.log out
          console.log it
        cb!

  req.end!
# j = 0
# for i in [0 til 3000]
#   j++
#   request.get "http://samizdatcz.cloudapp.net/sse", (err, res, body) ->
#     if err
#       console.log err
#       j--
#       console.log j
