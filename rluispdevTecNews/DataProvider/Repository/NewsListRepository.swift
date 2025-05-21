import Foundation

enum NewsListError: Error {
    case fileNotFound
    case invalidURL
    case requestFailed
    case decodingError
    case noData
}

class NewsListRepository {
    static let shared = NewsListRepository()

    private let endpoint: String

    private init() {
        if let apiKey = Bundle.main.infoDictionary?["API_KEY_NEWS"] as? String {
            self.endpoint = "https://newsapi.org/v2/everything?q=tecnologia&language=pt&sortBy=publishedAt&apiKey=\(apiKey)"
        } else {
            // Trate o erro de forma segura (pode usar fatalError ou string vazia)
            fatalError("⚠️ API_KEY_NEWS não encontrada no Info.plist")
        }
    }

    func getNewsList(completion: @escaping ([NewsModel]?, Error?) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(nil, NewsListError.invalidURL)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro de rede: \(error)")
                completion(nil, NewsListError.requestFailed)
                return
            }

            guard let data = data else {
                completion(nil, NewsListError.noData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                completion(apiResponse.articles, nil)
            } catch {
                print("Erro ao decodificar: \(error)")
                completion(nil, NewsListError.decodingError)
            }
        }

        task.resume()
    }
}

struct APIResponse: Decodable {
    let articles: [NewsModel]
}
