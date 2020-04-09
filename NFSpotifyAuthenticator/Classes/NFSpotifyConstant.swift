//
//  NFSpotifyConstants.swift
//  Pods
//
//  Created by Neil Francis Hipona on 26/10/2016.
//
//

import Foundation

/// Spotify API Base URL
public let NFBaseURLSpotify = "https://api.spotify.com/v1/"

/// Authorization for access code for token exchange
public let NFSpotifyAutorizationCodeURL: String = "https://accounts.spotify.com/authorize/"

/// Exchange code for token
public let NFSpotifyAutorizationTokenExchangeURL: String = "https://accounts.spotify.com/api/token"

/// Authorization Scopes
public let NFSpotifyAvailableScopes: [String] = [
    
    // Image
    "ugc-image-upload",
    
    // Spotify Connect
    "user-read-playback-state",
    "user-modify-playback-state",
    "user-read-currently-playing",
    
    // Playback
    "streaming",
    "app-remote-control",
    
    // Users
    "user-read-email",
    "user-read-private",
    
    // Playlists
    "playlist-read-collaborative",
    "playlist-modify-public",
    "playlist-read-private",
    "playlist-modify-private",
    
    // Library
    "user-library-modify",
    "user-library-read",
    
    // Listening History
    "user-top-read",
    "user-read-playback-position",
    "user-read-recently-played",
    
    // Follow
    "user-follow-read",
    "user-follow-modify"
]
