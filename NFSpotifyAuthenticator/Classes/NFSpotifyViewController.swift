//
//  NFSpotifyViewController.swift
//  Pods
//
//  Created by Neil Francis Hipona on 26/10/2016.
//
//

import Foundation
import UIKit


open class NFSpotifyViewController: UIViewController {
    
    fileprivate var loginView: NFSpotifyLoginView!
    
    fileprivate var backgroundImageView: UIImageView!
    fileprivate var logoImageView: UIImageView!
    fileprivate var messageLabel: UILabel!
    fileprivate var connectButton: UIButton!
    fileprivate var cancelButton: UIButton!

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        loadView()
        prepareController()
    }
    
    // MARK: - UI
    
    private func prepareController() {
        
        // Background Image
        let bgImageFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundImageView = UIImageView(frame: bgImageFrame)
        view.addSubview(backgroundImageView)
        pinViewToSelf(view: backgroundImageView)
        
        // Logo Image
        let logoSquareSize: CGFloat = 120
        let logoFrameOriginX = view.frame.width - logoSquareSize - 100
        let logoImageFrame = CGRect(x: logoFrameOriginX, y: 80, width: logoSquareSize, height: logoSquareSize)
        logoImageView = UIImageView(frame: logoImageFrame)
        view.addSubview(logoImageView)
        
        let logoHConstraint = NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: logoSquareSize)
        let logoWConstraint = NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: logoSquareSize)
        logoImageView.addConstraints([logoHConstraint, logoWConstraint])
        
        // Message Label
        let msgLabelOriginY = logoSquareSize + 88
        let msgLabelWidth = view.frame.width - 40
        let msgLabelFrame = CGRect(x: 20, y: msgLabelOriginY, width: msgLabelWidth, height: 40)
        messageLabel = UILabel(frame: msgLabelFrame)
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        
        // Logo & Msg Lbl constraints
        let verticalLogoMsgConstraint = NSLayoutConstraint(item: logoImageView, attribute: .bottom, relatedBy: .equal, toItem: messageLabel, attribute: .top, multiplier: 1, constant: 8)
        let xMidLogoMsgConstraint = NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: messageLabel, attribute: .centerX, multiplier: 1, constant: 8)
        view.addConstraints([verticalLogoMsgConstraint, xMidLogoMsgConstraint])
        
        let msgLabelLeadConstraint = NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let msgLabelTrailConstraint = NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20)
        
        let yMidMsgLabelConstraint = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 8)

        view.addConstraints([msgLabelLeadConstraint, msgLabelTrailConstraint, yMidMsgLabelConstraint])
        
        // Control Buttons
        let buttonWidth = view.frame.width - 40
        
        let conButtonOriginY = msgLabelOriginY + 48
        let conButtonFrame = CGRect(x: 20, y: conButtonOriginY, width: buttonWidth, height: 40)
        connectButton = UIButton(frame: conButtonFrame)
        view.addSubview(connectButton)
        
        let verticalConButtonConstraint = NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: connectButton, attribute: .top, multiplier: 1, constant: 8)
        
        let conButtonLeadConstraint = NSLayoutConstraint(item: connectButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let conButtonTrailConstraint = NSLayoutConstraint(item: connectButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20)
        view.addConstraints([verticalConButtonConstraint, conButtonLeadConstraint, conButtonTrailConstraint])
        
        let conButtonHConstraint = NSLayoutConstraint(item: connectButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        connectButton.addConstraint(conButtonHConstraint)
        
        let cnclButtonOriginY = conButtonOriginY + 48
        let cnclButtonFrame = CGRect(x: 20, y: cnclButtonOriginY, width: buttonWidth, height: 40)
        cancelButton = UIButton(frame: cnclButtonFrame)
        view.addSubview(cancelButton)
        
        let verticalCnclButtonConstraint = NSLayoutConstraint(item: connectButton, attribute: .bottom, relatedBy: .equal, toItem: cancelButton, attribute: .top, multiplier: 1, constant: 8)

        let cnclButtonLeadConstraint = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let cnclButtonTrailConstraint = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20)
        view.addConstraints([verticalCnclButtonConstraint, cnclButtonLeadConstraint, cnclButtonTrailConstraint])
        
        let cnclButtonHConstraint = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        cancelButton.addConstraint(cnclButtonHConstraint)

    }
    
    private func pinViewToSelf(view v: UIView) {
        
        let top = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: v, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: v, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        view.addConstraints([top, left, bottom, right])
    }
    
    
}
