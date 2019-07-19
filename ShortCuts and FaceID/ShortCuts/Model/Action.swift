import UIKit

protocol HasKey {
    var id: String { get }
}

struct Action: HasKey {
    let id: String
    let name: String
    let color: UIColor
}
