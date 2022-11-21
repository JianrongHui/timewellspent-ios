//
//  MeditationView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore

struct MeditationView: View {
    
    @Environment(\.meditation) var isMeditating

    @State var isBreathing: Bool = false
    @State var isShowingDirections: Bool = true
    @State var breatheIn: Bool = false
    @State var hasAnswered: Bool = false
    
    var previousRating: Int = 0
    let breatheTimeInSeconds: UInt64 = 4
    
    var titleText: String {
        isBreathing ?
        (breatheIn ? "Breathe in" : "Breathe out") :
        (isShowingDirections ?
         (hasAnswered ? "We hope you enjoyed your mindberry." : "Let's begin a short mindfulness break.") :
            (hasAnswered ? "Now I'm feeling..." : "Right now I'm feeling..."))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Mindberry")
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.body)
            Spacer()
            Text(titleText)
                .multilineTextAlignment(.center)
            HStack(alignment: .center, spacing: 10) {
                ForEach(1..<6, id: \.self) { id in
                    Button {
                        if hasAnswered {
                            handleAfterButtonPress(id)
                        } else {
                            handleBeforeButtonPress(id)
                        }
                    } label: {
                        Image("face" + String(id))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                    }
                }
            }
            .isHidden(isBreathing || isShowingDirections, remove: true)
            Circle()
                .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .center)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                .isHidden(!isBreathing || isShowingDirections, remove: true)
                .scaleEffect(breatheIn ? 0.9 : 0.5)
                .animation(.easeInOut(duration: Double(breatheTimeInSeconds)), value: breatheIn)
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .padding([.top, .leading, .trailing], 35)
        .padding(.bottom, 80)
        .background(.tint)
        .foregroundColor(.white)
        .font(.title2)
        .fontWeight(.bold)
        .onAppear {
            Task {
                do {
                    try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                    withAnimation { isShowingDirections = false }
                }
            }
        }
    }
    
    func handleBeforeButtonPress(_ index: Int) {
        SessionService.shared.currentSession.beforeRating = index
        Task {
            await startMeditation()
        }
    }
    
    func handleAfterButtonPress(_ index: Int) {
        SessionService.shared.currentSession.afterRating = index
        SessionService.shared.postToFirebase()
        withAnimation { isMeditating.wrappedValue.toggle() }
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    func startMeditation() async {
        do {
            withAnimation {
                isBreathing = true
                breatheIn = true
            }
            hasAnswered = true //should come after the 3 second wait, so that the proper instructions are shown
            for _ in 0..<(12*DeviceService.shared.getMindfulnessDuration() + 1) {
                withAnimation { breatheIn.toggle() }
                try await Task.sleep(nanoseconds: breatheTimeInSeconds * NSEC_PER_SEC)
            }
            withAnimation {
                isShowingDirections = true
                isBreathing = false
            }
            try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
            withAnimation { isShowingDirections = false }
            await MyManagedSettingsService.shared.pauseUntilNextHour()
        } catch {
            print("lmfao")
        }
    }
    
    
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MeditationView()
        }
    }
}
