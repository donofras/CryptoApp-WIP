//
//  Constants.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 19.09.2022.
//

import Kingfisher
import UIKit

let imageTransitionDuration: TimeInterval = 0.3
let retryOfFailDownloadImage: Int = 3
let kingfisherOptions: KingfisherOptionsInfo = [
    .scaleFactor(UIScreen.main.scale),
    .transition(.fade(imageTransitionDuration)),
    .cacheOriginalImage,
    .retryStrategy(DelayRetryStrategy(maxRetryCount: retryOfFailDownloadImage))
]
