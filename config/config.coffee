module.exports =
  common : 
    port:
      api: 9000
      
    log:
      defaultFile: "log/log.log"
      exceptionsFile: "log/exceptions.log"
      logLevel : "debug"
      exceptionsLevel : "error"

    redis:
      port: 6379
      server: "127.0.0.1"

    jwtSecret: 'aolcp. co ab all urp d.anyf ydcbio cb frgp ncu.'

    mandrill:
      API_key: '37uTbTV2lPW4UG6F_Or4Sg'
  

  development: {}
  test: {}
  production: {}