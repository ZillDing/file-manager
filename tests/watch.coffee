# Watches the cjsx file
exec = require('child_process').exec
Gaze = require('gaze').Gaze

gaze = new Gaze [__dirname + '/*.cjsx']

gaze.on 'ready', (watcher) ->
	console.log 'start watching...'

gaze.on 'all', (event, filepath) ->
	console.log "event: #{event}"
	console.log "file: #{filepath}"
	console.log "timestamp: #{new Date()}"
	console.log ''
	exec "cjsx -o #{__dirname}/../ -cb #{filepath}", (error, stdout, stderr) ->
		console.log stdout if stdout
		console.error stderr if stderr
		if error?
			console.error "exec error: #{error}"
		console.log '########################## done #############################'
