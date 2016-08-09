//
//  esSharpener.h
//  Simple_Texture2D
//
//  Created by 齐建琼 on 15/12/2.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#ifndef esSharpener_h
#define esSharpener_h

#include <stdio.h>

#endif /* esSharpener_h */

/***************
 *\函数名                 - 生成高斯核
 *\输入参数:
 * double sigma          - 高斯函数标准差
 * double **pdfKernel    - 指向高斯数据数组的指针
 * int *pnWindowSize     - 高斯数据长度
 *
 *\返回值                 - 无
 ***************
 */
void makeGauss(double sigma, float **pdKernel, int gauWidth, int gauHeight);

void make1DGauss(double sigma, float *pdKernel, int gauWidth);

float GaussianEquation(float val, float sigma);
