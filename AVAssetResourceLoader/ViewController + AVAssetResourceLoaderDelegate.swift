//
//  ViewController + AVAssetResourceLoaderDelegate.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 08/12/23.
//

import Foundation
import AVFoundation

// MARK: - AVAssetResourceLoaderDelegate

extension ViewController: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let path = loadingRequest.request.url?.path(percentEncoded: true) else {
            print("Loading request without path: \(loadingRequest)")
            return false
        }
        print("Requested length: \(loadingRequest.request)")
        print("Should wait for loading request: \(path)")
        print("Loading request headers: \(loadingRequest.request.allHTTPHeaderFields ?? [:])")
        print("Data request current offset: \(loadingRequest.dataRequest?.currentOffset), requested offset: \(loadingRequest.dataRequest?.requestedOffset), requested length: \(loadingRequest.dataRequest?.requestedLength)")
        
        receivedLoadingRequests[path] = loadingRequest
        let isContentRequest = loadingRequest.contentInformationRequest != nil
        let isDataRequest = loadingRequest.dataRequest != nil
        print("isContentRequest: \(isContentRequest), isDataRequest: \(isDataRequest)")
        
        let playerURL = loadingRequest.request.url
        let httpPlayerUrl = playerURL?.withScheme(httpsScheme)
        
        performUrlRequestAndFinishLoadingRequest(httpPlayerUrl, loadingRequest: loadingRequest)
        
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        guard let path = loadingRequest.request.url?.path(percentEncoded: true) else {
            print("didCancel loadingRequest: No request to cancel")
            return
        }
        print("didCancel loadingRequest: \(path)")
        receivedLoadingRequests[path] = nil
        
    }
    
    fileprivate func performUrlRequestAndFinishLoadingRequest(_ httpPlayerUrl: URL?, loadingRequest: AVAssetResourceLoadingRequest) {
        guard let path = loadingRequest.request.url?.path(percentEncoded: true) else {
            return
        }
        var urlRequest = loadingRequest.request // URLRequest(url: httpPlayerUrl!)
        urlRequest.url = httpPlayerUrl
        print("URL request headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        session.dataTask(with: urlRequest) { [path] data, response, error in
            
            guard let loadingRequest = self.receivedLoadingRequests[path] else {
                print("Loading request not found: \(path)")
                return
            }
            if loadingRequest.isCancelled == true {
                print("Loading request was cancelled: \(path)")
                loadingRequest.finishLoading()
                self.receivedLoadingRequests[path] = nil
                return
            }
            if let error = error {
                print("Finished loading with error.")
                loadingRequest.finishLoading(with: error)
                self.receivedLoadingRequests[path] = nil
                return
            }
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse else {
                print("Didn't receive data or response")
                loadingRequest.finishLoading()
                self.receivedLoadingRequests[path] = nil
                return
            }
            print("HTTP Response code: \(httpResponse.statusCode), data: \(data.count)")
            print("URL Response expected content length: \(response?.expectedContentLength ?? -1)")
            print("URL Response mimeType: \(response?.mimeType ?? "missing")")
            if let contentInfoRequest = loadingRequest.contentInformationRequest {
                contentInfoRequest.contentLength = response?.expectedContentLength ?? Int64(data.count)
                contentInfoRequest.contentType = response?.mimeType
                contentInfoRequest.isByteRangeAccessSupported = true
                print("contentInfoRequest: \(contentInfoRequest.isByteRangeAccessSupported), \(contentInfoRequest.contentType ?? "contentType missing"), \(contentInfoRequest.contentLength) ")
                if contentInfoRequest.contentType == "application/octet-stream" {
//                    contentInfoRequest.contentType = "video/mp2t"
//                    contentInfoRequest.contentType = "audio/mpeg"
                    contentInfoRequest.contentType = "video/mp4"
                }
            }
            if let dataRequest = loadingRequest.dataRequest {
                dataRequest.respond(with: data)
            }
            if !(loadingRequest.isCancelled == true) {
                print("Successfully finished request: \(path)")
                loadingRequest.finishLoading()
                self.receivedLoadingRequests[path] = nil
            }
        }.resume()
    }
    
    fileprivate func getContentType(fromResponse response: HTTPURLResponse) -> String? {
        var contentType: String?
        let headers = response.allHeaderFields
        defer {
            print("contentType: \(contentType ?? "missing")")
        }
        if let receivedContentType = headers["Content-Type"] as? String {
            contentType = receivedContentType
        }
        return contentType
    }
    
    fileprivate func getContentLength(fromResponse response: HTTPURLResponse) -> Int64? {
        let headers = response.allHeaderFields
        var contentLength: Int64?
        defer {
            print("contentLength: \(contentLength ?? -1)")
        }
        if let receivedContentLength = headers["Content-Length"] as? Int64 {
            contentLength = receivedContentLength
        }
        return contentLength
    }
    
    
}
