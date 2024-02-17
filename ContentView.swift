import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var Showshould_HowToPlayView = false
    @State private var Showshould_PlayView = false
    @State private var Showshould_RankingView = false
    
    //Picker
    @State private var WithOrWithoutCooldown = false
    @State private var SelectedTimerValue = 1
    @State var TimeLimit: Int = 0
    
    //AttentionAlert
    @State private var AttentionAlert = false
    
    //Sound
    let ButtonTapSound = ButtonTapSoundClass()
    let DarumaBGM = DarumaBGMClass()
    
    var body: some View {
        NavigationStack{
            ZStack{
                NavigationLink(destination: PlayView(TimeLimit: TimeLimit, WithOrWithoutCooldown: WithOrWithoutCooldown), isActive: $Showshould_PlayView){
                    EmptyView()
                }
                NavigationLink(destination: HowToPlayView(), isActive: $Showshould_HowToPlayView){
                    EmptyView()
                }
                NavigationLink(destination: RankingView(), isActive: $Showshould_RankingView) {
                    EmptyView()
                }
                Image("Tatami2").resizable()
                VStack {
                    HStack{
                        Spacer()
                        Button(action: {
                            ButtonTapSound.play()
                            Showshould_HowToPlayView = true
                        }){
                            Text("HowToPlay").font(Font.custom("ChalkboardSE-Bold", size: 20)).frame(width: 160, height: 50).background(Color.red).foregroundColor(Color.white).cornerRadius(10)
                        }.padding()
                    }
                    Spacer()
                    HStack{
                        Image("Darumatitle").resizable().scaledToFit().frame(width: 220, height: 220)
                        Image("Daruma").resizable().scaledToFit().frame(width: 180, height: 180)
                        Image("Darumatitle2").resizable().scaledToFit().frame(width: 170, height: 170)
                    }
                    Spacer()
                    HStack{
                        Text("Rule Settings").font(Font.custom("ChalkboardSE-Bold", size: 40)).foregroundColor(Color.black)
                        Image(systemName: "book").resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(Color.black)
                    }
                    HStack{
                        ZStack{
                            VStack{
                                Text("Buffer").font(Font.custom("ChalkboardSE-Bold", size: 20))
                                Toggle("", isOn: $WithOrWithoutCooldown)
                                    .toggleStyle(Togglestyle())
                            }.frame(width: 210, height: 180).background(Color.brown).cornerRadius(20)
                            VStack{
                                HStack{
                                    Rectangle().frame(width: 180, height: 1).foregroundColor(.clear)
                                    Image(systemName: "stopwatch").scaledToFit().frame(width: 60, height: 60).background(Color.white).foregroundColor(.black).cornerRadius(10).shadow(radius: 10)
                                }
                                Rectangle().frame(width: 1, height: 160).foregroundColor(.clear)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("Time limit").font(Font.custom("ChalkboardSE-Bold", size: 20))
                                Picker("Timelimit", selection: $SelectedTimerValue) {
                                    Text("None").tag(1)
                                    Text("30Second").tag(2)
                                    Text("20Second").tag(3)
                                    Text("10Second").tag(4)
                                }.frame(width: 120, height: 60).background(Color.white).cornerRadius(10)
                            }.frame(width: 220, height: 180).background(Color.brown).cornerRadius(20)
                            VStack{
                                HStack{
                                    Rectangle().frame(width: 180, height: 1).foregroundColor(.clear)
                                    Image(systemName: "timer").frame(width: 60, height: 60).background(Color.white).foregroundColor(.black).cornerRadius(10).shadow(radius: 10)
                                }
                                Rectangle().frame(width: 1, height: 160).foregroundColor(.clear)
                            }
                        }
                    }
                    HStack{
                        Button(action: {
                            ButtonTapSound.play()
                            Showshould_RankingView = true
                        }){
                            Text("Ranking").font(Font.custom("ChalkboardSE-Bold", size: 35)).frame(width: 200, height: 100).background(Color.red).foregroundColor(Color.white).cornerRadius(10).shadow(radius: 10)
                        }
                        Button(action: {
                            //Timer set from those selected by Picker
                            if SelectedTimerValue == 2{
                                TimeLimit = 30
                            } else if SelectedTimerValue == 3{
                                TimeLimit = 20
                            } else if SelectedTimerValue == 4{
                                TimeLimit = 10
                            } else {
                                TimeLimit = -1
                            }
                            ButtonTapSound.play()
                            Showshould_PlayView = true
                        }){
                            Text("Start").font(Font.custom("ChalkboardSE-Bold", size: 35)).frame(width: 200, height: 100).background(Color.red).foregroundColor(Color.white).cornerRadius(10).shadow(radius: 10)
                        }
                    }
                    Spacer()
                }
            }
            .onAppear{
                DarumaBGM.play()
                HorizontalScreenDetection()
            }
            .onDisappear{
                DarumaBGM.stop()
            }
            .alert(isPresented: $AttentionAlert) {
                Alert(title: Text("👀 Attention ⚠️"),
                      message: Text("For you to completely enjoy the game😄 \n Please keep your screen upward!"),
                      dismissButton: .default(Text("OK"))
                )
            }
        }.navigationBarBackButtonHidden(true)
    }
    //Get screen orientation
    func HorizontalScreenDetection(){
        let orientation:UIDeviceOrientation = UIDevice.current.orientation
        switch orientation{
        case .unknown:
            AttentionAlert = true
        case .landscapeLeft:
            AttentionAlert = true
        case .landscapeRight:
            AttentionAlert = true
        default:
            break
        }
    }
}

#Preview {
    ContentView()
}

struct Togglestyle: ToggleStyle {
    static let backgroundColor = Color(.label)
    static let switchColor = Color(.systemBackground)
    
    func makeBody(configuration: Configuration) -> some View {
        
        HStack {
            configuration.label
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 50, height: 30, alignment: .center)
                .overlay((
                    Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(configuration.isOn ? .white : Togglestyle.switchColor)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10, y: 0)
                        .animation(.linear)
                ))
                .foregroundColor(configuration.isOn ? .green : Togglestyle.backgroundColor)
                .onTapGesture(perform: {
                    configuration.isOn.toggle()
                })
            
        }
    }
}

class DarumaBGMClass {
    private var darumaBGM: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "DarumaBGM", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        darumaBGM = try! AVAudioPlayer(contentsOf: soundURL)
        darumaBGM.prepareToPlay()
    }
    
    func play() {
        darumaBGM.play()
    }
    func stop() {
        darumaBGM.stop()
    }
}

class ButtonTapSoundClass {
    private var buttonTapSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "SE-ButtonTap", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        buttonTapSound = try! AVAudioPlayer(contentsOf: soundURL)
        buttonTapSound.prepareToPlay()
    }
    
    func play() {
        buttonTapSound.play()
    }
}
