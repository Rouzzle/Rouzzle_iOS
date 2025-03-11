//
//  RoutineSettingsSheet.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 3/11/25.
//

import SwiftUI

struct RoutineSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowingEditRoutineSheet: Bool
    @Binding var isShowingDeleteAlert: Bool
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                isShowingEditRoutineSheet = true
                dismiss()
            } label: {
                Text("수정하기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Button {
                dismiss()
                isShowingDeleteAlert = true
            } label: {
                Text("삭제하기")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                Text("취소")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.ptRegular())
        .padding(.horizontal)
    }
}

#Preview {
    RoutineSettingsSheet(isShowingEditRoutineSheet: .constant(false), isShowingDeleteAlert: .constant(false))
}
