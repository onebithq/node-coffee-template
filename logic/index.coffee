path = require("path")
supportFile = ["js", "coffee"]
module.exports = (param) ->
    { fs, _ } = param
    [].forEach (folder) ->
        files = fs.readdirSync(path.join(__dirname, folder))
        files.forEach (file) ->
            return  unless _.contains(supportFile, file.split(".")[1])
            exports[file.replace(/\.js$/, "").replace(/\.coffee$/, "")] = require(path.join(__dirname, folder, file.replace(/\.js$/, "").replace(/\.coffee$/, "")))(param)

    exports