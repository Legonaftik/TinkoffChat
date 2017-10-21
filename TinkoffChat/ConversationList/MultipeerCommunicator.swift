//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator {

    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol CommunicatorDelegate: class {
    // discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class MultipeerCommunicator: NSObject, Communicator {

    weak var delegate: CommunicatorDelegate? =  CommunicationManager()
    var online: Bool = false

    private let serviceType = "tinkoff-chat"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let session: MCSession

    override init() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName": "legonaftik"], serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        super.init()

        advertiser.delegate = self
        browser.delegate = self

        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }

    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }

    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }

    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let message = Message(text: string)
        do {
            let messageData = try JSONEncoder().encode(message)
            try session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
            if let completionHandler = completionHandler {
                completionHandler(true, nil)
            }

            for peer in session.connectedPeers {
                delegate?.didReceiveMessage(text: message.text, fromUser: myPeerId.displayName, toUser: peer.displayName)
            }
        } catch {
            if let completionHandler = completionHandler {
                completionHandler(false, error)
            }
        }
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Automatically accept all the invitations
        invitationHandler(true, session)
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
    }
}
