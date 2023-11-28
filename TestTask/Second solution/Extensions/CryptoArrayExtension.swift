import UIKit

extension [Crypto] {
    var convertToPair: [(Crypto, UISwitch?)] {
        return self.map{($0, nil)}
    }
}

extension [(Crypto, UISwitch?)] {
    func checkCoin(_ name: String) -> Int? {
        for i in 0..<self.count {
            if self[i].0.name == name {
                return i
            }
        }
        return nil
    }
    var convertToArray: [Crypto] {
        return self.map{$0.0}
    }
}
