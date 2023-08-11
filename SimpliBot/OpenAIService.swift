//
//  OpenAIService.swift
//  SimpliBot
//
//  Created by DA MAC M1 137 on 2023/08/10.
//

import Foundation
import Alamofire
import Combine


class OpenAIService {
    let baseURL = "https://api.openai.com/v1/completions"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionResponse, Error> {
        let body = OpenAICompletionBody(model: "text-davinci-003", prompt: message, temperature: 0, maxToken: 7)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAPIKey)"
        ]
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            AF.request(self.baseURL, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: OpenAICompletionResponse.self) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    
    struct OpenAICompletionBody: Encodable {
        let model: String
        let prompt: String
        let temperature: Float?
        let maxToken:Int
    }
    struct OpenAICompletionResponse: Decodable {
        let id: String
        let choices: [OpenAICompletionChoice]
    }
    
    struct OpenAICompletionChoice: Decodable {
        let text: String
    }
}
