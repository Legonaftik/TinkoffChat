//
//  RequestsFactory.swift
//  SOADemo
//
//  Created by a.y.zverev on 14.04.17.
//  Copyright © 2017 a.y.zverev. All rights reserved.
//

import Foundation

enum RequestsFactory {
    
    enum AppleRSSRequests {
        
        static func newAppsConfig() -> RequestConfig<[AppApiModel]> {
            return RequestConfig<[AppApiModel]>(request:NewAppsRequest(), parser: AppsParser())
        }
        
        static func topPaidAppsConfig() -> RequestConfig<[AppApiModel]> {
            return RequestConfig<[AppApiModel]>(request:TopPaidAppsRequest(), parser: AppsParser())
        }
        
        static func topFreeAppsConfig() -> RequestConfig<[AppApiModel]> {
            return RequestConfig<[AppApiModel]>(request:TopFreeAppsRequest(), parser: AppsParser())
        }
    }
    
    enum LastFMRequests {
        static func topTracksConfig() -> RequestConfig<[TrackApiModel]> {
            let request = LastFMTopTracksRequest(apiKey: "d2fc8ba489c03df1a0f1eba71dea6fd9")
            return RequestConfig<[TrackApiModel]>(request:request, parser: LastFMTracksParser())
        }
    }

    enum AvatarRequests {

        static func avatars() -> RequestConfig<[AvatarAPIModel]> {
            return RequestConfig<[AvatarAPIModel]>(request: request, parser: <#T##Parser<[AvatarAPIModel]>#>)
        }
    }
}
