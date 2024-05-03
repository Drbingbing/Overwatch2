//
//  LinkPresentationClient.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import Foundation
import LinkPresentation
import Dependencies

struct LinkPresentationClient {
    
    var fetching: (URL) async throws -> LPLinkMetadata
}

extension LinkPresentationClient: DependencyKey {
    
    static var liveValue = LinkPresentationClient(
        fetching: { url in
            let provider = LPMetadataProvider()
            let metaData = try await provider.startFetchingMetadata(for: url)
            return metaData
        }
    )
}

extension LinkPresentationClient: TestDependencyKey {
    static var previewValue = LinkPresentationClient(
        fetching: { url in
            let provider = LPMetadataProvider()
            let metaData = try await provider.startFetchingMetadata(for: url)
            return metaData
        }
    )
}


extension DependencyValues {
    var linkPresentationClient: LinkPresentationClient {
        get { self[LinkPresentationClient.self] }
        set { self[LinkPresentationClient.self] = newValue }
    }
}
