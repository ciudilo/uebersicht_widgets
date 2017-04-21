command: "ps -ef | grep 'Dropbox.app/Contents/MacOS/Dropbox' &> /dev/null || echo Dropbox is Down"

refreshFrequency: 60000 # ms

render: (output) ->
  "<h1>#{output}</h1>"

style: """
  right: 20px
  bottom: 20px
  color: #FF0000
"""
