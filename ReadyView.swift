import SwiftUI
import AVFoundation

struct ReadyView: View {
    @State var starttimer: Timer? = nil
    
    //Daruma
    @State private var Darumaanimation = false
    @State private var DarumaXOffset: CGFloat = 0.0
    @State private var DarumaRotation: Double = 0.0
    
    //Ready Text
    @State private var AreFadedOutReadyText = true
    
    //Go Text
    @State private var AreFadedOutGoText = true
    
    //Sound
    let ReadySound = ReadySoundClass()
    let GoSound = GoSoundClass()
    
    var body: some View {
        ZStack{
            Image("Tatami").resizable()
            if starttimer != nil {
                //Ready Text
                VStack{
                    Text("Ready ?").font(.system(size: 110)).fontWeight(.black).foregroundColor(Color.red)
                        .opacity(AreFadedOutReadyText ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 2.3))
                }.frame(maxWidth: .infinity, maxHeight: 300).background(Color.gray.opacity(0.6))
                VStack{
                    Text("Ready ?").font(.system(size: 100)).fontWeight(.black).foregroundColor(Color.white)
                        .opacity(AreFadedOutReadyText ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 2.3))
                }.frame(maxWidth: .infinity, maxHeight: 300)
                //Daruma
                VStack{
                    Image("Daruma").resizable().scaledToFit().frame(width: 200, height: 200)
                        .rotationEffect(.degrees(Darumaanimation ? DarumaRotation : 0.0))
                        .offset(x: Darumaanimation ? DarumaXOffset : -UIScreen.main.bounds.width / 2 - 100, y: 0)
                        .animation(Animation.linear(duration: Darumaanimation ? 2.0 : 0).repeatForever(autoreverses: false))
                }
                Text("Go!!").font(.system(size: 260)).fontWeight(.black).foregroundColor(Color.red)
                    .opacity(AreFadedOutGoText ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.1))
                Text("Go!!").font(.system(size: 250)).fontWeight(.black).foregroundColor(Color.white)
                    .opacity(AreFadedOutGoText ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.1))
            }
        }.onAppear{
            ReadySound.play()
            StartAnimation()
        }
    }
    //Function to display the animation when starting the game
    private func StartAnimation(){
        var count: Int = 0
        starttimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if count == 10{
                //Daruma
                self.Darumaanimation.toggle()
                withAnimation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                    DarumaRotation = 360.0
                    DarumaXOffset = UIScreen.main.bounds.width - 100
                }
                //Ready
                withAnimation {
                    self.AreFadedOutReadyText.toggle()
                }
            } else if count == 27{
                //Daruma
                self.Darumaanimation.toggle()
            } else if count == 37{
                //Ready
                AreFadedOutReadyText = true
            } else if count == 52{
                //Go
                withAnimation {
                    self.AreFadedOutGoText.toggle()
                    ReadySound.stop()
                    GoSound.play()
                }
            } else if count == 57{
                //go
                AreFadedOutGoText = true
                starttimer?.invalidate()
                starttimer = nil
            }
            count += 1
        }
    }
}

#Preview {
    ReadyView()
}

class ReadySoundClass {
    private var readySound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "SE-Ready", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        readySound = try! AVAudioPlayer(contentsOf: soundURL)
        readySound.prepareToPlay()
    }
    
    func play() {
        readySound.play()
    }
    func stop() {
        readySound.stop()
    }
}

class GoSoundClass {
    private var goSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "SE-Go", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        goSound = try! AVAudioPlayer(contentsOf: soundURL)
        goSound.prepareToPlay()
    }
    
    func play() {
        goSound.play()
    }
}
