#include <iostream>
using namespace std;
#define N 3
#define K 3
#define S 2
#define P 2
#define Output_Size (N - K + 2 * P)/S + 1 // 计算输出数组大小
#define Padding_Size (N + 2 * P)          // 计算padding后的数组大小

//打印数组(调试用)
void PrintArray(int *In_Array, int size){
    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            cout << In_Array[i * size + j] << " ";
        }
        cout << endl;
    }
}

//一维数组转二维数组（N和K都用转）
template <int SIZE>
void Dimension(int In_Array[], int size, int out_array[][SIZE]){
    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            out_array[i][j] = In_Array[i * size + j];
        }
    }
}

//padding
void Padding(int In_Array[][N], int Input_2d_padding[][Padding_Size]){
    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            Input_2d_padding[i + P][j + P] = In_Array[i][j];
        }
    }
}

// 滑窗并卷积
void Slide4Conv(int Input_2d_padding[][Padding_Size], int Kernel_2d[][K], int Output_Conv[][Output_Size]){
    for(int i = 0; i < Output_Size; i++){
        for(int j = 0; j < Output_Size; j++){
            int accumulation = 0;
            for(int ki = 0; ki < K; ki++){
                for(int kj = 0; kj < K; kj++){
                    accumulation += Input_2d_padding[i*S + ki][j*S + kj] * Kernel_2d[ki][kj];
                }
            }
            // Store the result in the output array
            Output_Conv[i][j] = accumulation;
        }
    }
}

int main(){
    int Input[N*N]  = {1, 2, 3, 
                       4, 5, 6, 
                       7, 8, 9};
    int Kernel[K*K] = {1, 0, 0, 
                       0, 1, 0, 
                       0, 0, 1};

    int Input_2d[N][N] = {}; //一维数组变二维(方便计算)
    int Kernel_2d[K][K] = {};
    int Input_2d_padding[Padding_Size][Padding_Size] = {};
    int Output_Conv[Output_Size][Output_Size] = {}; // 定义输出数组大小

    Dimension<N>(Input, N, Input_2d); //Input[9] -> input[3][3]
    Dimension<K>(Kernel, K, Kernel_2d); //Kernel[9] -> Kernel[3][3]

    Padding(Input_2d, Input_2d_padding); //Input_2d数组padding

    Slide4Conv(Input_2d_padding, Kernel_2d, Output_Conv);//滑窗Kernel在Input_2d_padding上以步长为P从左到右,从上到下滑动,并计算卷积结果
    
    PrintArray(&Output_Conv[0][0], Output_Size); //打印输出数组
}



