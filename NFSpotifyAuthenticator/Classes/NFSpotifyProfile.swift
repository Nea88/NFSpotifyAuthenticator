//
//  NFSpotifyProfile.swift
//  Pods
//
//  Created by Neil Francis Hipona on 25/10/2016.
//
//

import Foundation

class NFSpotifyProfile: NSObject, NSCoding {
    
    static let me = NFSpotifyProfile()
    
    // MARK: - Declarations
    
    var id: String!
    var birthdate: String!
    var country: String!
    var display_name: String!
    var email: String!
    var href: String!
    var followers: Int = 0
    var image_url: String!
    var product: String!
    var type: String!
    var uri: String!
    
    // MARK: - Initializers
    
    private
    override init() {
        super.init()
    }
    
    convenience init(profileInfo: [String: AnyObject]) {
        self.init()
        
        updateProfile(info: profileInfo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
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
    
    
    func encode(with aCoder: NSCoder) {
        
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

extension NFSpotifyProfile {
    
    // MARK: - Controls
    
    func updateProfile(info profileInfo: [String: AnyObject]) {
        
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
    }
}

extension NFSpotifyProfile {
    
    // MARK: - File Controls
    
    func loadFromDisk() -> Bool {
        
        if let userData = UserDefaults.standard.object(forKey: "SpotifyProfileCacheKey") as? Data, let userProfile = NSKeyedUnarchiver.unarchiveObject(with: userData) as? NFSpotifyProfile {
            
            return true
        }
        
        return false
    }
    
    func saveToDisk() -> Bool {
        
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(archived, forKey: "")
        
        return UserDefaults.standard.synchronize()
    }
}
