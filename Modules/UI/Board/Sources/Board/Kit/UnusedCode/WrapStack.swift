
import Combine
import Foundation
import SwiftUI

// This file is from https://stackoverflow.com/a/57660194/412916
// See this instead: https://github.com/spacenation/grid
// and this: https://stackoverflow.com/questions/56466306/uicollectionview-and-swiftui

struct WrapStack_Previews: PreviewProvider {
    static var previews: some View {
        WrapStack(strings: ["One, ", "Two, ", "Three, ", "Four, ", "Five, ", "Six, ", "Seven, ", "Eight, "])
    }
}

struct WrapStack: View {
    var strings: [String]

    @State var borderColor = Color.red
    @State var verticalAlignment = VerticalAlignment.top
    @State var horizontalAlignment = HorizontalAlignment.leading

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(self.strings.indices, id: \.self) {idx in
                    Text(self.strings[idx])
                        .position(self.nextPosition(
                            index: idx,
                            bucketRect: geometry.frame(in: .local)))
                }   //end GeometryReader
            }   //end ForEach
        }   //end ZStack
        .overlay(Rectangle().stroke(self.borderColor))
    }   //end body

    // swiftlint:disable:next function_body_length
    func nextPosition(index: Int,
                      bucketRect: CGRect) -> CGPoint {
        let ssfont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let initX = (self.horizontalAlignment == .trailing) ? bucketRect.size.width : CGFloat(0)
        let initY = (self.verticalAlignment == .bottom) ? bucketRect.size.height : CGFloat(0)
        let dirX = (self.horizontalAlignment == .trailing) ? CGFloat(-1) : CGFloat(1)
        let dirY = (self.verticalAlignment == .bottom) ? CGFloat(-1) : CGFloat(1)

        let internalPad = 10   //fudge factor

        var runningX = initX
        var runningY = initY
        let fontHeight = StringDimension.heightUsingBoundingRect(for: "TEST", withConstrainedWidth: 30, font: ssfont)

        if index > 0 {
            for i in 0...index - 1 {
                let w = StringDimension
                    .widthUsingBoundingRect(for: self.strings[i],
                                            withConstrainedHeight: fontHeight,
                                            font: ssfont) + CGFloat(internalPad)
                if dirX <= 0 {
                    if (runningX - w) <= 0 {
                        runningX = initX - w
                        runningY += dirY * fontHeight
                    } else {
                        runningX -= w
                    }
                } else {
                    if (runningX + w) >= bucketRect.size.width {
                        runningX = initX + w
                        runningY += dirY * fontHeight
                    } else {
                        runningX += w
                    }   //end check if overflow
                }   //end check direction of flow
            }   //end for loop
        }   //end check if not the first one

        let w = StringDimension
            .widthUsingBoundingRect(for: self.strings[index],
                                    withConstrainedHeight: fontHeight,
                                    font: ssfont) + CGFloat(internalPad)

        if dirX <= 0 {
            if (runningX - w) <= 0 {
                runningX = initX
                runningY += dirY * fontHeight
            }
        } else {
            if (runningX + w) >= bucketRect.size.width {
                runningX = initX
                runningY += dirY * fontHeight
            }  //end check if overflow
        }   //end check direction of flow

        //At this point runnoingX and runningY are pointing at the
        //corner of the spot at which to put this tag.  So...
        //
        return CGPoint(x: runningX + dirX * w / 2,
                       y: runningY + dirY * fontHeight / 2)
    }

}   //end struct WrapStack
