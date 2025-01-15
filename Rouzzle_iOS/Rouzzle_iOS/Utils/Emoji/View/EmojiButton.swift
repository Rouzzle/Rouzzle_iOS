//
//  EmojiView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI
enum EmojiButtonType {
    case keyboard
    case routineEmoji
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .keyboard:
            Image(systemName: "circle.dotted")
                .font(.system(size: 24))
        case .routineEmoji:
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 5]))
                .frame(width: 62, height: 62)
                .overlay {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                }
        }
    }
}

struct EmojiButton: View {
    @State private var showSheet = false
    @Binding var selectedEmoji: String?
    private(set) var emojiButtonType: EmojiButtonType
   // var onEmojiSelected: (String) -> Void

    init(selectedEmoji: Binding<String?>, emojiButtonType: EmojiButtonType) {
        self._selectedEmoji = selectedEmoji
        self.emojiButtonType = emojiButtonType
    }

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    if let emoji = selectedEmoji {
                        Text(emoji)
                            .font(.system(size: 70))
                    } else {
                        emojiButtonType.view
                    }
                })
            }
        }
        .sheet(isPresented: $showSheet) {
            EmojiPickerView(
                selectedEmoji: Binding(
                    get: { selectedEmoji ?? "🧩" },  // selectedEmoji가 nil일 때 "🧩"를 기본값으로 제공
                    set: { selectedEmoji = $0 }
                ),
                onEmojiSelected: { emoji in
                    selectedEmoji = emoji
                    showSheet = false
                }
            )
        }
    }
}

struct KeyboardEmojiButton: View {
    var body: some View {
        Image(systemName: "circle.dotted")
            .font(.system(size: 24))
    }
}

struct PrimaryEmojiButton: View {
    var body: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 5]))
            .frame(width: 62, height: 62)
            .overlay {
                Image(systemName: "plus")
                    .font(.largeTitle)
            }
    }
}
