import SwiftUI
struct Square_mn: View {
    @Binding var m:Int
    @Binding var n:Int
    @State private var board:[[Int]]=Array(repeating: Array(repeating: 0, count: 11), count: 11)//0=邊界或無效的格子
    @State private var xmove:[[Int]]=Array(repeating: Array(repeating: 0, count: 11), count: 11)
    @State private var ymove:[[Int]]=Array(repeating: Array(repeating: 0, count: 11), count: 11)
    @State private var xoffset:Int=0
    @State private var yoffset:Int=0
    /*init(m:Binding<Int>,n:Binding<Int>){
        
    }*/
    /*init(m:Binding<Int>,n:Binding<Int>){
        self._m=m
        self._n=n
        board=Array(repeating: Array(repeating: 0, count: n), count: _m)
    }*/
    var body: some View {
        VStack(spacing:0){
            Text("level 1").onAppear{
                board=Array(repeating: Array(repeating: 0, count: n+2), count: m+2)
                for i in(1..<m+1){
                    for j in(1..<n+1){
                        board[i][j]=Int.random(in: (1..<5))
                    }
                }
            }
            ForEach (1..<m+1){
                i in
                HStack(spacing:0){
                    ForEach(1..<n+1){
                        j in
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray).frame(width: 50, height: 50)
                                .gesture(
                                    DragGesture()
                                        .onChanged({value in
                                            xoffset += Int(value.translation.width)
                                            yoffset += Int(value.translation.height)
                                        })
                                        .onEnded({value in 
                                            if abs(xoffset)>abs(yoffset){
                                                if xoffset>0 && board[i][j+1] != 0{
                                                    //(board[i][j],board[i][j+1])=(board[i][j+1],board[i][j])
                                                    xmove[i][j] += 50
                                                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                        t in
                                                        xmove[i][j] -= 50
                                                    }
                                                    
                                                }
                                                else if board[i][j-1] != 0{
                                                    //(board[i][j],board[i][j-1])=(board[i][j-1],board[i][j])
                                                    xmove[i][j] -= 50
                                                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                        t in
                                                        xmove[i][j] += 50
                                                    }
                                                }
                                            }
                                            else{
                                                if yoffset>0{
                                                    //(board[i][j],board[i+1][j])=(board[i+1][j],board[i][j])
                                                    ymove[i][j] += 50
                                                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                        t in
                                                        ymove[i][j] -= 50
                                                    }
                                                }
                                                else if board[i-1][j] != 0{
                                                    //(board[i][j],board[i-1][j])=(board[i-1][j],board[i][j])
                                                    ymove[i][j] -= 50
                                                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                        t in
                                                        ymove[i][j] += 50
                                                    }
                                                }
                                            }
                                            xoffset = 0
                                            yoffset = 0
                                        })
                                ).zIndex(0)
                        
                                Text("\(board[i][j])")
                                            .offset(x:CGFloat(xmove[i][j]),y:CGFloat(ymove[i][j]))
                                            .animation(.easeIn,value:CGFloat(xmove[i][j]))
                            //.animation(.easeIn,value:CGFloat(ymove[i][j]))
                                            
                        }
                    }
                }
            }
        }
    }
}
