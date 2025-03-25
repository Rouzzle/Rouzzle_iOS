//
//  RoutineCompleteView.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 3/18/25.
//

import SwiftUI

struct RoutineCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // MARK: - 루틴 이름 박스
            HStack {
                Text("☀️")
                    
                Text("아침 루틴")
            }
            .font(.ptBold(.title))
            .padding(.top, 60)
            
            // MARK: - 루틴 시작 및 완료 시간
            Text("1:46 PM ~ 2:06 PM")
                .font(.ptRegular())
                .foregroundStyle(.rz747272)
                .padding(.top)
            
            // MARK: - 연속일, 누적일 박스
            HStack {
                VStack(spacing: 6) {
                    Text("\(0)")
                        .font(.ptBold(.title))
                    
                    Text("연속일")
                        .font(.ptRegular())
                        .foregroundStyle(.rz747272)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 60)
                
                VStack(spacing: 6) {
                    Text("\(0)")
                        .font(.ptBold(.title))
                    
                    Text("누적일")
                        .font(.ptRegular())
                        .foregroundStyle(.rz747272)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 113)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.RZFAFAFA)
            )
            .padding(.top, 39)
            .padding(.horizontal, 46)
            
            // MARK: - 완료한 할 일 리스트
            ScrollView {
                VStack(spacing: 18) {
                    HStack(spacing: 18) {
                        Text("☕️")
                            .font(.largeTitle)
                        
                        Text("커피 마시기")
                            .font(.ptSemiBold())
                        
                        Spacer()
                        
                        Text("10분")
                            .font(.ptRegular())
                            .foregroundStyle(.rz747272)
                    }
                    
                    HStack(spacing: 18) {
                        Text("💊")
                            .font(.largeTitle)
                        
                        Text("유산균 먹기")
                            .font(.ptSemiBold())
                        
                        Spacer()
                        
                        Text("10분")
                            .font(.ptRegular())
                            .foregroundStyle(.rz747272)
                    }
                }
                .padding(.horizontal, 46)
            }
            .padding(.top, 51)
            
            RouzzleButton(buttonType: .complete) {
                // 완료 버튼 로직
            }
            .padding()
        }
    }
}

#Preview {
    RoutineCompleteView()
}
