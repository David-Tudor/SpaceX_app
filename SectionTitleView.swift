import Foundation
import SwiftUI

struct SectionTitleView: View {
    // Text titles with grey box background
    let text: String
    
    let cornerSize = 15
    let colLightGrey: UInt = 0xBABABD
    
    init(saying text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize))
                .fill(Color(colLightGrey))
                .frame(height: 20)
            Text(text)
        }
    }
    
}
