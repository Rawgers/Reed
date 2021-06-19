//
//  DefinableTextView.swift
//  Reed
//
//  Created by Hugo Zhan on 1/17/21.
//  Copyright © 2021 Roger Luo. All rights reserved.
//

import UIKit

private enum TextOrientation {
    case horizontal
    case vertical
}

class DefinableTextView: UIView {
    var content: NSMutableAttributedString
    var ctFrame: CTFrame?
    var linesYCoordinates: [CGFloat]?
    let font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: 20)
    private let orientation: TextOrientation
    private var frameSetter: CTFramesetter
    lazy private var path: CGMutablePath = {
        let path = CGMutablePath()
        switch orientation {
        case .horizontal:
            path.addRect(self.bounds)
        case .vertical:
            path.addRect(CGRect(x: self.bounds.origin.y, y: self.bounds.origin.x, width: self.bounds.height, height: self.bounds.width))
        }
        return path
    }()
    
    init(
        frame: CGRect,
        content: NSMutableAttributedString,
        isVerticalOrientation: Bool = false
    ) {
        self.content = content
        self.content.addAttributes(
            [
                NSAttributedString.Key.font : self.font as Any,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.verticalGlyphForm: isVerticalOrientation
            ],
            range: NSMakeRange(0, self.content.length)
        )
        frameSetter = CTFramesetterCreateWithAttributedString(content)
        self.orientation = isVerticalOrientation ? .vertical : .horizontal

        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        switch orientation {
        case .horizontal:
            context.textMatrix = CGAffineTransform.identity;
            context.translateBy(x: 0, y: self.bounds.size.height);
            context.scaleBy(x: 1.0, y: -1.0);
                
        case .vertical:
            context.rotate(by: .pi / 2)
            context.scaleBy(x: 1.0, y: -1.0)
        }
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
        CTFrameDraw(ctFrame!, context)
    }
    
    func lengthThatFits(start: Int) -> Int {
        ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(start, content.length - start), path, nil)
        return min(CTFrameGetVisibleStringRange(ctFrame!).length as Int, content.length - start)
    }
}

extension String {
    // 文字列の範囲
    private var stringRange: NSRange {
        return NSMakeRange(0, self.utf16.count)
    }
    
    // 特定の正規表現を検索
    private func searchRegex(of pattern: String) -> NSTextCheckingResult? {
        do {
            let patternToSearch = try NSRegularExpression(pattern: pattern)
            return patternToSearch.firstMatch(in: self, range: stringRange)
        } catch { return nil }
    }
    
    // 特定の正規表現を置換
    private func replaceRegex(of pattern: String, with templete: String) -> String {
        do {
            let patternToReplace = try NSRegularExpression(pattern: pattern)
            return patternToReplace.stringByReplacingMatches(in: self, range: stringRange, withTemplate: templete)
        } catch { return self }
    }
    
    // ルビを生成
    func createRuby() -> NSMutableAttributedString {
        let textWithRuby = self
            // ルビ付文字(「｜紅玉《ルビー》」)を特定し文字列を分割
            .replaceRegex(of: "(｜.+?《.+?》)", with: ",$1,")
            .components(separatedBy: ",")
            // ルビ付文字のルビを設定
            .map { component -> NSAttributedString in
                // ベース文字(漢字など)とルビをそれぞれ取得
                guard let pair = component.searchRegex(of: "｜(.+?)《(.+?)》") else {
                    return NSAttributedString(string: component)
                }
                let component = component as NSString
                let baseText = component.substring(with: pair.range(at: 1))
                let rubyText = component.substring(with: pair.range(at: 2))
                
                // ルビの表示に関する設定
                let rubyAttribute: [CFString: Any] =  [
                    kCTRubyAnnotationSizeFactorAttributeName: 0.5,
                    kCTForegroundColorAttributeName: UIColor.secondaryLabel
                ]
                let rubyAnnotation = CTRubyAnnotationCreateWithAttributes(
                    .center,    // center furigana over base
                    .none,      // when furigana is longer than base, pad base
                    .before,    // places furigana on top of base
                    rubyText as CFString,
                    rubyAttribute as CFDictionary
                )
                
                return NSAttributedString(
                    string: baseText,
                    attributes: [kCTRubyAnnotationAttributeName as NSAttributedString.Key: rubyAnnotation]
                )
            }
            
            // 分割されていた文字列を結合
            .reduce(NSMutableAttributedString()) {
                $0.append($1)
                return $0
            }
        
        return textWithRuby
    }
}

extension NSAttributedString.Key {
    static let rubyAnnotation: NSAttributedString.Key = kCTRubyAnnotationAttributeName as NSAttributedString.Key
}

extension NSMutableAttributedString {
    func addAttributes(_ attrs: [NSAttributedString.Key: Any] = [:]) {
        addAttributes(attrs, range: NSRange(string.startIndex ..< string.endIndex, in: string))
    }
}

extension NSRegularExpression {
    func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        return matches(in: string, options: options, range: NSRange(string.startIndex ..< string.endIndex, in: string))
    }
}
