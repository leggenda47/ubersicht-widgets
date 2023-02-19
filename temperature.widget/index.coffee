command: 'curl -sS https://www.idokep.hu/elorejelzes/Budapest | grep -Eo "Várható hőmérséklet: ([0-9]+)" | cut -d" " -f3 | head -n1'
refreshFrequency: 5 * 60 * 1000

style: """
  bottom: 10px
  left: 589px
  // left: 658px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

    &:after
      content: 'temperature'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px

  td
    background: rgba(#000, 0.35)
    border: 1px solid #fff
    font-size: 22px
    font-weight: 200
    min-width: 75px
    max-width: auto
    text-shadow: 0 0 1px rgba(#000, 0.5)
    display: flex

  .wrapper
    padding: 4px 6px 4px 6px
    position: relative
"""


render: -> """
  <table>
    <tr>
      <td class='col1'></td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (a) ->
    "<div class='wrapper'>" +
      "#{a} ℃" +
    "</div>"

  args = processes[0].split(',')
  table.find(".col1").html renderProcess(args...)
