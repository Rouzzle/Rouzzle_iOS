//
//  Font+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import SwiftUI

extension Font {
    
    enum PretendardStyle: String {
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case regular = "Pretendard-Regular"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
    }

    /// Font.TextStyle을 UIFont.TextStyle로 매핑하는 헬퍼 메서드
    private static func mapTextStyle(_ textStyle: Font.TextStyle) -> UIFont.TextStyle {
        switch textStyle {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .caption: return .caption1
        case .caption2: return .caption2
        case .footnote: return .footnote
        @unknown default: return .body
        }
    }
    /// 공통 폰트 생성 메서드
    private static func ptFont(
        _ style: PretendardStyle,
        textStyle: TextStyle? = nil,
        size: CGFloat? = nil
    ) -> Font {
        if let size = size {
            return .custom(style.rawValue, size: size, relativeTo: textStyle ?? .body)
        } else if let textStyle = textStyle {
            let uiTextStyle = mapTextStyle(textStyle)
            let defaultSize = UIFont.preferredFont(forTextStyle: uiTextStyle).pointSize
            return .custom(style.rawValue, size: defaultSize, relativeTo: textStyle)
        } else {
            let defaultSize = UIFont.preferredFont(forTextStyle: .body).pointSize
            return .custom(style.rawValue, size: defaultSize)
        }
    }

    static func ptBold(
        _ textStyle: TextStyle? = nil,
        size: CGFloat? = nil
    ) -> Font {
        ptFont(.bold, textStyle: textStyle, size: size)
    }
        
    static func ptSemiBold(
        _ textStyle: TextStyle? = nil,
        size: CGFloat? = nil
    ) -> Font {
        ptFont(.semiBold, textStyle: textStyle, size: size)
    }

    static func ptMedium(
        _ textStyle: TextStyle? = nil,
        size: CGFloat? = nil
    ) -> Font {
        ptFont(.medium, textStyle: textStyle, size: size)
    }

    static func ptLight(
        _ textStyle: TextStyle? = nil,
        size: CGFloat? = nil
    ) -> Font {
        ptFont(.light, textStyle: textStyle, size: size)
    }

    static func ptRegular(
        _ textStyle: TextStyle? = nil,
        size: CGFloat? = nil
    ) -> Font {
        ptFont(.regular, textStyle: textStyle, size: size)
    }
    
    static var haloDek48: Font {
        return Font.custom("Halo Dek", fixedSize: 48)
    }
    
}
