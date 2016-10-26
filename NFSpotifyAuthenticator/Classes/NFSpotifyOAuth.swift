//
//  NFSpotifyOAuth.swift
//  Pods
//
//  Created by Neil Francis Hipona on 26/10/2016.
//
//

import Foundation
import Alamofire


public class NFSpotifyOAuth: NSObject {
    
    public static let shared = NFSpotifyOAuth()
    
    public var clientID: String!
    public var clientSecret: String!
    public var redirectURI: String!
    public var userDefaultKey: String!

    private
    override init() {
        super.init()
    }
    
    public
    convenience init(clientID id: String, clientSecret secret: String, redirectURI uri: String, userDefaultKey key: String! = nil) {
        self.init()
        
        let shared = NFSpotifyOAuth.shared
        
        shared.clientID = id
        shared.clientSecret = secret
        shared.redirectURI = uri
        shared.userDefaultKey = key
    }
    
}

// MARK: - Requests

extension NFSpotifyOAuth {
    
    public func accessTokenFromAccessCode(_ code: String, completion: ((_ accessToken: String?, _ tokenObject: [String: AnyObject]?, _ error: Error?) -> Void)? = nil) {
        
        guard let clientID = clientID, let clientSecret = clientSecret, let redirectURI = redirectURI else { return }
        
        let parameters: [String: AnyObject] = ["client_id": clientID as AnyObject, "client_secret": clientSecret as AnyObject, "grant_type": "authorization_code" as AnyObject, "redirect_uri": redirectURI as AnyObject, "code": code as AnyObject]
        
        Alamofire.request(NFSpotifyAutorizationCodeURL, method: .post, parameters: parameters).responseJSON { (response) in
            
            guard let tokenObject = response.result.value as? [String: AnyObject] else { return }
            
            if tokenObject["error"] == nil {
                
                print("new access token: \(tokenObject)")
                var accessTokenCreds: [String: AnyObject] = tokenObject
                
                if let expires_in = tokenObject["expires_in"]?.doubleValue {
                    let expiryDate = Date(timeIntervalSinceNow: expires_in)
                    accessTokenCreds["expiryDate"] = expiryDate as AnyObject
                }
                
                if let key = self.userDefaultKey {
                    let archivedCreds = NSKeyedArchiver.archivedData(withRootObject: accessTokenCreds)
                    UserDefaults.standard.set(archivedCreds, forKey: key)
                    UserDefaults.standard.synchronize()
                }
                
                let accessToken = tokenObject["access_token"] as? String
                completion?(accessToken, tokenObject, nil)
            }else{
                self.processError(responseData: tokenObject, error: response.result.error, completion: completion)
            }
        }
    }
    
    public func renewAccessToken(fromRefreshToken token: String, completion: ((_ accessToken: String?, _ tokenObject: [String: AnyObject]?, _ error: Error?) -> Void)? = nil) {
        
        guard let clientID = clientID, let clientSecret = clientSecret, let redirectURI = redirectURI else { return }
        
        let parameters: [String: AnyObject] = ["client_id": clientID as AnyObject, "client_secret": clientSecret as AnyObject, "grant_type": "refresh_token" as AnyObject, "refresh_token": token as AnyObject]
        
        Alamofire.request(NFSpotifyAutorizationTokenExchangeURL, method: .post, parameters: parameters).responseJSON { (response) in
            
            guard let tokenObject = response.result.value as? [String: AnyObject] else { return }
            
            if tokenObject["error"] == nil {
                
                print("renewed access token: \(tokenObject)")
                var accessTokenCreds: [String: AnyObject] = tokenObject
                
                if let expires_in = tokenObject["expires_in"]?.doubleValue {
                    let expiryDate = Date(timeIntervalSinceNow: expires_in)
                    accessTokenCreds["expiryDate"] = expiryDate as AnyObject
                }
                
                if let key = self.userDefaultKey {
                    let archivedCreds = NSKeyedArchiver.archivedData(withRootObject: accessTokenCreds)
                    UserDefaults.standard.set(archivedCreds, forKey: key)
                    UserDefaults.standard.synchronize()
                }
                
                let accessToken = tokenObject["access_token"] as? String
                completion?(accessToken, tokenObject, nil)
            }else{
                self.processError(responseData: tokenObject, error: response.result.error, completion: completion)
            }
        }
    }
    
    private func processError(responseData response: [String: AnyObject], error: Error?, completion: ((_ accessToken: String?, _ tokenObject: [String: AnyObject]?, _ error: Error?) -> Void)? = nil) {
        
        if let errorInfo = response["error"] as? [String: AnyObject], let code = errorInfo["code"]?.integerValue, let message = ["message"] as? String {
            
            let error = NFSpotifyOAuth.createCustomError(code: code, errorMessage: message)
            
            print("renew access token error: \(error)")
            completion?(nil, nil, error)
        }else if let error = error {
            
            print("renew access token error: \(error)")
            completion?(nil, nil, error)
        }else{
            let error = NFSpotifyOAuth.createCustomError(errorMessage: "Unknown Error")
            
            print("renew access token error: \(error)")
            completion?(nil, nil, error)
        }
    }
}

extension NFSpotifyOAuth {
    
    // MARK: - Error
    
    public class func createCustomError(withDomain domain: String = "com.nf-spotify-o-auth.error", code: Int = 4776, userInfo: [AnyHashable: Any]?) -> Error {
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
    
    public class func createCustomError(withDomain domain: String = "com.nf-spotify-o-auth.error", code: Int = 4776, errorMessage msg: String) -> Error {
        
        return NSError(domain: domain, code: code, userInfo: ["message": msg])
    }
    
}