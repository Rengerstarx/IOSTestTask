import UIKit

extension [Crypto] {
    func checkCoin(_ name: String) -> Bool {
        for i in 0..<self.count {
            if self[i].name == name {
                return true
            }
        }
        return false
    }
}
