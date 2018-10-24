

import Foundation

struct CafeAPI: Decodable {
    let id: String
    let name: String
    let city: String
    let wifi: Double
    let seat: Double
    let quiet: Float
    let tasty: Float
    let cheap: Float
    let music: Float
    let url: String
    let address: String
    let latitude: String
    let longitude: String
    let limited_time: String
    let socket: String
    let standing_desk: String
    let mrt: String
    let open_time: String
}
