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
    
    @State var isBreathing: Bool = false
    @State var breatheIn: Bool = false
    @Environment(\.meditation) var isMeditating
    
    var previousRating: Int = 0
    
    let breatheTimeInSeconds: UInt64 = 4
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Mindberry")
            Spacer()
            Text(isBreathing ? (breatheIn ? "Breathe in" : "Breathe out") : "Right now I'm feeling...")
            HStack(alignment: .center, spacing: 10) {
                ForEach(1..<6, id: \.self) { id in
                    Button {
                        let hasAnsweredBeforeQuestion = SessionService.shared.currentSession.beforeRating != 0
                        if hasAnsweredBeforeQuestion {
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
            .isHidden(isBreathing, remove: true)
            Circle()
                .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .center)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                .isHidden(!isBreathing, remove: true)
                .scaleEffect(breatheIn ? 0.9 : 0.5)
                .animation(.easeInOut(duration: Double(breatheTimeInSeconds)), value: breatheIn)
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(.tint)
        .foregroundColor(.white)
        .font(.title2)
        .fontWeight(.bold)
    }
    
    func handleBeforeButtonPress(_ index: Int) {
        SessionService.shared.currentSession.beforeRating = index
        Task {
            await startMeditation()
        }
    }
    
    func handleAfterButtonPress(_ index: Int) {
        SessionService.shared.currentSession.afterRating = index
        SessionService.shared.currentSession.timestamp = Date().timeIntervalSince1970
        SessionService.shared.postToFirebase()
    }
    
    func startMeditation() async {
        isBreathing = true
        do {
            try await Task.sleep(nanoseconds: 10)
            for _ in 0..<10 {
                breatheIn = !breatheIn
                try await Task.sleep(nanoseconds: breatheTimeInSeconds * NSEC_PER_SEC)
            }
            MyManagedSettings.shared.pauseUntilNextHour()
            isMeditating.wrappedValue.toggle()
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
