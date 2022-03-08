//
//  ViewModel.swift
//  News Feed
//
//  Created by Manish Tamta on 05/03/2022.
//

import Foundation
import Combine

protocol ViewModel {
    var didGetError: PassthroughSubject<APIError, Never> { get set }
    var showLoader: PassthroughSubject<Bool, Never> { get set}
}
