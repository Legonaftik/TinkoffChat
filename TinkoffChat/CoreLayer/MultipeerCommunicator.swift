//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator {

    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: ICommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol ICommunicatorDelegate: class {
    // discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class MultipeerCommunicator: NSObject, ICommunicator {

    weak var delegate: ICommunicatorDelegate?

    private var _online : Bool = true
    public var online : Bool {
        get {
            return _online
        }
        set {
            _online = newValue
            if _online == true {
                advertiser.startAdvertisingPeer()
                browser.startBrowsingForPeers()
            }
            else {
                advertiser.stopAdvertisingPeer()
                browser.stopBrowsingForPeers()
            }
        }
    }

    private let serviceType = "tinkoff-chat"
    private let userNameKey = "userName"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown device ID")
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private var peersSessions: [String: MCSession] = [:]
    private var peersDiscoveryInfos: [String: [String: String]] = [:]

    override init() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: [userNameKey: "\(UIDevice.current.name)"], serviceType: serviceType)
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
        peersSessions.forEach { $1.disconnect() }
    }

    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let message = MessageTemp(text: string, messageType: .outgoing)
        guard let session = peersSessions[userID] else {
            fatalError("Couldn't send message to not-existing session. User ID: \(userID)")
        }

        do {
            let messageData = try JSONEncoder().encode(message)
            assert(session.connectedPeers.count == 1, "There should be only 1 connected peer in each session")
            try session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
            completionHandler?(true, nil)
        } catch {
            completionHandler?(false, error)
        }
    }

    // MARK: - Helpers
    private func setDiscoveryInfo(discoveryInfo : [String : String]?, peer: MCPeerID) {
        peersDiscoveryInfos[peer.displayName] = discoveryInfo
    }

    private func setSession(session : MCSession?, peer: MCPeerID) {
        peersSessions[peer.displayName] = session
    }

    private func prepareSession(peer: MCPeerID) -> MCSession? {
        var session = peersSessions[peer.displayName]

        if session == nil {
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
            session?.delegate = self
            setSession(session: session, peer: peer)
        }

        return session
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if let session = prepareSession(peer: peerID) {
            let accept = !session.connectedPeers.contains(peerID)
            invitationHandler(accept, session)
        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        setDiscoveryInfo(discoveryInfo: info, peer: peerID)
        if let session = prepareSession(peer: peerID) {
            if !session.connectedPeers.contains(peerID) {
                browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        let userId = peerID.displayName
        delegate?.didLostUser(userID: userId)
        setSession(session: nil, peer: peerID)
        setDiscoveryInfo(discoveryInfo: nil, peer: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userID = peerID.displayName

        switch state {
        case .connected:
            guard let userDiscoveryInfo = peersDiscoveryInfos[userID] else {
                print("No discovery info for userId \(userID) previousle was received.")
                return
            }

            guard let userName = userDiscoveryInfo[userNameKey] else {
                print("No user name for userId \(userID) previousle was received.")
                return
            }

            delegate?.didFoundUser(userID: userID , userName: userName)
        case .notConnected:
            delegate?.didLostUser(userID: userID)
        case .connecting:
            break
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            var message = try JSONDecoder().decode(MessageTemp.self, from: data)
            message.messageType = .incoming
            delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: session.myPeerID.displayName)
        } catch {
            // This should happen when another developer implemented Message JSON incorrectly
            assert(false, "Couldn't convert the received data into Message")
        }
    }

    // Not implemented
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
