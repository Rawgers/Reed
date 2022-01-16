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

private enum HighlightDrawingConstants {
    static let HIGHLIGHT_COLOR = UIColor(red: 237 / 255, green: 237 / 255, blue: 135 / 255, alpha: 0.5)
    static let CORNER_RADIUS: CGFloat = 8.5
    static let LINE_SPACING_MODIFIER: CGFloat = 4
    
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
        font: UIFont = UIFont.systemFont(ofSize: 20),
        isVerticalOrientation: Bool = false
    ) {
        self.id = id
        self.font = font
        self.content = content
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = font.lineHeight + HighlightDrawingConstants.LINE_SPACING_MODIFIER
        self.content.addAttributes(
            [
                NSAttributedString.Key.font : font as Any,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.verticalGlyphForm: isVerticalOrientation,
                NSAttributedString.Key.kern: 0.5,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = font.lineHeight + HighlightDrawingConstants.LINE_SPACING_MODIFIER
        content.addAttributes(
            [
                NSAttributedString.Key.font : font as Any,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.verticalGlyphForm: self.orientation == .vertical,
                NSAttributedString.Key.kern: 0.5,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ],
            range: NSMakeRange(0, content.length)
        )
        
        frameSetter = CTFramesetterCreateWithAttributedString(content)
        let path = CGMutablePath()
        let rowHeight = ceil(font.lineHeight) + HighlightDrawingConstants.LINE_SPACING_MODIFIER
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
        
        let lines = CTFrameGetLines(ctFrame!) as! [CTLine]
        var lineOrigins = Array<CGPoint>(repeating: CGPoint.zero, count: lines.count)
        CTFrameGetLineOrigins(ctFrame!, CFRange(location: 0, length: lines.count), &lineOrigins)
        var yCoordinates = [CGFloat]()
        for (lineIndex, _) in lines.enumerated() {
            let line = lines[lineIndex]
            let runs: [CTRun] = line.ctruns
            for run in runs {
                let cornerRadius: CGFloat = HighlightDrawingConstants.CORNER_RADIUS
                var imgBounds: CGRect = .zero
                let runRange = CTRunGetStringRange(run)
                if (selectedRange != nil
                    && selectedRange!.location <= runRange.location
                    && selectedRange!.location + selectedRange!.length
                    >= runRange.location + runRange.length)
                {
                    let value = HighlightDrawingConstants.HIGHLIGHT_COLOR
                    var ascent: CGFloat = 0
                    var descent: CGFloat = 0
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, nil))
                    imgBounds.size.height = ascent + descent + HighlightDrawingConstants.LINE_SPACING_MODIFIER
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = lineOrigins[lineIndex].x + xOffset
                    imgBounds.origin.y = lineOrigins[lineIndex].y - descent - HighlightDrawingConstants.LINE_SPACING_MODIFIER / 2
                    let path = UIBezierPath(roundedRect: imgBounds, cornerRadius: cornerRadius)
                    value.setFill()
                    path.fill()
                    value.setStroke()
                }
            }
            yCoordinates.append(bounds.height - lineOrigins[lineIndex].y)
        }
        linesYCoordinates = yCoordinates
    }
}

extension CTFrame {

    var lines: [CTLine] {
        let linesAO: [AnyObject] = CTFrameGetLines(self) as [AnyObject]
        guard let lines = linesAO as? [CTLine] else {
           return []
        }

       return lines
   }
}

extension CTLine {
   var ctruns: [CTRun] {
       let linesAO: [AnyObject] = CTLineGetGlyphRuns(self) as [AnyObject]
       guard let lines = linesAO as? [CTRun] else {
           return []
       }

       return lines
   }
}
