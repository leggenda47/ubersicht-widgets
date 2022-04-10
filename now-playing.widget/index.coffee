options =
  # Enable or disable the widget.
  widgetEnable : true                   # true | false

command: "osascript 'now-playing.widget/lib/getMusicData.applescript'"
refreshFrequency: '1s'
style: """

// setup
// --------------------------------------------------
display: none
font-family system, -apple-system, "Helvetica Neue"
font-size: 10px
position: absolute
bottom: 10px
left: 589px
border: 1px solid white
color: #fff
background: rgba(#000, 0.35)


// variables
// --------------------------------------------------
widgetWidth 240px
borderRadius 6px
infoHeight 31px
infoWidth @widgetWidth - @infoHeight - 10px

// styles
// --------------------------------------------------
.container
    width: @widgetWidth
    height: @infoHeight
    text-align: left
    position: relative
    clear: both
    color #fff
    padding 10px
    border-radius @borderRadius

.album-art
    width: @infoHeight
    height: @width
    border-radius @borderRadius
    background-image: url(now-playing.widget/lib/default.png)
    background-size: cover
    float: left

.track-info
    width: @infoWidth
    height: @infoHeight
    margin-left: 10px
    position: relative
    float: left

.artist-name
    font-weight: bold
    text-transform: uppercase
    margin-top: 3px
    margin-bottom: 5px
    overflow: hidden
    white-space: nowrap
    text-overflow: ellipsis
    float: left
    width: 185px

.song-year
    position: absolute
    right: 0
    font-weight: bold
    text-transform: uppercase
    margin-top: 3px
    margin-bottom: 5px
    text-align: right
    overflow: hidden
    white-space: nowrap
    text-overflow: ellipsis
    float: right
    width: 28px

.is-loved
    display: none
    font-weight: bold
    text-transform: uppercase
    margin-top: 3px
    margin-left: 5px
    overflow: hidden
    white-space: nowrap
    text-overflow: ellipsis
    width: 10px

.song-name
    position: absolute
    top: 0
    left: 0
    font-size: 11px
    text-transform: uppercase
    margin-bottom: 5px
    overflow: hidden
    white-space: nowrap
    text-overflow: ellipsis
    float: left
    width: @infoWidth

.album-name
    font-weight: bold
    text-transform: uppercase
    margin-right: 5px
    overflow: hidden
    white-space: nowrap
    text-overflow: ellipsis
    float: left
    width: 218px

.bar-container
    width: 100%
    height: @borderRadius
    border-radius: @borderRadius
    background: rgba(#fff, .5)
    position: absolute
    bottom: 4px

.bar
    height: @borderRadius
    border-radius: @borderRadius
    transition: width .2s ease-in-out

.bar-progress
    background: rgba(#fff, .85)

.container:before
    content: 'music'
    position: absolute
    left: 0
    top: -14px
"""

options : options

render: () -> """
<div class="container">
    <div class="album-art"><div class="is-loved">&hearts;</div></div>
    <div class="track-info">
        <div class="artist-name"></div><div class="song-year"></div>
        <div class="song-name"></div>
        <!-- <div class="album-name"></div> -->
        <div class="bar-container">
            <div class="bar bar-progress"></div>
        </div>
        <div class="console"></div>
    </div>
</div>
"""

# Update the rendered output.
update: (output, domEl) ->

  div = $(domEl)

  # if widget enabled
  if @options.widgetEnable

    # if not output then hide the widget
    if !output
      div.animate({opacity: 0}, 250, 'swing').hide(1)

    # if output then show
    else
      # gather script values
      values = output.slice(0,-1).split(" @ ")
      # div.find('.artist-name').html(values[0])
      div.find('.song-name').html(values[1] + " / " + values[0])
      div.find('.album-name').html(values[2])
      songDuration = values[4]
      currentPosition = values[5]
      coverURL = values[6]
      songChanged = values[7]
      isLoved = values[8]

      # set progress bar width
      barWidth = 218
      # figure out current position
      songProgress = (currentPosition / songDuration) * barWidth
      # set progress bar width
      div.find('.bar-progress').css width: songProgress

      # get current cover art
      currentCoverURL = "/" + div.find('.album-art').css('background-image').split('/').slice(-3).join().replace(/\,/g, '/').slice(0,-1)

      # if the art changed then update it
      if currentCoverURL isnt coverURL and coverURL isnt 'NA' and coverURL isnt ''
        artwork = div.find('.album-art')
        artwork.css('background-image', 'url('+coverURL+')')

      # if no cover art then show default image
      # else if coverURL is 'NA'
      else
        artwork = div.find('.album-art')
        artwork.css('background-image', 'url(now-playing.widget/lib/default.png)')

      # if song isLoved then show heart
      if isLoved == 'true'
        div.find('.is-loved').css('display', 'block')
      # else hide heart
      else
        div.find('.is-loved').css('display', 'none')

      # show the widget
      div.show(1).animate({opacity: 1}, 250, 'swing')

  # hide widget if disabled
  else
    div.hide()
