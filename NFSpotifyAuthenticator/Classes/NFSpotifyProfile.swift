//
//  NFSpotifyProfile.swift
//  Pods
//
//  Created by Neil Francis Hipona on 26/10/2016.
//
//

import Foundation
import Alamofire

open class NFSpotifyProfile: NSObject, NSCoding {
    
    static public let me = NFSpotifyProfile()
    
    // MARK: - Declarations
    
    open var id: String!
    open var birthdate: String!
    open var country: String!
    open var display_name: String!
    open var email: String!
    open var href: String!
    open var followers: Int = 0
    open var image_url: String!
    open var product: String!
    open var type: String!
    open var uri: String!
    
    open var profileCacheKey: String!
    
    // MARK: - Initializers
    
    private
    override init() {
        super.init()
    }
    
    convenience public init(profileInfo: [String: AnyObject]) {
        self.init()
        
        updateProfile(info: profileInfo)
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let i = aDecoder.decodeObject(forKey: "id") as? String else { return nil }
        
        let me = NFSpotifyProfile.me
        
        me.id = i
        
        me.birthdate = aDecoder.decodeObject(forKey: "birthdate") as? String
        me.country = aDecoder.decodeObject(forKey: "country") as? String
        me.display_name = aDecoder.decodeObject(forKey: "display_name") as? String
        me.email = aDecoder.decodeObject(forKey: "email") as? String
        me.href = aDecoder.decodeObject(forKey: "href") as? String
        
        if let f = aDecoder.decodeObject(forKey: "followers"), let count = (f as AnyObject).integerValue {
            me.followers = count
        }else{
            me.followers = 0
        }
        
        me.image_url = aDecoder.decodeObject(forKey: "image_url") as? String
        me.product = aDecoder.decodeObject(forKey: "product") as? String
        me.type = aDecoder.decodeObject(forKey: "type") as? String
        me.uri = aDecoder.decodeObject(forKey: "uri") as? String
        
        return nil
    }
    
    
    public func encode(with aCoder: NSCoder) {
        
        let me = NFSpotifyProfile.me
        
        aCoder.encode(me.id, forKey: "id")
        aCoder.encode(me.birthdate, forKey: "birthdate")
        aCoder.encode(me.country, forKey: "country")
        aCoder.encode(me.display_name, forKey: "display_name")
        aCoder.encode(me.email, forKey: "email")
        aCoder.encode(me.href, forKey: "href")
        aCoder.encode(me.followers, forKey: "followers")
        aCoder.encode(me.image_url, forKey: "image_url")
        aCoder.encode(me.product, forKey: "product")
        aCoder.encode(me.type, forKey: "type")
        aCoder.encode(me.uri, forKey: "uri")
        
    }
}

// MARK: - Controls

extension NFSpotifyProfile {
    
    open func updateProfile(info profileInfo: [String: AnyObject]) {
        
        let me = NFSpotifyProfile.me
        
        me.id = profileInfo["id"] as? String
        me.birthdate = profileInfo["birthdate"] as? String
        me.country = profileInfo["country"] as? String
        me.display_name = profileInfo["display_name"] as? String
        me.email = profileInfo["email"] as? String
        me.href = profileInfo["href"] as? String
        
        if let followersInfo = profileInfo["followers"] as? [String: AnyObject], let followerCount = followersInfo["total"]?.integerValue {
            me.followers = followerCount
        }
        
        if let images = profileInfo["images"] as? [[String: AnyObject]], let image = images.first, let imageURL = image["url"] as? String {
            me.image_url = imageURL
        }
        
        me.product = profileInfo["product"] as? String
        me.type = profileInfo["type"] as? String
        me.uri = profileInfo["uri"] as? String
        
        if let profileCacheKey = self.profileCacheKey {
            let archivedProfile = NSKeyedArchiver.archivedData(withRootObject: me)
            UserDefaults.standard.set(archivedProfile, forKey: profileCacheKey)
            UserDefaults.standard.synchronize()
        }
    }
}

// MARK: - File Controls

extension NFSpotifyProfile {
    
    open func loadFromDisk() -> Bool {
        
        if let userData = UserDefaults.standard.object(forKey: "SpotifyProfileCacheKey") as? Data, let userProfile = NSKeyedUnarchiver.unarchiveObject(with: userData) as? NFSpotifyProfile {
            
            return true
        }
        
        return false
    }
    
    open func saveToDisk() -> Bool {
        
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(archived, forKey: "")
        
        return UserDefaults.standard.synchronize()
    }
}

extension NFSpotifyProfile {
    
    open func getProfile(withAccessToken token: String, completion: ((_ profileInfo: [String: AnyObject]?, _ error: Error?) -> Void)?) {
        
        let spotifyHeaders = ["Accept": "application/json", "Authorization": "Bearer \(token)"]
        let profileURL = NFBaseURLSpotify + "me"
        
        Alamofire.request(profileURL, method: .get, headers: spotifyHeaders).responseJSON { (response) in
            
            if response.result.isSuccess, let profileInfo = response.result.value as? [String: AnyObject] {
                
                print("\nSpotify profile info: \(profileInfo)")

                if profileInfo["error"] == nil {
                    self.updateProfile(info: profileInfo)
                    
                    completion?(profileInfo, nil)
                }else{
                    if let errMsgInfo = profileInfo["error"] as? [String: AnyObject], let errMsg = errMsgInfo["message"] as? String {
                        let error = NFSpotifyOAuth.createCustomError(errorMessage: "")
                        completion?(nil, error)
                    }else{
                        completion?(nil, response.result.error)
                    }
                }
            }else{
                completion?(nil, response.result.error)
            }
        }
    }
}
