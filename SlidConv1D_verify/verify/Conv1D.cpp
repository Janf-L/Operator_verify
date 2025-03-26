#include <iostream>
using namespace std;

// 定义输入矩阵高、宽
#define H 3
#define W 3
// 定义卷积核高、宽
#define K_H 3
#define K_W 3
// 步幅
#define S 2
// 填充大小
#define P 2

// 计算输出数组大小
#define Output_Size_H ((H - K_W + 2 * P)/S + 1)
#define Output_Size_W ((W - K_H + 2 * P)/S + 1)

// 计算填充后数组大小
#define Padding_Size_H (H + 2 * P)
#define Padding_Size_W (W + 2 * P)

// 打印数组
void PrintArray(int *In_Array, int size_h, int size_w){
    for(int i = 0; i < size_h; i++){
        for(int j = 0; j < size_w; j++){
            cout << In_Array[i * size_w + j] << " ";
        }
        cout << endl;
    }
}

// 一维数组形式的填充操作
void Padding1D(int Input[], int Padded[]) {
    // 将填充后数组初始化为0
    for (int i = 0; i < Padding_Size_H * Padding_Size_W; i++) {
        Padded[i] = 0;
    }
    
    // 将原始数据拷贝到填充后的数组中
    for (int i = 0; i < H; i++) {
        for (int j = 0; j < W; j++) {
            int srcIdx = i * W + j; 
            int dstIdx = (i + P) * Padding_Size_W + (j + P);
            Padded[dstIdx] = Input[srcIdx];
        }
    }
}

// 一维数组形式的卷积操作
void Conv1D(int Padded[], int Kernel[], int Output[]) {
    for (int i = 0; i < Output_Size_H; i++) {
        for (int j = 0; j < Output_Size_W; j++) {
            int accumulation = 0;
            // 累加卷积结果
            for (int ki = 0; ki < K_H; ki++) {
                for (int kj = 0; kj < K_W; kj++) {
                    int paddedIdx = (i * S + ki) * Padding_Size_W + (j * S + kj);
                    int kernelIdx = ki * K_W + kj;
                    accumulation += Padded[paddedIdx] * Kernel[kernelIdx];
                }
            }
            // 将结果存储到输出数组
            Output[i * Output_Size_W + j] = accumulation;
        }
    }
}

int main(){
    // 输入数组
    int Input[H*W]  = {
        1, 2, 3,
        4, 5, 6, 
        7, 8, 9};
    // 卷积核
    int Kernel[K_H*K_W] = {
        1, 0, 0,
        0, 1, 0, 
        0, 0, 1};

    // 存储填充数据和输出结果
    int Padded[Padding_Size_H * Padding_Size_W] = {};
    int Output[Output_Size_H * Output_Size_W] = {};
    
    // 填充
    Padding1D(Input, Padded);
    // 卷积
    Conv1D(Padded, Kernel, Output);
    
    // 打印输出结果
    PrintArray(Output, Output_Size_H, Output_Size_W);

    return 0;
}