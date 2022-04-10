command: '/opt/homebrew/bin/displayplacer list | grep -m 1 "Hertz" | cut -d" " -f2'

style: """
  bottom: 10px
  left: 524px
  // left: 658px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

    &:after
      content: 'refresh rate'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px

  td
    border: 1px solid #fff
    font-size: 22px
    font-weight: 200
    width: 51px
    max-width: 51px
    overflow: hidden
    text-shadow: 0 0 1px rgba(#000, 0.5)
    display: flex

  .wrapper
    padding: 4px 6px 4px 6px
    position: relative

  .col1
    background: rgba(#000, 0.35)

  p
    padding: 0
    margin: 0
    font-size: 11px
    font-weight: normal
    max-width: 100%
    color: #eee
    opacity: 0
    text-overflow: ellipsis
    text-shadow: none

  .pid
    position: absolute
    top: 2px
    right: 2px
    font-size: 10px
    font-weight: normal

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

  renderProcess = (cpu) ->
    "<div class='wrapper'>" +
      "#{cpu}" +
    "</div>"

  args = processes[0].split(',')
  table.find(".col1").html renderProcess(args...)
