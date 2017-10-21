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

    weak var delegate: CommunicatorDelegate? = CommunicationManager()
    var online: Bool = false

    private let serviceType = "tinkoff-chat"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private var sessions: [String: MCSession] = [:]

    override init() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName": "legonaftik"], serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()

        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

        browser.delegate = self
        browser.startBrowsingForPeers()
    }

    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }

    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let message = Message(text: string)
        let session = sessions[userID]!

        do {
            let messageData = try JSONEncoder().encode(message)
            try session.send(messageData, toPeers: session.connectedPeers, with: .reliable)  // There should be only one peer
            completionHandler?(true, nil)

            print("Did send message; string: \(string), to: \(userID)")
        } catch {
            completionHandler?(false, error)
        }
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Automatically accept all the invitations
        if let session = sessions[peerID.displayName] {
            invitationHandler(true, session)
        } else {
            invitationHandler(false, nil)
        }
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
        sessions.removeValue(forKey: peerID.displayName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])

        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        sessions[peerID.displayName] = session
        session.delegate = self

        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            sendMessage(string: "Hello, user!", to: peerID.displayName, completionHandler: nil)
        case .notConnected:
            delegate?.didLostUser(userID: peerID.displayName)
//            sessions.removeValue(forKey: peerID.displayName)
        case .connecting:
            break
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(Message.self, from: data)
            delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: myPeerId.displayName)
            print("Did receive message; text: \(message.text), from: \(peerID.displayName)")
        } catch {
            fatalError("Couldn't convert the received data into Message")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
