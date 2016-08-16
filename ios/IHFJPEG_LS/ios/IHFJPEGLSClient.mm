//
//  IHFJPEGLSClient.m
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/13.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHFJPEGLSClient.h"
#include "interface.h"

@implementation IHFJPEGLSClient

void ProviderReleaseData(void *info,const void *data, size_t size)
{
    if (data) {
        free((void*)data);
    }
}

+ (UIImage *)getImageFormJPEGLSData:(NSData *)data
{
    struct JlsParameters info;
    JpegLsReadHeader([data bytes], [data length], &info);
    
    BYTE* uncompressedData = (BYTE*)malloc(info.width * info.height * info.bitspersample / 8 * info.components);
    
    enum JLS_ERROR error = JpegLsDecode(uncompressedData, info.width * info.height * info.bitspersample / 2, [data bytes], [data length], &info);
    if (error != OK) {
        NSLog(@"JPEG_LE 解压失败");
    }
    
    
    CGDataProviderRef dataProviderRef =  CGDataProviderCreateWithData(NULL, uncompressedData, info.width * info.height * info.bitspersample / 8 * info.components, ProviderReleaseData);
    CGImageRef l_CGImageRef;
    
    if (info.components == 1) {
        l_CGImageRef = CGImageCreate( info.width, info.height, info.bitspersample, info.bitspersample, info.bytesperline,
                                     CGColorSpaceCreateDeviceGray(), kCGBitmapByteOrder16Big, dataProviderRef, NULL, false, kCGRenderingIntentDefault );
    }else
    {
        
        l_CGImageRef = CGImageCreate( info.width, info.height, info.bitspersample, info.bitspersample * info.components, info.bytesperline,
                                     CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault, dataProviderRef, NULL, false, kCGRenderingIntentDefault );
        
    }
    if (dataProviderRef) {
        CGDataProviderRelease(dataProviderRef);
    }
    
    
    UIImage* rawImage = [UIImage imageWithCGImage:l_CGImageRef];
    CGImageRelease(l_CGImageRef);
    return rawImage;
}

@end
