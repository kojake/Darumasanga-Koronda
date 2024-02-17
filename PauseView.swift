import SwiftUI

struct PauseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var Showshould_ContentView = false
    
    var body: some View {
        ZStack{
            Image("Tatami2").resizable()
            VStack{
                Text("🫷 Pause 🫸").font(Font.custom("ChalkboardSE-Bold", size: 60)).foregroundColor(Color.black)
                Button(action: {
                    dismiss()
                }){
                    HStack{
                        Image(systemName: "play.fill").resizable().scaledToFit().frame(width: 50, height: 50)
                        Text("Continue").font(Font.custom("ChalkboardSE-Bold", size: 35)).fontWeight(.black)
                    }.frame(width: 300, height: 100).background(Color.blue).foregroundColor(Color.white).cornerRadius(20).shadow(radius: 10)
                }.padding()
                Button(action: {
                    Showshould_ContentView = true
                }){
                    HStack{
                        Image(systemName: "xmark").resizable().scaledToFit().frame(width: 50, height: 50)
                        Text("Quit").font(Font.custom("ChalkboardSE-Bold", size: 35)).fontWeight(.black)
                    }.frame(width: 300, height: 100).background(Color.red).foregroundColor(Color.white).cornerRadius(20).shadow(radius: 10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $Showshould_ContentView, content: {
                ContentView()
            })
        }
    }
}

#Preview {
    PauseView()
}
