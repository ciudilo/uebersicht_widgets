command: "ps -ef | grep 'Fantastical 2' &> /dev/null || echo Fantastical is Down"

refreshFrequency: 60000 # ms

render: (output) ->
  "<h1>#{output}</h1>"

style: """
  right: 20px
  bottom: 60px
  color: #FF0000
"""
