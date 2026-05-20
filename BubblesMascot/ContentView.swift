//
//  ContentView.swift
//  BubblesMascot
//
//  Created by Afeez Yunus on 16/05/2026.
//

import SwiftUI
import RiveRuntime

enum ScreenState {
    case idle1, idle2, question1, question2, complete
}

struct ContentView: View {
    @State var mascot = RiveViewModel(fileName: "mascot_2", stateMachineName: "Main")
    @State var dataBindingInstance: RiveDataBindingViewModel.Instance?
    @State var background = RiveViewModel(fileName: "background", stateMachineName: "Main")
    @State var animText = RiveViewModel(fileName: "animtext2", stateMachineName: "Main")
    @State var bgDataBindingInstance: RiveDataBindingViewModel.Instance?
    @State var animTextDataBindingInstance: RiveDataBindingViewModel.Instance?
    @State var showSubText = false
    @State var isSpeechBubbleText = "Hello"
    @State var screenState: ScreenState = .idle1
    @State var selectedExperience: ExperienceLevel?
    @State var selectedRoutine: Routine?
    @State var showCompleteText = false
    @State var isTransitioning = false
    @State var showBackground = false
    @State var deviceWidth = UIScreen.main.bounds.width
    @State var deviceHeight = UIScreen.main.bounds.height
    
    enum MascotState: String {
        case idle
        case hello
        case writingIdle
        case writingActive
        case onboardingComplete
    }
    
    private var isQuestionState: Bool {
        screenState == .question1 || screenState == .question2
    }
    
    private var mascotWidth: CGFloat {
        isQuestionState ? 200 : deviceWidth
    }
    
    private var progressValue: Double {
        switch screenState {
        case .idle1, .idle2: return 0.1
        case .question1: return 0.3
        case .question2: return 0.6
        case .complete: return 1.0
        }
    }
    
    var body: some View {
        ZStack {
            background.view()
                .ignoresSafeArea()
                .opacity(showBackground ? 1 : 0)
            
            VStack {
            if screenState != .complete {
                HStack {
                    Image(systemName: "chevron.left")
                        .padding(12)
                        .foregroundStyle(Color("gray500"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    ProgressBar(progress: progressValue)
                        .padding(.horizontal, 8)
                }
                .padding(.top, 8)
            }
            
            if !isQuestionState {
                Spacer()
            }
            
            if screenState == .idle1 || screenState == .idle2 {
                screenContent
                    .padding(.bottom, -48)
            }
            
                HStack {
                mascot.view()
                    .frame(maxWidth: mascotWidth)
                  //  .background(.gray)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.trailing, isQuestionState ? -32 : 0)
                    .padding(.leading, isQuestionState ? -32 : 0)
                    .padding(.top, isQuestionState ? 0 : -40)
                
                if isQuestionState {
                    screenContent
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(height: isQuestionState ? 200 : deviceWidth)
            .padding(.top, isQuestionState ? -32 : 0)
            
            
            if showCompleteText {
                VStack (spacing:0){
                 /*   Text("You're on your way!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("gray700")) */
                    animText.view()
                        .frame(height: 65)
                    if showSubText {
                        Text("Bubbles keeps you on track with lessons puzzles and daily motivation designed just for you!")
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(Color("gray500"))
                            .transition(.opacity)
                    }
                        
                }
                .transition(.opacity)
                .padding(.top, -64)
            }
            
            Spacer()
            
            if screenState == .question1 {
                HStack {
                    OptionPicker(selection: $selectedExperience)
                    Spacer()
                }
                .padding(.bottom, 24)
            }
            if screenState == .question2 {
                HStack {
                    OptionPicker(selection: $selectedRoutine)
                    Spacer()
                }
                .padding(.bottom, 24)
            }
            
            screenButton
        }
        .padding(.horizontal, (screenState == .complete && !showCompleteText) ? 0 : 16)
        
        .onAppear {
            setupBind()
            setupBackgroundBind()
            setupAnimTextBind()
            listenForTransition()
            setMascotState(.idle)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                setMascotState(.hello)
            }
        }
        .onChange(of: screenState) {
            print("screenState changed to: \(screenState)")
        }
        .onChange(of: selectedExperience) {
            guard screenState == .question1 else { return }
            setMascotState(.writingActive)
        }
        .onChange(of: selectedRoutine) {
            guard screenState == .question2 else { return }
            setMascotState(.writingActive)
        }
        }
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    private var screenContent: some View {
        switch screenState {
        case .idle1:
            SpeechBubble(text: "Hi there! I'm Bubbles!", direction: .down)
        case .idle2:
            if !isTransitioning {
                SpeechBubble(text: "Just a couple questions to build a lesson path for you.", direction: .down)
            }
        case .question1:
            SpeechBubble(text: "What's your programming comfort level?", direction: .left)
        case .question2:
            SpeechBubble(text: "Nice! So, how will learning fit into your day?", direction: .left)
        case .complete:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var screenButton: some View {
        switch screenState {
        case .idle1:
            RaisedButton("Continue") {
                withAnimation(.easeInOut(duration: 0.4)) {
                    screenState = .idle2
                }
            }
        case .idle2:
            RaisedButton("Continue") {
                isTransitioning = true
                setMascotState(.writingIdle)
            }
        case .question1:
            RaisedButton("Next", isDisabled: selectedExperience == nil) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    screenState = .question2
                }
            }
        case .question2:
            RaisedButton("Finish", isDisabled: selectedRoutine == nil) {
                showCompleteText = false
                showSubText = false
                showBackground = true
                bgDataBindingInstance?.booleanProperty(fromPath: "isRunning")?.value = true
                background.triggerInput("advance")
                screenState = .complete
                setMascotState(.onboardingComplete)
            }
        case .complete:
            RaisedButton("Begin!", isDisabled: false) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    screenState = .idle1
                    selectedExperience = nil
                    selectedRoutine = nil
                    showCompleteText = false
                    showSubText = false
                    showBackground = false
                    isTransitioning = false
                }
                bgDataBindingInstance?.booleanProperty(fromPath: "isRunning")?.value = true
                background.triggerInput("advance")
                setMascotState(.idle)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    setMascotState(.hello)
                }
            }
        }
    }
    
    func setupBind() {
        let vm = mascot.riveModel?.riveFile.viewModelNamed("MainVm")
        dataBindingInstance = vm!.createInstance(fromName: "Instance")
        mascot.riveModel?.stateMachine?.bind(viewModelInstance: dataBindingInstance!)
        mascot.triggerInput("advance")
        
        let stateEnum = dataBindingInstance!.enumProperty(fromPath: "state")!
        stateEnum.addListener { value in
            print("Rive state: \(value)")
        }
    }
    
    func setupAnimTextBind() {
        let vm = animText.riveModel?.riveFile.viewModelNamed("MainVm")
        animTextDataBindingInstance = vm!.createInstance(fromName: "Instance")
        animText.riveModel?.stateMachine?.bind(viewModelInstance: animTextDataBindingInstance!)
        animText.triggerInput("advance")
        
        let loopEnd = animTextDataBindingInstance!.triggerProperty(fromPath: "loopEnd")!
        loopEnd.addListener {
            withAnimation {
                showSubText = true
            }
        }
    }
    
    func setupBackgroundBind() {
        let vm = background.riveModel?.riveFile.viewModelNamed("MainVm")
        bgDataBindingInstance = vm!.createInstance(fromName: "Instance")
        background.riveModel?.stateMachine?.bind(viewModelInstance: bgDataBindingInstance!)
        background.triggerInput("advance")
        bgDataBindingInstance?.numberProperty(fromPath: "canvasWidth")?.value = Float(deviceWidth)
        bgDataBindingInstance?.numberProperty(fromPath: "canvasHeight")?.value = Float(deviceHeight)
    }
    
    func updateCanvasSize(_ size: CGSize) {
      //  mascotSize = size
        dataBindingInstance?.numberProperty(fromPath: "canvasWidth")?.value = Float(size.width)
        dataBindingInstance?.numberProperty(fromPath: "canvasHeight")?.value = Float(size.height)
    }
    
    func setMascotState(_ state: MascotState) {
        dataBindingInstance?.enumProperty(fromPath: "state")?.value = state.rawValue
        mascot.triggerInput("advance")
    }
    
    func listenForTransition() {
        guard let instance = dataBindingInstance else { return }
        let trigger = instance.triggerProperty(fromPath: "transition")!
        trigger.addListener {
            switch screenState {
            case .idle2:
                withAnimation(.timingCurve(0.91, -0.11, 0.11, 1.1, duration: 1.15)) {
                    screenState = .question1
                }
                setMascotState(.writingIdle)
            case .complete:
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCompleteText = true
                }
                animTextDataBindingInstance?.triggerProperty(fromPath: "play")?.trigger()
                animText.triggerInput("advance")
                bgDataBindingInstance?.booleanProperty(fromPath: "isRunning")?.value = false
                background.triggerInput("advance")
            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}

