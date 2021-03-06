//
//  UploadClient.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 12/14/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation

struct UploadClient: APIClient {
    let api: AnyAPIFetcher
    init(api: AnyAPIFetcher) {
        self.api = api
    }

    func uploadMessage(roomId: String, data: Data, filename: String, mimetype: String, description: String, completion: (() -> Void)? = nil, versionFallback: (() -> Void)? = nil) {
        let req = UploadMessageRequest(
            roomId: roomId,
            data: data,
            filename: filename,
            mimetype: mimetype,
            description: description
        )

        api.fetch(req, succeeded: { result in
            if let error = result.error {
                Alert(key: "alert.upload_error").withMessage(error).present()
            }
            completion?()
        }, errored: { error in
            if case .version = error {
                versionFallback?()
            } else {
                Alert(key: "alert.upload_error").present()
                completion?()
            }
        })
    }

    func uploadAvatar(data: Data, filename: String, mimetype: String, completion: (() -> Void)? = nil) {
        let req = UploadAvatarRequest(
            data: data,
            filename: filename,
            mimetype: mimetype
        )

        api.fetch(req, succeeded: { _ in
            completion?()
        }, errored: { _ in
            completion?()
        })
    }
}
