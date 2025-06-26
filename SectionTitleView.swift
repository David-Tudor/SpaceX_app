import Foundation
import SwiftUI

// Makes text backed by a grey box.

struct SectionTitleView: View {
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
