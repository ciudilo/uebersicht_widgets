command: "ps -ef | pgrep RescueTime &> /dev/null || echo RescueTime is Down"

refreshFrequency: 60000 # ms

render: (output) ->
  "<h1>#{output}</h1>"

style: """
  right: 20px
  bottom: 100px
  color: #FF0000
"""
