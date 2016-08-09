//
//  GLES_ImageData.m
//  IHFMedicImage2.0
//
//  Created by Yoser on 2/19/16.
//  Copyright © 2016 Hanrovey. All rights reserved.
//

#import "GLES_ImageData.h"

@implementation GLES_ImageData

+ (instancetype)GLESWihtImageDataInfo:(NSArray*)data_info
{
    if (data_info&&data_info.count == 2) {
        
        if ([data_info[0] isKindOfClass:[UIImage class]] && [data_info[1] isKindOfClass:[NSDictionary class]]) {
            GLES_ImageData *GLESImg = [[GLES_ImageData alloc] init];
            GLESImg.imageData = data_info[0];
            NSDictionary *infoDic = data_info[1];
            NSArray *aArray = [infoDic[@"alternate"] componentsSeparatedByString:@"//"];
            if (aArray.count  <= 7) {
                if ([aArray[0] isEqualToString:@"Y"]) {
                    GLESImg.isRGB = YES;
                }else GLESImg.isRGB = NO;
                
                if ([aArray[1] isEqualToString:@"Y"]) {
                    GLESImg.is16F = YES;
                }else GLESImg.is16F = NO;
                
                if ([aArray[2] isEqualToString:@"Y"]) {
                    GLESImg.isUnsigned = YES;
                }else GLESImg.isUnsigned = NO;
                
                NSString *tt = aArray[3];
                GLESImg.passway = tt.integerValue;
                tt = aArray[4];
                GLESImg.bitsPerComponent = tt.integerValue;
                if (aArray.count == 7) {
                    tt = aArray[5];
                    GLESImg.w_l = tt.floatValue;
                    tt = aArray[6];
                    GLESImg.w_w = tt.floatValue;
                }
                
                
                
                GLESImg.size = GLESImg.imageData.size;
                GLESImg.width = GLESImg.imageData.size.width;
                GLESImg.height = GLESImg.imageData.size.height;
                
                
                return GLESImg;
            }else
            {
                NSLog(@"GLES_ImageData inpu imageinfo is error format");
                return nil;
            }
            
            
            
        }else
        {
            NSLog(@"GLES_ImageData inpu image is null");
            return nil;
        }
        
    }else
    {
        NSLog(@"GLES_ImageData inpuData Format ERROR");
        return nil;
    }
}

@end
