//
//  DefinableTextView.swift
//  Reed
//
//  Created by Hugo Zhan on 1/17/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//
import SwiftUI

private enum TextOrientation {
    case horizontal
    case vertical
}

class DefinableTextView: UIView {
    var font: UIFont
    
    let id: String
    let content: NSMutableAttributedString
    var selectedRange: NSRange?
    var ctFrame: CTFrame?
    var linesYCoordinates: [CGFloat]?
    private let orientation: TextOrientation
    private var frameSetter: CTFramesetter
    private var path: CGMutablePath {
        let path = CGMutablePath()
        switch orientation {
        case .horizontal:
            path.addRect(self.bounds)
        case .vertical:
            path.addRect(CGRect(x: self.bounds.origin.y, y: self.bounds.origin.x, width: self.bounds.height, height: self.bounds.width))
        }
        return path
    }
    
    init(
        id: String = "",
        content: NSMutableAttributedString = NSMutableAttributedString(),
        font: UIFont = UIFont(),
        isVerticalOrientation: Bool = false
    ) {
        self.id = id
        self.font = font
        self.content = content
        self.content.addAttributes(
            [
                NSAttributedString.Key.font : font as Any,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.verticalGlyphForm: isVerticalOrientation
            ],
            range: NSMakeRange(0, content.length)
        )
        
        self.frameSetter = CTFramesetterCreateWithAttributedString(content)
        self.orientation = isVerticalOrientation ? .vertical : .horizontal
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateRowHeight(
        content: String,
        font: UIFont,
        rowWidth: CGFloat,
        maxRowCount: CGFloat
    ) -> CGFloat {
        let content = NSMutableAttributedString(string: content)
        content.addAttributes(
            [
                NSAttributedString.Key.font : font as Any,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.verticalGlyphForm: self.orientation == .vertical
            ],
            range: NSMakeRange(0, content.length)
        )
        
        frameSetter = CTFramesetterCreateWithAttributedString(content)
        let path = CGMutablePath()
        let rowHeight = ceil(font.lineHeight)
        path.addRect(
            CGRect(
                x: 0,
                y: 0,
                width: rowWidth,
                height: maxRowCount * rowHeight
            )
        )
        ctFrame = CTFramesetterCreateFrame(
            frameSetter,
            CFRangeMake(0, content.length),
            path,
            nil
        )
        let lines = CTFrameGetLines(ctFrame!) as! [CTLine]
        
        let rowCount = CGFloat(lines.endIndex)
        return min(rowCount, maxRowCount) * rowHeight
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // ルビを表示
    override func draw(_ rect: CGRect) {
        // context allows you to manipulate the drawing context (setup to draw or bail out)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        let attributed = content
        frameSetter = CTFramesetterCreateWithAttributedString(content)
        ctFrame = CTFramesetterCreateFrame(
            frameSetter,
            CFRangeMake(0, attributed.length),
            path,
            nil
        )
        let lines = CTFrameGetLines(ctFrame!) as! [CTLine]
        var lineOrigins = Array<CGPoint>(repeating: CGPoint.zero, count: lines.count)
        CTFrameGetLineOrigins(ctFrame!, CFRange(location: 0, length: lines.count), &lineOrigins)
        var yCoordinates = [CGFloat]()
        for (index, _) in lines.enumerated() {
            yCoordinates.append(bounds.height - lineOrigins[index].y)
        }
        linesYCoordinates = yCoordinates
        
        switch orientation {
        case .horizontal:
            context.textMatrix = CGAffineTransform.identity;
            context.translateBy(x: 0, y: self.bounds.size.height);
            context.scaleBy(x: 1.0, y: -1.0);
                
        case .vertical:
            context.rotate(by: .pi / 2)
            context.scaleBy(x: 1.0, y: -1.0)
        }
        CTFrameDraw(ctFrame!, context)
    }    
}
