require! {
  '../src/config'
  redis
}

obce = <[ obce senat 500054 500089 500097 500119 500143 500178 500186 500208 500216 500224 547034 547107 539694 547361 547387 547042 547051 539724 539791 539449 539465 539601 539635 539678 547115 539864 539899 547140 547158 539589 547174 547271 538124 547298 547301 538060 547310 538175 538213 547344 538302 538353 547417 538736 538949 539007]>


redisClient = redis.createClient config.redis.port, config.redis.host
(err) <~ redisClient.auth config.redis.key

mrdat = ->
  obec = Math.floor Math.random! * obce.length
  console.log obce[obec]
  redisClient.publish "update", obce[obec]

# setInterval mrdat, 250
redisClient.publish "update", "500208"
setTimeout process.exit, 5000
