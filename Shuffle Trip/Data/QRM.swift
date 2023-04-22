// Apr 22, 2023
// Ben Roberts

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct QRM {
    
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()
    
    static func generateQRCode(data: String) -> UIImage {
        filter.message = Data(data.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
