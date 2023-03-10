//
//  AvatarView.swift
//  CSWang
//
//  Created by Dove Zachary on 2022/11/30.
//

import SwiftUI
import ShapeBuilder
import SwiftyGif


struct AvatarView<S: StringProtocol>: View {
    var url: URL?
    var fallbackText: S

    enum AvatarShape {
        case circle
        case rounded
        case tile
    }
    var shape: AvatarShape = .circle
    var size: CGFloat = 28
    var animating: Bool = true
    
    var phText: String {
        String(fallbackText).uppercased()
    }
    
    @ShapeBuilder
    var clipShape: some Shape {
        switch shape {
            case .circle:
                Circle()

            case .rounded:
                RoundedRectangle(cornerRadius: ceil(sqrt(size)))

            case .tile:
                Rectangle()
        }
    }
    
    var body: some View {
        
        ZStack {
            if let url = url,
               url.pathExtension == "gif",
               animating == true {
                SwiftyGifView(
                    url: url,
                    animating: true,
                    resetWhenNotAnimating: true
                )
            } else {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray)
                        .overlay(alignment: .center) {
                            Text(phText)
                                .foregroundColor(.white)
                        }
                }
            }
        }
        .frame(width: size, height: size, alignment: .center)
        .clipShape(clipShape)
    }
}

#if DEBUG
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(url: nil, fallbackText: "ABC", size: 30)
    }
}
#endif
