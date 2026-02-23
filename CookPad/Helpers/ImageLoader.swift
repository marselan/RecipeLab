//
//  ImageLoader.swift
//  CookPad
//
//  Created by Mariano Arselan on 19-02-26.
//

import Foundation
import Combine
import SwiftUI
import UIKit

protocol ImageLoaderProtocol {
    func load(urlString: String) async throws -> Image
}


class ImageLoader: ImageLoaderProtocol {
    enum Error: Swift.Error {
        case urlCreationFailed
        case connectionFailed
        case imageDecodingFailed
    }
    
    private var cache: NSCache<NSString, UIImage> = .init()
    private var initialized = false
    
    func load(urlString: String) async throws -> Image {
        if !initialized {
            cache.countLimit = 100
            initialized = true
        }
        if cache.object(forKey: urlString as NSString) != nil {
            let uiImage = cache.object(forKey: urlString as NSString) ?? UIImage()
            return Image(uiImage: uiImage)
        }
        guard let url = URL(string: urlString) else { throw Error.urlCreationFailed }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw Error.connectionFailed }
            guard let uiImage = UIImage(data: data) else { throw Error.imageDecodingFailed }
            cache.setObject(uiImage, forKey: urlString as NSString)
           return Image(uiImage: uiImage)
        } catch {
            throw Error.connectionFailed
        }
    }
}

class MockImageLoader: ImageLoaderProtocol {
    func load(urlString: String) async throws -> Image {
        Image(systemName: "star")
    }
    
    
}
