//
//  SocketHandler.swift
//  FoodApp
//
//  Created by Anonymus on 2/12/21.
//

import Foundation
import SocketIO

class SocketHandler: NSObject {
    static let sharedInstance = SocketHandler()
    let socket = SocketManager(socketURL: URL(string: "http://192.168.18.12:3001")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!

    override init() {
        super.init()
        mSocket = socket.defaultSocket
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection() {
        mSocket.connect()
    }

    func closeConnection() {
        mSocket.disconnect()
    }
}
