//
//  Created on 2021/10/1.
//

import Foundation

infix operator -->

/// Prepare class instance
func --> <T>(object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
