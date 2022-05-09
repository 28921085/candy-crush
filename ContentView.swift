import SwiftUI

struct ContentView: View {
    @State private var m:Int=9
    @State private var n:Int=9
    @State private var level:Int=0
    @State private var customBoard:[[Int]]=Array(repeating: Array(repeating: 0, count: 15), count: 15)
    func reset(){
        for i in(0..<15){
            for j in(0..<15){
                customBoard[i][j]=0
            }
        }
        for i in(1..<m+2){
            for j in(1..<n+2){
                customBoard[i][j]=1
            }
        }
        /*for i in(0..<15){//disable outside
            customBoard[0][i]=0
            customBoard[14][i]=0
            customBoard[i][0]=0
            customBoard[i][14]=0
        }*/
    }
    var body: some View {
        if level == 0{
            VStack{
                ForEach(0..<2){i in
                    HStack{
                        ForEach(0..<5){j in
                            Button{
                                level=i*5+j+1
                                switch level{
                                case 1:
                                    reset()
                                    m=9
                                    n=9
                                case 2:
                                    reset()
                                    m=10
                                    n=10
                                    for i in(0..<4){
                                        for j in(0..<4){
                                            customBoard[i+4][j+4]=0
                                        }
                                    }
                                default:
                                    Text("Error")
                                }
                            }label:{
                                Text("\(i*5+j+1)")
                            }
                        }
                    }
                }
            }
        }
        else{
            Square_mn(m:$m,n:$n,board: $customBoard)
        }
    }
}
