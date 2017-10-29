#!/bin/bash

trackInfo=`osascript <<<'tell application "Spotify"
        set theTrack to current track
        set theArtist to artist of theTrack
        set trackName to name of theTrack
        set artworkUrl to artwork url of theTrack
        set playerState to player state
        return  trackName & "|" & theArtist & "|" & artworkUrl & "|" & playerState
    end tell'`;

echo $trackInfo;