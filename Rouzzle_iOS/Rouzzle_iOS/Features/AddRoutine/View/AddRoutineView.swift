//
//  AddRoutineView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import SwiftUI
import Combine

struct AddRoutineView: View {
    @Bindable var viewModel: AddRoutineViewModel
    @State private var showWeekSetTimeView: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    EmojiButton(
                        selectedEmoji: $viewModel.emoji,
                        emojiButtonType: .routineEmoji
                    ){ selectedEmoji in
                        print("Selected Emoji: \(selectedEmoji)")
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height * 0.05)
                    RoutineBasicSettingView(viewModel: viewModel, action: {
                        showWeekSetTimeView.toggle()
                    })
                    
                    RoutineNotificationView(viewModel: viewModel)
                        .frame(minHeight: proxy.size.height * 0.28, alignment: .top)
                    
                    RouzzleButton(buttonType: .next, disabled: viewModel.disabled, action: {
                        viewModel.getRecommendTask()
                        viewModel.step = .task
                    })
                    .frame(alignment: .bottom)
                    .animation(.smooth, value: viewModel.disabled)
                }
            }
            .fullScreenCover(isPresented: $showWeekSetTimeView, content: {
                EmptyView()
            })
        }
    }
}

struct RoutineBasicSettingView: View {
    @Bindable var viewModel: AddRoutineViewModel
    let action: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            RouzzleTextField(text: $viewModel.title, placeholder: "제목을 입력해주세요.")
                .font(.regular16)
            
            HStack {
                Text("반복 요일")
                    .font(.semibold18)
                Spacer()
                
                HStack {
                    Image(systemName: viewModel.isDaily ? "checkmark.square" : "square")
                    Text("매일")
                        .font(.regular16)
                }
                .foregroundColor(viewModel.isDaily ? .black : .gray)
                .onTapGesture {
                    viewModel.toggleDaily()
                }
            }
            
            // 반복 요일 선택 버튼
            HStack(spacing: 15) {
                ForEach(Day.allCases, id: \.self) { day in
                    Button {
                        viewModel.toggleDay(day)
                    } label: {
                        ZStack {
                            if viewModel.isSelected(day) {
                                Circle()
                                    .strokeBorder(.stroke, lineWidth: 2)
                                    .background(Circle().fill(Color.background))
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                            }
                            Text(day.name)
                                .foregroundColor(viewModel.isSelected(day) ? .black : .gray)
                                .font(.regular16)
                        }
                        .frame(maxWidth: .infinity, minHeight: 35)
                    }
                    .frame(height: 35)
                }
            }
            
            Divider()
            
            HStack(alignment: .top) {
                Text("시작 시간")
                    .font(.semibold18)
                Spacer()
                if let firstDayTime = viewModel.firstDayTime  {
                    VStack(spacing: 4) {
                        Button (action: action) {
                            Text(firstDayTime)
                                .foregroundStyle(.black)
                                .font(.regular18)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        
                        if viewModel.checkIfTimesAreDifferent() {
                            Text("(요일별로 다름)")
                                .font(.regular12)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
        .animation(.smooth, value: viewModel.selectedDateWithTime)
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .clipShape(.rect(cornerRadius: 20))
    }
}

struct RoutineNotificationView: View {
    @Bindable var viewModel: AddRoutineViewModel
    @State private var isOneAlarm: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("루틴 시작 알림")
                    .font(.semibold18)
                Spacer()
                Toggle("", isOn: $viewModel.isNotificationEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .accent))
            }
            
            if viewModel.isNotificationEnabled {
                Divider()
                
                // 알람 체크박스
                HStack(spacing: 10) {
                    Text("알림 빈도")
                        .font(.headline)
                    Image(systemName: isOneAlarm ? "checkmark.square" : "square")
                    Text("1회만")
                        .font(.regular16)
                        .foregroundStyle(isOneAlarm ? .black : .gray)
                    Spacer()
                }
                .onTapGesture {
                    isOneAlarm.toggle()
                }
                
                HStack(spacing: 10) {
                    // 분 선택
                    RouzzlePicker(
                        unit: "분",
                        isDisabled: !viewModel.isNotificationEnabled, // 알림이 활성화되어야 사용 가능
                        options: [1, 3, 5, 7, 10], // 선택 가능한 간격
                        selection: Binding(
                            get: { viewModel.interval ?? 1 },
                            set: { newValue in
                                viewModel.interval = newValue
                                print("Interval 선택됨: \(viewModel.interval ?? 0)")
                            }
                        )
                    )
                    
                    Text("간격으로")
                        .foregroundStyle(isOneAlarm ? .gray : .primary)
                    
                    // 횟수 선택
                    RouzzlePicker(
                        unit: "번",
                        isDisabled: !viewModel.isNotificationEnabled, // 알림이 활성화되어야 사용 가능
                        options: [1, 2, 3, 4, 5], // 선택 가능한 횟수
                        selection: Binding(
                            get: { viewModel.repeatCount ?? 1 },
                            set: { newValue in
                                viewModel.repeatCount = newValue
                                print("Repeat Count 선택됨: \(viewModel.repeatCount ?? 0)")
                            }
                        )
                    )
                    
                    Text("알려드릴게요")
                        .foregroundStyle(isOneAlarm ? .gray : .primary)
                    
                    Spacer()
                }
            }
        }
        .animation(.smooth, value: viewModel.isNotificationEnabled)
        .padding()
        .background(Color.fromRGB(r: 248, g: 247, b: 247))
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    AddRoutineView(viewModel: AddRoutineViewModel())
}
