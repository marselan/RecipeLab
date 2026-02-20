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
    
    func load(urlString: String) async throws -> Image {
        guard let url = URL(string: urlString) else { throw Error.urlCreationFailed }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response: \(response)")
                ; throw Error.connectionFailed }
            guard let uiImage = UIImage(data: data) else { throw Error.imageDecodingFailed }
           return Image(uiImage: uiImage)            
        } catch {
            throw Error.connectionFailed
        }
    }
}
