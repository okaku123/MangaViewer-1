// The MIT License (MIT)
//
// Copyright (c) 2015-2021 Alexander Grebenyuk (github.com/kean).

import AVKit
import Foundation

#if !os(watchOS)

extension ImageContainer {
    /// A fetched video from data.
    public var asset: AVAsset? {
        guard type == .mp4, let data = data else {
            return nil
        }
        return AVDataAsset(data: data)
    }
}

final class AVDataAsset: AVURLAsset {
    private let _loader: DataAssetResourceLoader

    init(data: Data) {
        self._loader = DataAssetResourceLoader(
            data: data,
            contentType: AVFileType.mp4.rawValue
        )

        // The URL is irrelevant
        let url = URL(string: "in-memory-data://\(UUID().uuidString)") ?? URL(fileURLWithPath: "/dev/null")
        super.init(url: url, options: nil)

        resourceLoader.setDelegate(_loader, queue: .global())
    }
}

// This allows LazyImage to play video from memory.
private final class DataAssetResourceLoader: NSObject, AVAssetResourceLoaderDelegate {
    private let data: Data
    private let contentType: String

    init(data: Data, contentType: String) {
        self.data = data
        self.contentType = contentType
    }

    // MARK: - DataAssetResourceLoader

    func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest
    ) -> Bool {
        if let contentRequest = loadingRequest.contentInformationRequest {
            contentRequest.contentType = contentType
            contentRequest.contentLength = Int64(data.count)
            contentRequest.isByteRangeAccessSupported = true
        }

        if let dataRequest = loadingRequest.dataRequest {
            if dataRequest.requestsAllDataToEndOfResource {
                dataRequest.respond(with: data[dataRequest.requestedOffset...])
            } else {
                let range = dataRequest.requestedOffset..<(dataRequest.requestedOffset + Int64(dataRequest.requestedLength))
                dataRequest.respond(with: data[range])
            }
        }

        loadingRequest.finishLoading()

        return true
    }
}

#endif
