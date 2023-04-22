// Apr 22, 2023
// Ben Roberts

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct QRM {
    
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()
    
}
