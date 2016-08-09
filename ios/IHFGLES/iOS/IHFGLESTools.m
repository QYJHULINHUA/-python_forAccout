//
//  IHFGLESTools.m
//  Simple_Texture2D
//
//  Created by v.q on 15/12/16.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "IHFGLESTools.h"
CGFloat kImpossibleValue = -32767.0;

@implementation IHFGLESTools

+ (short *)getImageDataFromRAW:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"raw"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    short *temp0 = (short *)[data bytes];
    return temp0;
}

+ (unsigned char *)getUbyteImageData:(UIImage *)img{
    CGImageRef imgA = img.CGImage;
    CGDataProviderRef inProviderA = CGImageGetDataProvider(imgA);
    CFDataRef inBitmapDataA = CGDataProviderCopyData(inProviderA);
    NSData * dataA = [[NSData alloc] initWithData:(__bridge_transfer NSData *)inBitmapDataA];
    return (unsigned char *)[dataA bytes];
}

+ (unsigned short *)getUShortImageData:(UIImage *)img{
    CGImageRef imgA = img.CGImage;
    CGDataProviderRef inProviderA = CGImageGetDataProvider(imgA);
    CFDataRef inBitmapDataA = CGDataProviderCopyData(inProviderA);
    NSData * dataA = [[NSData alloc] initWithData:(__bridge_transfer NSData *)inBitmapDataA];
    return (unsigned short *)[dataA bytes];
}

+ (short *)getNewImageData:(UIImage *)img
{    
    CGImageRef imgA = img.CGImage;
    CGDataProviderRef inProviderA = CGImageGetDataProvider(imgA);
    CFDataRef inBitmapDataA = CGDataProviderCopyData(inProviderA);
    NSData * dataA = [[NSData alloc] initWithData:(__bridge_transfer NSData *)inBitmapDataA];
    
    NSInteger lengtA = dataA.length / 2;
    NSInteger lengB = img.size.width * img.size.height;
    if (lengB != lengtA) {
        
        return nil;
    }
    short *imageInt = (short *)[dataA bytes];
    return imageInt;
}

+ (unsigned short *)getUnsignNewImageData:(UIImage *)img
{
    CGImageRef imgA = img.CGImage;
    CGDataProviderRef inProviderA = CGImageGetDataProvider(imgA);
    CFDataRef inBitmapDataA = CGDataProviderCopyData(inProviderA);
    NSData * dataA = [[NSData alloc] initWithData:(__bridge_transfer NSData *)inBitmapDataA];
    unsigned short *imageInt = (unsigned short *)[dataA bytes];
    return imageInt;
}

+ (void)getFloatData:(float *)dataB FromImage:(UIImage *)img withWidth:(int)width andHeight:(int)heigth
{
    short *imageShort = [IHFGLESTools getNewImageData:img];
    if (imageShort == nil) {
        return;
    }

    for (int i = 0 ; i < width*heigth ; i++)
    {
        dataB[i] = (float)imageShort[i];
    }
}

+ (void)getUnsignFloatData:(float *)dataB FromImage:(UIImage *)img Width:(int)width Height:(int)height
{
    unsigned short *imageShort = [IHFGLESTools getUnsignNewImageData:img];
    for (int i = 0 ; i < width*height ; i++)
    {
        dataB[i] = (float)imageShort[i];
    }
}


+ (void)getFloatData:(nullable float *)dataB fromUnsignedImage:(nonnull UIImage *)img withWidth:(int)width andHeight:(int)heigth{
    unsigned short *imageUShort = [IHFGLESTools getUShortImageData:img];
    for (int i = 0 ; i < width * heigth ; i++)
    {
        dataB[i] = (float)imageUShort[i];
    }
}

+ (float)getPixelFromImage:(UIImage *)img byIndex:(MyIndex)aIndex
{
    int width = img.size.width;
    int height = img.size.height;
    int index = (int) (aIndex.indexY*width+aIndex.indexX);
    if (index > (width * height)) {
        return -1;
    }
    
    float *temp0 = (float *)malloc(sizeof(float)*width*height);
    [IHFGLESTools getFloatData:temp0 FromImage:img withWidth:width andHeight:height];
    
    float pixel = temp0[index];
    free(temp0);
    temp0 = NULL;
    return pixel;
}

+ (MyIndex)calculateRealPoisitionOfPoint:(CGPoint)point byUserData:(UserData *)data andImageSize:(CGSize)size
{
    MyIndex index;
    float *result;
    
    int width = size.width;
    int height = size.height;
    float x = point.x;
    float y = point.y;
    result = (float *)malloc(sizeof(float)*16);
    for (int i = 0; i<4; i++)
    {
        for (int j = 0; j<4; j++)
        {
            result[i*4+j] = data->mvpMat.m[i][j];
        }
    }
    
    MatrixInverse(result, 4);
    
    // 初始化不能偷懒啊 -- hulinhua
    BOOL needFixForRotation = NO;
    // 这个矩阵在旋转状态下变换的时候偏移总是反的
    // 暂时搞不清楚, 先打个补丁解决 -- songliang
    
    if(data->rotateAngle % 180 != 0) {
        needFixForRotation = YES;
    }
    
    float newX = result[0]*x + result[4]*y + (needFixForRotation ? -result[12]: result[12]);
    float newY = result[1]*x + result[5]*y + (needFixForRotation ? result[13]: -result[13]);
    
    int indexX = (newX+1)/2*width;
    int indexY = height*(1-newY)/2;
    if(needFixForRotation) {
        indexX = width - indexX;
        indexY = width - indexY;
    }
    
    if (indexX < 0)     indexX = 0;
    if (indexX > width) indexX = width;
    if (indexY < 0)     indexY = 0;
    if (indexY > height)indexY = height;
    
    index.indexX = indexX;
    index.indexY = indexY;
    
    free(result);
    return index;
}

+ (CGPoint)calculateViewPointWithRealPoint:(CGPoint)point byUserData:(UserData *)data andImageSize:(CGSize)size
{
    float *result;
    
    float x = point.x;
    float y = point.y;
    result = (float *)malloc(sizeof(float)*16);
    for (int i = 0; i<4; i++)
    {
        for (int j = 0; j<4; j++)
        {
            result[i*4+j] = data->mvpMat.m[i][j];
        }
    }
    MatrixInverse(result, 4);
    x= result[0]*x + result[4]*y + result[12];
    y = result[1]*x + result[5]*y - result[13];
    free(result);
    return CGPointMake(x, y);
}




+ (CGPoint)convertScreenCoordToESCoord:(CGPoint)sourcePoint withWidth:(NSInteger)drawableWidth andHeight:(NSInteger)drawableHeight
{
    float x = sourcePoint.x;
    float y = sourcePoint.y;
    CGPoint esPoint =
    CGPointMake(ScreenScale * 2 * x / drawableWidth - 1,
                1 - ScreenScale * 2 * y / drawableHeight);
    return esPoint;
}

/** 
 * @brief 实现对OpenGL ES渲染视图的截屏.
 *           返回截屏图片在外存路径，通过imageWithContentsOfFile:读取
 *
 * @param width 渲染视图的宽度.
 * @param  height 渲染视图的高度
 *
 * @return 生成截图写入外存的位置.
 */
+ (void)snapshotForGLKView:(int)width Height:(int)height ResultBlock:(void(^)(UIImage *))result
{
    int pixelScale = (int) [UIScreen mainScreen].scale;
    const NSInteger myDataLength = width * height * 4 * pixelScale * pixelScale;
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width * pixelScale, width * pixelScale, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < height * pixelScale; y++)
    {
        int xOffset = (height * pixelScale - 1 - y) * width * 4 * pixelScale;
        int yOffset = y * width * 4 * pixelScale;
        int zOffset= width * 4 * pixelScale;
        memcpy( buffer2 + xOffset, buffer + yOffset, zOffset );
    }
    free(buffer); // work with the flipped buffer, so get rid of the original one.
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width * pixelScale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width * pixelScale, height * pixelScale, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    if (imageRef == nil) {
        NSLog(@"create image ref failed");
        CGColorSpaceRelease(colorSpaceRef);
        CGDataProviderRelease(provider);
        free(buffer2);
    }
     CGColorSpaceRelease(colorSpaceRef);
    
    UIImage *myImage = [UIImage imageWithCGImage:imageRef scale:pixelScale orientation:UIImageOrientationUp];
    
    result(myImage);
    
    NSData *imageViewData = UIImagePNGRepresentation(myImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName = @"GLKSnapshot.png";
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageViewData writeToFile:savedImagePath atomically:YES];
    
    CGImageRelease(imageRef);
   
    CGDataProviderRelease(provider);
    free(buffer2);
}

+ (NSDictionary *)getAveragePixelValue:(UIImage *)img Index:(MyIndex)aIndex withRadius:(int)radius
{
    int width = img.size.width;
    int height = img.size.height;
    int UpBoader = aIndex.indexY + radius > height ? height :  aIndex.indexY + radius;
    int downBoader = aIndex.indexY - radius < 0 ? 0 : aIndex.indexY - radius;
    int leftBoader = aIndex.indexX - radius < 0 ? 0 : aIndex.indexX - radius;
    int rightBoader = aIndex.indexX + radius > width ? width : aIndex.indexX + radius;
    int index = 0;
    
    float *temp0 = (float *)malloc(sizeof(float) * width * height);
    [IHFGLESTools getFloatData:temp0 FromImage:img withWidth:width andHeight:height];
    float total = 0.0; int count = 0;
    
    // **** 越界 **  //
    
    CGFloat maxCT = temp0[leftBoader * width + downBoader];
    
    CGFloat minCT = maxCT;
    
    for (int i = leftBoader; i < rightBoader; i++) {
        for (int j = downBoader; j < UpBoader; j++) {
            ++count;
            index = j * width + i;
            total += temp0[index];
            
            maxCT = MAX(temp0[index], maxCT);
            minCT = MIN(temp0[index], minCT);
        }
    }
    free(temp0);
    temp0 = NULL;
    return @{@"maxCT":@(maxCT),@"minCT":@(minCT),@"averageCT":@(total/(float)count)};
}

+ (NSDictionary *)GLESCalculateArrayCTValue:(NSArray *)pointArray FromImage:(UIImage *)img{
    int width = img.size.width;
    int height = img.size.height;
    int index = 0;
    float *temp0 = (float *)malloc(sizeof(float) * width * height);
    [IHFGLESTools getFloatData:temp0 FromImage:img withWidth:width andHeight:height];
    float total = 0.0;
    int maxPixel = 0; int minPixel = 0;
    float averagePixel = 0;
    CGPoint tmpPoint = CGPointFromString(pointArray[0]);
    int x = tmpPoint.x; int y = tmpPoint.y;
    index = y * width + x;
    minPixel = temp0[index];
    maxPixel = temp0[index];
    total = temp0[index];
    for (int i = 1 ; i < pointArray.count ; i++) {
        tmpPoint = CGPointFromString(pointArray[i]);
        x = tmpPoint.x;
        y = tmpPoint.y;
        index = y * width + x;
        int pixel = temp0[index];
        minPixel = MIN(pixel, minPixel);
        maxPixel = MAX(pixel, maxPixel);
        total += pixel;
    }
    free(temp0);
    temp0 = NULL;
    averagePixel = total / pointArray.count;
    return @{@"maxCT":@(maxPixel),@"minCT":@(minPixel),@"averageCT":@(averagePixel)};
}

+ (NSArray *)GLESGetRealPointArray:(NSArray *)viewPointArray GLKVC:(IHFMyGLKViewController *)glkVC
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(int i = 0 ; i < viewPointArray.count ; i ++)
    {
        CGPoint viewPoint = CGPointFromString(viewPointArray[i]);
        
        CGPoint realViewPoint = [glkVC MYGLKRealPointWithViewPoint:viewPoint];
        
        [tempArray addObject:NSStringFromCGPoint(realViewPoint)];
    }
    return tempArray;
}

+ (NSArray *)GLESGetViewPointArray:(NSArray *)realPointArray GLKVC:(IHFMyGLKViewController *)glkVC
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for(int i = 0 ; i < realPointArray.count ; i ++)
    {
        CGPoint realViewPoint = CGPointFromString(realPointArray[i]);
        
        CGPoint viewPoint = [glkVC MYGLKViewPointWithRealPoint:realViewPoint];
        
        [tempArray addObject:NSStringFromCGPoint(viewPoint)];
    }
    return tempArray;
}



@end
