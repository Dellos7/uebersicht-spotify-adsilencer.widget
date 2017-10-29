# This is a simple example Widget, written in CoffeeScript, to get you started
# with Übersicht. For the full documentation please visit:
#
# https://github.com/felixhageloh/uebersicht
#
# You can modify this widget as you see fit, or simply delete this file to
# remove it.

# the CSS style for this widget, written using Stylus
# (http://learnboost.github.io/stylus/)

# the refresh frequency in milliseconds
refreshFrequency: 1000

style: """

  player = 1
  bottom = 10%
  right = 2%

  if player
    display-player = inherit
  else
    display-player = none

  bottom: bottom
  right: right
  background-color: rgba(255,255,255,0.3)
  font-family: "Montserrat", sans-serif
  width: 250px;
  height: 250px;
  border-radius: 400px;
  display: display-player;

  .album-img
    display: block
    margin: 0 auto
    margin-top: 10%

  .track-name
    color: rgb(47,213,102)
    text-align: center
    padding-top: 10px
    margin-left: 17px
    margin-right: 17px
    /*white-space: nowrap
    overflow: hidden
    word-wrap: break-word*/

  .artist-name
    color: rgb(0,0,0)
    text-align: center
    padding-top: 10px

  .player
    text-align: center
    & i
      padding: 15px
      font-size: 1.7em
    & i.hidden
      display: none

  /* vietnamese */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 400;
  src: local('Montserrat Regular'), local('Montserrat-Regular'), url(http://fonts.gstatic.com/s/montserrat/v11/SKK6Nusyv8QPNMtI4j9J2wsYbbCjybiHxArTLjt7FRU.woff2) format('woff2');
  unicode-range: U+0102-0103, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 400;
  src: local('Montserrat Regular'), local('Montserrat-Regular'), url(http://fonts.gstatic.com/s/montserrat/v11/gFXtEMCp1m_YzxsBpKl68gsYbbCjybiHxArTLjt7FRU.woff2) format('woff2');
  unicode-range: U+0100-024F, U+1E00-1EFF, U+20A0-20AB, U+20AD-20CF, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 400;
  src: local('Montserrat Regular'), local('Montserrat-Regular'), url(http://fonts.gstatic.com/s/montserrat/v11/zhcz-_WihjSQC0oHJ9TCYAzyDMXhdD8sAj6OAJTFsBI.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215;
}
/* vietnamese */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 700;
  src: local('Montserrat Bold'), local('Montserrat-Bold'), url(http://fonts.gstatic.com/s/montserrat/v11/IQHow_FEYlDC4Gzy_m8fcnv4bDVR720piddN5sbmjzs.woff2) format('woff2');
  unicode-range: U+0102-0103, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 700;
  src: local('Montserrat Bold'), local('Montserrat-Bold'), url(http://fonts.gstatic.com/s/montserrat/v11/IQHow_FEYlDC4Gzy_m8fcjrEaqfC9P2pvLXik1Kbr9s.woff2) format('woff2');
  unicode-range: U+0100-024F, U+1E00-1EFF, U+20A0-20AB, U+20AD-20CF, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 700;
  src: local('Montserrat Bold'), local('Montserrat-Bold'), url(http://fonts.gstatic.com/s/montserrat/v11/IQHow_FEYlDC4Gzy_m8fcmaVI6zN22yiurzcBKxPjFE.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215;
}

"""

# this is the shell command that gets executed every time this widget refreshes
command: "source Spotify-AdSilencer.widget/spotify-info.sh"

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
render: (output) -> """
  <img name="album-img" class="album-img">
  <div class="track-name" name="track"></div>
  <div class="artist-name" name="artist"></div>
  <div class="player" name="player">
    <i class="fa fa-backward" name="song-backward" aria-hidden="true"></i>
    <i class="fa fa-play" name="song-play" aria-hidden="true"></i>
    <i class="fa fa-pause hidden" name="song-pause" aria-hidden="true"></i>
    <i class="fa fa-forward" name="song-forward" aria-hidden="true"></i>
  </div>
  <link rel="stylesheet" href="Spotify-AdSilencer.widget/css/font-awesome.min.css">
"""

# Update the rendered output.
update: (output, domEl) ->

  adDetected = (self) ->
    $('[name="track"]').html("Ad detected")
    $('[name="artist"]').html("Ad detected")
    $('[name="album-img"]').attr('src','Spotify-AdSilencer.widget/images/ad.png')
    self.run "osascript -e 'tell application \"Spotify\" to set sound volume to 0'"
    self.run "osascript -e 'display notification \"Spotify Ad detected\"'"
    localStorage.setItem "spotifyAd", 1
    #localStorage.setItem "spotifyVolume", 0

  setTrackName = ( trackName ) ->
    trackName = cutStringToFill(trackName)
    
    $('[name="track"]').html(trackName)

  setArtistName = ( artistName ) ->
    artistName = cutStringToFill(artistName)

    $('[name="artist"]').html(artistName)

  setAlbumImage = ( albumUrl ) ->
    $('[name="album-img"]').attr('src',albumUrl)
    $('[name="album-img"]').attr('width','100px')
    $('[name="album-img"]').attr('height','100px')

  getSpotifyVolume = (self, callback) ->
    
    getSpotifyVolumeScript = """
      osascript <<<'tell application "Spotify"
        set soundVolume to sound volume
        return  soundVolume
      end tell'"""

    self.run getSpotifyVolumeScript, (error, data) ->
      if data?
        callback(data)

  setSpotifyVolume = (self,volume) ->
    volume = parseInt(volume, 10) + 1
    setSpotifyVolumeCommand = "osascript -e 'tell application \"Spotify\" to set sound volume to " + volume + "'"
    self.run setSpotifyVolumeCommand

  fromAd = (self) ->
    fromSpotifyAd = localStorage.getItem "spotifyAd"
    if fromSpotifyAd? and fromSpotifyAd is "1"
      spotifyVolume = localStorage.getItem "spotifyVolume"
      setSpotifyVolume(self,spotifyVolume)
      localStorage.setItem "spotifyAd", 0
    else
      getSpotifyVolume( self, (spotifyVolume) ->
        localStorage.setItem "spotifyVolume", spotifyVolume
      )

  cutStringToFill = (string) ->
    maxLength = 27
    stringLength = string.length
    if stringLength > maxLength
      string = string.substring(0,maxLength-2) + " ..."

    return string

  playPausePlayer = (playerState) ->
    if playerState.trim() in ['paused', 'stopped']
      $('[name="song-pause"]').addClass('hidden')
      $('[name="song-play"]').removeClass('hidden')
    else if playerState.trim() in ['playing']
      $('[name="song-play"]').addClass('hidden')
      $('[name="song-pause"]').removeClass('hidden')

  trackInfoArray = output.split "|"
  if trackInfoArray
    trackName = trackInfoArray[0]
    playerState = trackInfoArray[3]
    playPausePlayer(playerState)
    if trackName
      setTrackName(trackName)
      artistName = trackInfoArray[1]
      if artistName
        setArtistName(artistName)
        fromAd(this)
        albumUrl = trackInfoArray[2]
        if albumUrl
          setAlbumImage(albumUrl)
      else
        adDetected(this)

    else
      adDetected(this)
  
afterRender: (domEl)->

  playPauseSong = (self) ->
    self.run "osascript -e 'tell application \"Spotify\" to playpause'"

  forwardSong = (self) ->
    self.run "osascript -e 'tell application \"Spotify\" to next track'"
  
  backwardSong = (self)->
    self.run "osascript -e 'tell application \"Spotify\" to previous track'"

  self = this

  $(domEl).find('[name="song-play"]').on 'click', => 
    playPauseSong(self)
    $('[name="song-play"]').addClass('hidden')
    $('[name="song-pause"]').removeClass('hidden')

  $(domEl).find('[name="song-pause"]').on 'click', => 
    playPauseSong(self)
    $('[name="song-pause"]').addClass('hidden')
    $('[name="song-play"]').removeClass('hidden')

  $(domEl).find('[name="song-forward"]').on 'click', => 
    forwardSong(self)
    $('[name="song-play"]').addClass('hidden')
    $('[name="song-pause"]').removeClass('hidden')

  $(domEl).find('[name="song-backward"]').on 'click', => 
    backwardSong(self)
    $('[name="song-play"]').addClass('hidden')
    $('[name="song-pause"]').removeClass('hidden')