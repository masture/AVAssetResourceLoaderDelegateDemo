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
        print("Should wait for loading request: \(path)")
        print("Loading request headers: \(loadingRequest.request.allHTTPHeaderFields ?? [:])")
        
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
        print("URL request headers: \(urlRequest.allHTTPHeaderFields)")
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
            if var contentInfoRequest = loadingRequest.contentInformationRequest {
                if let contentLength = self.getContentLength(fromResponse: httpResponse) {
                    contentInfoRequest.contentLength = contentLength
                } else {
                    contentInfoRequest.contentLength = Int64(data.count)
                }
                contentInfoRequest.contentType = self.getContentType(fromResponse: httpResponse)
                contentInfoRequest.isByteRangeAccessSupported = true
            }
            
            if var dataRequest = loadingRequest.dataRequest {
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
            print("contentType: \(contentType)")
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
            print("contentLength: \(contentLength)")
        }
        if let receivedContentLength = headers["Content-Length"] as? Int64 {
            contentLength = receivedContentLength
        }
        return contentLength
    }
    
    
}
