//
//  GLES_ImageData.h
//  IHFMedicImage2.0
//
//  Created by Yoser on 2/19/16.
//  Copyright © 2016 Hanrovey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GLES_ImageData : NSObject


@property (strong, nonatomic) UIImage *imageData;

@property (assign, nonatomic)BOOL isRGB;

@property (assign, nonatomic)BOOL is16F;

@property (assign, nonatomic) BOOL isUnsigned;

@property (assign, nonatomic) NSInteger passway;///通道数

@property (assign, nonatomic) NSInteger bitsPerComponent; ///图片位数

@property (assign, nonatomic) CGSize size;

@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGFloat width;

@property (nonatomic)float w_w;
@property (nonatomic)float w_l;


/**!
 
 @param data_info:  data_info[0] == imageData, data_info[1] == image attribute
 
 @return GLES_ImageData instancetype
 
 @param image attribute == @"RGB/16F/UNSingle/tongdao/bitconpenmt"
 
 */
+ (instancetype)GLESWihtImageDataInfo:(NSArray*)data_info;

//+ (instancetype)GLESWithImage:(UIImage *)image Isunsigned:(BOOL)isUnsigned;

@end
