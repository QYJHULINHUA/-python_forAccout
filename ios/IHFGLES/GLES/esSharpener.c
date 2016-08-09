//
//  esSharpener.c
//  Simple_Texture2D
//
//  Created by 齐建琼 on 15/12/2.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#include "esSharpener.h"
#include "esUtil.h"
#include <math.h>


void makeGauss(double sigma,float **pdKernel, int gauWidth, int gauHeight)
{
    int x ,y;
    int centerX = gauWidth/2;
    int centerY = gauWidth/2;
    double dValue, dSum = 0;
    
    for(x = 0;x < gauWidth;x++)
    {
        for (y = 0; y < gauHeight ; y++) {
            
            dValue =
            exp(-((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY))/ (2.0 *sigma*sigma)) / (2.0 * PI * sigma *sigma);
            
            pdKernel[x][y] = dValue ;
            
            dSum += dValue;
        }
    }
    // 归一化
    for (x = 0; x < gauWidth; x++) {
        for (y = 0; y < gauHeight ; y++) {
            pdKernel [x][y] /= dSum;
        }
    }
}

void make1DGauss(double sigma, float *pdKernel, int gauWidth)
{
    int x;
    int center = gauWidth/2;
    double dValue,dSum = 0.0;
    for (x = 0; x < gauWidth ; x++)
    {
        dValue = exp(-((x - center)*(x - center)/(2*sigma*sigma)))/(sqrt(2*PI)*sigma);
        pdKernel[x]= dValue;
        dSum += dValue;
    }
    for (x = 0; x < gauWidth; x++) {
        pdKernel[x] /= dSum;
    }
}

float GaussianEquation(float val, float sigma)
{
    double coefficient = 1.0/(sqrt(2.0*PI)*sigma);
    double exponent    = -(val*val)/(2.0*sigma);
    return (float) (coefficient*exp(exponent));
}