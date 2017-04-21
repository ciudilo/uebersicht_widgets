command: "query=\"Reservations[*].Instances[].{InstanceId:InstanceId,ImageId:ImageId,InstanceType:InstanceType,LaunchTime:LaunchTime,AZ:Placement.AvailabilityZone,State:State.Name,IP:PublicIpAddress,Name:Tags[?Key=='Name'].Value[]}\";

obj1=[];
obj2=[];

for region in `/usr/local/bin/aws ec2 describe-regions --output text | cut -f3 | grep eu`; \
do
  obj1_tmp=`/usr/local/bin/aws ec2 describe-instances \
  --filters Name=key-name,Values=KirilPiskunov \
  --query  $query \
  --output json --region $region`; \

  obj1=$(echo $obj1 $obj1_tmp | /usr/local/bin/jq -s add);

  obj2_tmp=`/usr/local/bin/aws ec2 describe-instances \
  --filters Name=tag:owner,Values=kiril.piskunov \
  --query $query \
  --output json --region $region`; \

  obj2=$(echo $obj2 $obj2_tmp | /usr/local/bin/jq -s add);

done;

echo $obj1 $obj2 | \
/usr/local/bin/jq -s add | /usr/local/bin/jq 'unique_by(.InstanceId)';

"


refreshFrequency: 300000 # 5 minutes

style: """
  // Change the style of the widget
  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 5px
  border-radius 5px

  left: 20px
  top: 500px
  min-width: 150px
  max-width: 900px
  table    width: 100%
    text-align: right
  table thead tr th
    border-bottom: 1px dashed white
    opacity: 0.5
  table tbody tr:first-child td
  table th:first-child, table td:first-child
    text-align left
  .message
    opacity: 0.5
    text-align: right
  a
    color: white
    text-decoration: none
  td,th
    font-size: 10px
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
  h1
    font-size 12px
    text-transform uppercase
    font-weight bold
"""

render: -> """
  <h1>Running EC2 instances</h1>
  <table></table>
  <p class='message'></p>
"""

update: (output, domEl) ->
  @$domEl = $(domEl)
  @renderTable output

renderTable: (data) ->
  $table = @$domEl.find('table')

  $table.html("""<thead>
               <tr>
                 <th>AZ</th>
                 <th>IP</th>
                 <th>InstanceType</th>
                 <th>Name</th>
                 <th>State</th>
               </tr>
              </thead>
              <tbody></tbody>
              <tfooter></tfooter>
  """)
  $tableBody = $table.find('tbody')

  for key, value of JSON.parse data
      $tableBody.append @renderRow(key, value)

renderRow: (key, value) ->
  isArray = Array.isArray or (obj) -> toString.call(obj) == '[object Array]'
  name = if isArray value.Name then value.name[0] else ""
  return """<tr>
              <td>#{value.AZ}</td>
              <td>#{value.IP}</td>
              <td>#{value.InstanceType}</td>
              <td>#{name}</a></td>
              <td>#{value.LaunchTime}</td>
              <td>#{value.State}</td>
            </tr>"""
