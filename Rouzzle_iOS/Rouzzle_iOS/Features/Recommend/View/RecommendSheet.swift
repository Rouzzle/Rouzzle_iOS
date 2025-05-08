//
//  RecommendSheet.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI

struct RecommendSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let tasks: [RecommendTodoTask]
    let routines: [RoutineItem]
    let saveRoutine: (RoutineItem?) -> Void
    
    @State private var selectedRoutineId: UUID?
    @State private var showAddRoutine = false
    
    var selectedRoutine: RoutineItem? {
        if selectedRoutineId == nil {
            return nil
        } else {
            return routines.first(where: { $0.id == selectedRoutineId })
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 3)
                .padding(.top, 8)
                .padding(.bottom, -40)
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("닫기")
                            .font(.ptMedium(size: 16))
                    }
                    Spacer()
                    Button {
                        if selectedRoutineId == nil {
                            showAddRoutine = true
                        } else {
                            saveRoutine(selectedRoutine)
                            dismiss()
                        }
                    } label: {
                        Text("완료")
                            .font(.ptMedium(size: 16))
                    }
                }
                .padding()
                
                Picker("루틴 선택", selection: $selectedRoutineId) {
                    ForEach(routines, id: \.id) { routine in
                        Text(routine.title).tag(Optional(routine.id))
                            .font(.ptMedium(size: 20))
                    }
                    
                    Text("루틴 추가하기").tag(nil as UUID?)
                        .font(.ptMedium(size: 20))
                }
                .pickerStyle(.wheel)
            }
            .padding()
        }
        .onAppear {
            if !routines.isEmpty {
                selectedRoutineId = routines.first?.id
            } else {
                selectedRoutineId = nil
            }
        }
        .fullScreenCover(isPresented: $showAddRoutine) {
            AddRoutineContainerView()
                .onDisappear {
                    if !routines.isEmpty {
                        selectedRoutineId = routines.first?.id
                    }
                }
        }
    }
}

#Preview {
    RecommendSheet(
        tasks: [],
        routines: [],
        saveRoutine: { _ in }
    )
}
