//
//  RemoteDataSource.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/11.
//

import Foundation
import Alamofire

// FIXME: APIが増える場合もう少し構造化する
// https://qiita.com/yimajo/items/dd0daae1b264570c152d
class ApiClient {

    private let session: Session
    static let shared = ApiClient()

    init() {
        session = Session(configuration: .default, redirectHandler: APIRedirectHandler())
    }

    func saveResults(gameResult: GameResult) {
        let url = "https://script.google.com/macros/s/AKfycbw0jkaQt4R_EedgzzJTlfu3NeEop6X14IpWLdXKJZRYWhB9ZAff6vVG1GNhuOtmPBj5YA/exec"

        let request = session.request(
            url,
            method: .post,
            parameters: gameResult.toDoictionary(),
            encoding: JSONEncoding.default,
            headers: nil
        )
        print("parameters: \(gameResult.toDoictionary())")

        request.responseDecodable(of: GeneralResponse.self) { response in
            switch response.result {
            case .success(let element):
                print("response: \(response.data)")
                print("success: \(element)")
            case .failure(let error):
                // GASの仕様上辿りつかない想定
                print("response: \(response.data)")
                print("failure: \(error)")
            }
        }
    }
}

final class APIRedirectHandler: RedirectHandler {
    func task(_ task: URLSessionTask, willBeRedirectedTo request: URLRequest, for response: HTTPURLResponse, completion: @escaping (URLRequest?) -> Void) {
        guard let _ = request.url else {
            completion(request)
            return
        }

        completion(request)
    }
}

struct GeneralResponse: Decodable {
    var method: String
    var message: String
    var isOk: Bool
}

// TODO: https://qiita.com/SNQ-2001/items/4771cf3a91f6470bbc14
//final class APISerializer<T: Decodable>: ResponseSerializer {
//    private lazy var successSerializer = DecodableResponseSerializer<T>(decoder: JSONDecoder())
//    private lazy var failureSerializer = DecodableResponseSerializer<T>(decoder: JSONDecoder())
//
//    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: (any Error)?) throws -> some Sendable {
//        guard error == nil else { return .failure() }
//    }
//}
