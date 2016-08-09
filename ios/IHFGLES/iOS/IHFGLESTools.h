//
//  IHFGLESTools.h
//  Simple_Texture2D
//
//  Created by v.q on 15/12/16.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "esCreateTexture.h"
#import "IHFMyGLKViewController.h"
//@class IHFMyGLKViewController;

#define ScreenScale [UIScreen mainScreen].scale

typedef struct {
    int indexX;
    int indexY;
}MyIndex;

extern CGFloat kImpossibleValue;


@interface IHFGLESTools : NSObject

+ (nullable short *)getImageDataFromRAW:(nullable NSString *)fileName;

+ (void)getFloatData:(nullable float *)dataB FromImage:(nonnull UIImage *)img withWidth:(int)width andHeight:(int)heigth;

+ (void)getUnsignFloatData:(nullable float *)dataB FromImage:(nonnull UIImage *)img Width:(int)width Height:(int)height;

+ (void)getFloatData:(nullable float *)dataB fromUnsignedImage:(nonnull UIImage *)img withWidth:(int)width andHeight:(int)heigth;

+ (nullable short *)getNewImageData:(nonnull UIImage *)img;

+ (float)getPixelFromImage:(nonnull UIImage *)img byIndex:(MyIndex)aIndex;

+ (MyIndex)calculateRealPoisitionOfPoint:(CGPoint)point byUserData:(nonnull UserData *)data andImageSize:(CGSize)size;

+ (CGPoint)convertScreenCoordToESCoord:(CGPoint)sourcePoint withWidth:(NSInteger)drawableWidth andHeight:(NSInteger)drawableHeight;

+ (nullable NSDictionary *)getAveragePixelValue:(nonnull UIImage *)img Index:(MyIndex)aIndex withRadius:(int)radius;

+ (nullable NSDictionary *)GLESCalculateArrayCTValue:(nonnull NSArray *)pointArray FromImage:(nonnull UIImage *)img;

+ (nullable NSArray *)GLESGetViewPointArray:(nullable NSArray *)realPointArray GLKVC:(nullable IHFMyGLKViewController *)glkVC;

+ (nullable NSArray *)GLESGetRealPointArray:(nullable NSArray *)viewPointArray GLKVC:(nullable IHFMyGLKViewController *)glkVC;

/**
 *  将图像转化为unsigned char数组，返回该数组的首地址
 *
 *  @param img png图片
 *
 *  @return 指向一个unsigned char类型数组的指针
 */
+ (nullable unsigned char *)getUbyteImageData:( UIImage * _Nonnull )img;

@end
