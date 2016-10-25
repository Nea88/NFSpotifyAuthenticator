//
//  NFSpotifyLoginView.swift
//  Pods
//
//  Created by Neil Francis Hipona on 24/10/2016.
//
//

import Foundation
import UIKit
import WebKit

protocol NFSpotifyLoginViewDelegate: NSObjectProtocol {
    
    func nfSpotifyLoginView(_ view: NFSpotifyLoginView, didLoginWithTokenObject tokenObject: [String: AnyObject])
    func nfSpotifyLoginView(_ view: NFSpotifyLoginView, didFailWithError error: Error?)
}

class NFSpotifyLoginView: UIView {
    
    // MARK: - Declarations
    
    fileprivate var wkWebView: WKWebView!
    fileprivate var closeButton: UIButton!
    
    fileprivate var scopes: [String] = []
    
    weak var delegate: NFSpotifyLoginViewDelegate!
    
    // MARK: - Initializers
    
    private
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.init()
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    convenience init(frame: CGRect, scopes s: [String], delegate d: NFSpotifyLoginViewDelegate) {
        self.init(frame: frame)
        
        scopes = s
        delegate = d
        
        isHidden = true
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        prepareWebLoginView(withFrame: frame)
        prepareCloseButton(withBaseFrame: frame)
        
        closeButton.backgroundColor = .green // Temp
        
        guard let redirectURI = NFSpotifyOAuth.shared.redirectURI else { return }
        guard let accessCodeAuthURL = accessCodeRequestOAuthURL(forRedirectURI: redirectURI) else { return }
        
        loadURL(url: accessCodeAuthURL)
    }
}

// MARK: - Helpers

extension NFSpotifyLoginView {
    
    fileprivate func prepareWebLoginView(withFrame frame: CGRect) {
        
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = wkUController
        
        let webFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        wkWebView = WKWebView(frame: webFrame, configuration: configuration)
        addSubview(wkWebView)
        pinViewToSelf(view: wkWebView)
        
        wkWebView.navigationDelegate = self
    }
    
    fileprivate func prepareCloseButton(withBaseFrame frame: CGRect) {
        
        let buttonFrame = CGRect(x: frame.width - 20, y: 0, width: 20, height: 20)
        closeButton = UIButton(frame: buttonFrame)
        addSubview(closeButton)
        
        let top = NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: closeButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        addConstraints([top, right])
        
        let width = NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        let height = NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        
        closeButton.addConstraints([width, height])
        
        closeButton.addTarget(self, action: #selector(self.closeButtonAction(_:)), for: .touchUpInside)
    }
    
    fileprivate func pinViewToSelf(view: UIView) {
        
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10)
        let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: -10)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 10)
        
        addConstraints([top, left, bottom, right])
    }
    
    fileprivate func loadURL(url: URL) {
        
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }
    
    /** Construct 'Access Code' request link */
    fileprivate func accessCodeRequestOAuthURL(forRedirectURI redirectURI: String, state: String! = nil, show_dialog: Bool = false) -> URL! {
        
        let shared = NFSpotifyOAuth.shared
        guard let clientID = shared.clientID, let redirectURI = shared.redirectURI else { return nil }
        
        let uri = redirectURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let urlClientId = "?client_id=\(clientID)"
        let urlResponseType = "&response_type=code"
        let urlRedirectURI = "&redirect_uri=\(uri)"
        
        var urlScopes = ""
        var stateKey = ""
        
        if !scopes.isEmpty {
            for scope in scopes {
                if urlScopes.isEmpty {
                    urlScopes = "&scope=\(scope)"
                }else{
                    urlScopes += "%20\(scope)"
                }
            }
        }else{
            urlScopes = "&scope=streaming%20user-read-email%20playlist-read-private%20user-read-private"
        }
        
        if let state = state {
            stateKey = "state=\(state)"
        }
        
        let accessCodeURL = "\(NFSpotifyAutorizationCodeURL)" + urlClientId + urlResponseType + urlRedirectURI + urlScopes + stateKey
        
        guard let authURL = URL(string: accessCodeURL) else { return nil }
        return authURL
    }
}

// MARK: - Controls

extension NFSpotifyLoginView {
    
    func closeButtonAction(_ sender: UIButton) {
        
        
    }
}


// MARK: - WKNavigationDelegate

extension NFSpotifyLoginView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        print("SpotifyAuthLoginView didCommit navigation: \(webView.url ?? nil)")
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("SpotifyAuthLoginView didFinish navigation: \(webView.url ?? nil)")
        
//        guard let url = webView.url else {return}
//        if let items = url.queryItems {
//            if let code = items["code"] {
//                print("Extracted code! \(code) --> Exchange for refresh tokens and access token")
//                requestTokenSwapWithCode(code: code, completion: { (access_token, refresh_token, error) in
//                    if error == nil {
//                        if let token = access_token, let refresh = refresh_token {
//                            self.delegate?.spotifyAuthLoginView(view: self, didProvideToken: token, withRefreshToken: refresh)
//                        } else {
//                            self.delegate?.spotifyAuthLoginView(view: self, failedWithError: nil)
//                        }
//                    } else {
//                        self.delegate?.spotifyAuthLoginView(view: self, failedWithError: error)
//                    }
//                })
//            }
//        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        print("SpotifyAuthLoginView didFail navigation: \(webView.url ?? nil) -- error: \(error)")
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
        print("SpotifyAuthLoginView webViewWebContentProcessDidTerminate: \(webView.url ?? nil)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("SpotifyAuthLoginView didReceiveServerRedirectForProvisionalNavigation navigation: \(webView.url ?? nil)")
        
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        print("SpotifyAuthLoginView didReceiveServerRedirectForProvisionalNavigation navigation: \(webView.url ?? nil)")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("SpotifyAuthLoginView didReceive challenge")
        let credential = URLCredential(user: "", password: "", persistence: .forSession)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("SpotifyAuthLoginView didFailProvisionalNavigation: \(webView.url ?? nil), error: \(error)")
    }
}
