import SwiftUI
import AVFoundation

struct PlayView: View {
    @State private var Showshould_ResultView = false
    @State private var Showshould_PauseView = false
    
    @State private var PlayDetection = false
    
    @State var ReadyTimer: Timer? = nil
    
    //DarumaTouchAnimation
    @State var count: Int = 1
    @State var DarumaTouchAnimationTimer: Timer? = nil
    
    //Time limit
    @State var TimeLimit: Int
    @State var SelectedTimeLimit: Int = 0
    @State var GoalSecond: Int = 0
    
    //Daruma
    @State var MainTimer: Timer? = nil
    @State var DarumaPlace: CGPoint = CGPoint(x: 0, y: 0)
    @State var DarumaLookBacktimer: Timer? = nil
    @State var FuncState: Bool = true
    @State var DarumaState: Bool = false
    @State var WithOrWithoutCooldown: Bool
    @State var CoolDown: Bool = false
    @State var TouchJudgement: Bool = false
    
    //Human
    @State var HumanImage: CGSize = CGSize(width: 100, height: 100)
    @State var HumanPlace: CGPoint = CGPoint(x: 0, y: 0)
    @State var PlayResult: String = ""
    
    //Sound
    var WadaikoSound = WadaikoSoundClass()
    var FindingsSound = FindingsSoundClass()

    //Movebutton
    @State private var isAnimating: Bool = false
    var color: Color
    var buttonWidth: CGFloat
    var numberOfOuterCircles: Int
    var animationDuration: Double
    var circleArray = [CircleData]()
    
    init(color: Color = Color.red,  buttonWidth: CGFloat = 80, numberOfOuterCircles: Int = 2, animationDuration: Double = 1, TimeLimit: Int, WithOrWithoutCooldown: Bool) {
        self.color = color
        self.buttonWidth = buttonWidth
        self.numberOfOuterCircles = numberOfOuterCircles
        self.animationDuration = animationDuration
        self.TimeLimit = TimeLimit
        self.WithOrWithoutCooldown = WithOrWithoutCooldown
        
        var circleWidth = self.buttonWidth
        var opacity = (numberOfOuterCircles > 4) ? 0.40 : 0.20
        
        for _ in 0..<numberOfOuterCircles{
            circleWidth += 30
            self.circleArray.append(CircleData(width: circleWidth, opacity: opacity))
            opacity -= 0.05
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                NavigationLink(destination: ResultView(PlayResult: PlayResult, GoalSecond: GoalSecond, TimeLimit: SelectedTimeLimit), isActive: $Showshould_ResultView){
                    EmptyView()
                }
                NavigationLink(destination: PauseView(), isActive: $Showshould_PauseView){
                    EmptyView()
                }
                Image("Tatami").resizable()
                VStack{
                    if PlayResult == "Over"{
                        Image("Exclamation").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(Color.red).padding()
                    }
                    Image("Daruma").resizable().scaledToFit().frame(width: 160, height: 160).rotationEffect(DarumaState ? .degrees(0) : .degrees(180))
                    Spacer()
                    if TimeLimit != -1 {
                        Text("\(TimeLimit)").font(Font.custom("ChalkboardSE-Bold", size: 50)).foregroundColor(Color.black).padding()
                    }
                    HStack{
                        if !DarumaState{
                            Text("Darumasan").font(Font.custom("ChalkboardSE-Bold", size: 60)).foregroundColor(Color.red)
                            Text(" ga").font(Font.custom("ChalkboardSE-Bold", size: 60)).foregroundColor(Color.black)
                        } else{
                            Text("koronda").font(Font.custom("ChalkboardSE-Bold", size: 80)).foregroundColor(Color.black)
                        }
                    }
                    Spacer()
                }
                VStack{
                    Spacer()
                    if !TouchJudgement{
                        Image("Human").resizable().scaledToFit().frame(width: HumanImage.width, height: HumanImage.height)
                            .position(HumanPlace)
                    } else {
                        Image("TouchHuman").resizable().scaledToFit().frame(width: HumanImage.width, height: HumanImage.height)
                            .position(HumanPlace)
                    }
                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        HStack{
                            ZStack{
                                ZStack {
                                    Group {
                                        ForEach(circleArray, id: \.self) { cirlce in
                                            Circle()
                                                .fill(self.color)
                                                .opacity(self.isAnimating && !DarumaState ? cirlce.opacity : 0)
                                                .frame(width: cirlce.width, height: cirlce.width, alignment: .center)
                                                .scaleEffect(self.isAnimating && !DarumaState ? 1 : 0)
                                        }
                                        
                                    }
                                    .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
                                               value: self.isAnimating)
                                    
                                    Button(action: {
                                        if DarumaState {
                                            if WithOrWithoutCooldown && CoolDown {
                                                PlayResult = "Over"
                                                FindingsSound.play()
                                                TimerStop()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    Showshould_ResultView = true
                                                }
                                            } else if WithOrWithoutCooldown {
                                                CoolDown = true
                                            } else {
                                                PlayResult = "Over"
                                                FindingsSound.play()
                                                TimerStop()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    Showshould_ResultView = true
                                                }
                                            }
                                        } else if DarumaPlace.y + 210 >= HumanPlace.y {
                                            HumanImage.width = 120
                                            HumanImage.height = 120
                                            TouchJudgement = true
                                            Darumatouchanimationtimer()
                                        } else {
                                            HumanPlace.y -= 25
                                        }
                                    }) {
                                        Image(systemName: "arrowshape.up.fill").frame(width: self.buttonWidth, height: self.buttonWidth, alignment: .center).background(Color.red).foregroundColor(Color.white).accentColor(color).cornerRadius(50)
                                        
                                    }
                                    .onAppear(perform: {
                                        self.isAnimating.toggle()
                                    })
                                }
                            }
                            Button(action: {
                                Showshould_PauseView = true
                            }){
                                Image(systemName: "pause").frame(width: 80, height: 80).background(Color.red).foregroundColor(Color.white).cornerRadius(50).shadow(radius: 10)
                            }
                        }.padding()
                        Rectangle().frame(width: 30, height: 1).foregroundColor(.clear)
                    }
                }
                if ReadyTimer != nil{
                    //Ready View
                    ReadyView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear{
                if !PlayDetection {
                    HumanPlace.x = geometry.size.width / 2
                    HumanPlace.y = geometry.size.height - 200
                    DarumaPlace.x = geometry.size.width / 2
                    PlayDetection = true
                    readyTimer()
                }
                PlayResult = ""
                SelectedTimeLimit = TimeLimit
            }
            .onDisappear{
                TimerStop()
            }
        }
    }
    //Ready Timer
    private func readyTimer(){
        var count: Int = 0
        ReadyTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if count == 57{
                ReadyTimer?.invalidate()
                ReadyTimer = nil
                mainTimer()
            }
            count += 1
        }
    }
    
    // Timer to manage Daruma, players and time limits
    private func mainTimer() {
        MainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if TimeLimit == 0{
                PlayResult = "TimeOver"
                TimerStop()
                Showshould_ResultView = true
            }
            if TimeLimit != -1{
                TimeLimit -= 1
                GoalSecond += 1
            }
            if FuncState{
                FuncState = false
                DarumaLookBackTimer { result in
                    if result{
                        FuncState = true
                    }
                }
            }
        }
    }
    // Animation of touching Daruma
    private func Darumatouchanimationtimer() {
        DarumaTouchAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            count -= 1
            if count == 0{
                PlayResult = "Clear"
                TimerStop()
                Showshould_ResultView = true
            }
        }
    }
    // Make Daruma face a random number of seconds.
    private func DarumaLookBackTimer(completion: @escaping (Bool) -> Void)  {
        let lookbackcount = Int.random(in: Int(0.5)..<5)
        
        DarumaLookBacktimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(lookbackcount), repeats: true) { _ in
            if DarumaState {
                if WithOrWithoutCooldown{
                    CoolDown = false
                }
                DarumaState = false
            } else {
                DarumaState = true
                WadaikoSound.play()
            }
            completion(true)
            DarumaLookBacktimer?.invalidate()
        }
    }
    // Stop all timers
    private func TimerStop(){
        MainTimer?.invalidate()
        DarumaLookBacktimer?.invalidate()
        DarumaTouchAnimationTimer?.invalidate()
    }
}

class WadaikoSoundClass {
    private var wadaikoSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "SE-Wadaiko", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        wadaikoSound = try! AVAudioPlayer(contentsOf: soundURL)
        wadaikoSound.prepareToPlay()
    }
    
    func play() {
        wadaikoSound.play()
    }
}

class FindingsSoundClass {
    private var findingsSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "SE-Findings", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        findingsSound = try! AVAudioPlayer(contentsOf: soundURL)
        findingsSound.prepareToPlay()
    }
    
    func play() {
        findingsSound.play()
    }
}

struct CircleData: Hashable {
    let width: CGFloat
    let opacity: Double
}
