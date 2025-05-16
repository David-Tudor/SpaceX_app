import Foundation


func getData<T: Decodable>(from urlInput: String) async throws -> T {
    // Generic used to detect the type.
    let url = URL(string: urlInput)!
    let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    
    return try decoder.decode(T.self, from: data)
}

struct Patch: Decodable {
    let small: String?
}

struct Link: Decodable { // XXX Any better way than making lots of structs??
    let patch: Patch
    let webcast: String?
    let wikipedia: String?
}

struct Failure: Decodable {
    let time: Int
    let altitude: Int?
    let reason: String
}

struct Launch: Decodable, Identifiable {
    let links: Link
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let launchpad: String
    let name: String
    let date_local: String
    let launch_library_id: String?
    let id: String
}

struct Rocket: Decodable {
    let id: String
    let name: String
}

struct Company: Decodable {
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let launch_sites: Int
    let valuation: Int
}
