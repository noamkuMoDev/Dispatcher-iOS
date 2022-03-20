import Foundation
import Alamofire

class AlamofireManager: NSObject {
    
    var isPaginating: Bool = false
    var url: String!
    var headers = HTTPHeaders()
    var parameters = Parameters()
    var encoding: ParameterEncoding = JSONEncoding.default
    
    
    
    init( data: [String:Any]? = nil, from url: String) {
        super.init()
        
        self.url = url
        ["Accept": "application/json", "Content-type": "application/json", "x-api-key": Constants.Keys.newApi].forEach({self.headers.add(name: $0.key, value: $0.value)})
        if let safeData = data {
            safeData.forEach{ parameters.updateValue($0.value, forKey: $0.key) }
        }
    }
    
    
    
    func executeGetQuery<T>(pagination: Bool = false, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        if pagination {
            isPaginating = true
        }
        AF.request(url, method: .get, headers: headers).responseData(completionHandler: { response in
            do {
                switch response.result {
                case .success:
                    if !pagination {
                        completion(.success(try JSONDecoder().decode(T.self, from: response.data ?? Data())))
                    } else {
                        
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch let error {
                print(error)
            }
        })
        if pagination {
            isPaginating = false
        }
    }
    
    func executePostQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        AF.request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: { response in
            do {
                switch response.result {
                case .success:
                    completion(.success(try JSONDecoder().decode(T.self, from: response.data ?? Data())))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch let error {
                print(error)
            }
        })
    }
}
