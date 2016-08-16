//
//  IHFMCommonTools.m
//  IHFMedicImage
//
//  Created by ihefe－hulinhua on 15/6/18.
//  Copyright (c) 2015年 ihefe－hlh. All rights reserved.
//

/**!
 @auto hulinhua 15/6/18
 @param #import <zlib.h> 这个需要添加libz.dylib动态库
 */
#import <zlib.h>
#import "IHFMCommonTools.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation IHFMCommonTools

+(NSString *)requestRandom
{
    NSString *random=[NSString stringWithFormat:@"%d",[IHFMCommonTools randomFrom:0 to:99999999] ];
    return random;//+1,result is [from to]; else is [from, to)!!!!!!!
}


+(int)randomFrom:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));//+1,result is [from to]; else is [from, to)!!!!!!!
}


+(NSString *)stringIsNUllToId:(id)element
{
    if (element == [NSNull null]) {
        return @"";
    }else if (element == nil)
        return @"";
    else{
        return [NSString stringWithFormat:@"%@",element];
    }
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - 获得当前时间
+ (NSString *)getCurrentDateAndTimeString
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateStr = [format stringFromDate:currentDate];
    
    return dateStr;
}


+ ( NSData *)decompressData:( NSData *)compressedData
{
    
    z_stream zStream;
    
    zStream. zalloc = Z_NULL ;
    
    zStream. zfree = Z_NULL ;
    
    zStream. opaque = Z_NULL ;
    
    zStream. avail_in = 0 ;
    
    zStream. next_in = 0 ;
    
    int status = inflateInit2 (&zStream, ( 15 + 32 ));
    
    
    if (status != Z_OK ) {
        
        return nil ;
        
    }
    
    
    Bytef *bytes = ( Bytef *)[compressedData bytes ];
    
    NSUInteger length = [compressedData length ];
    
    
    NSUInteger halfLength = length/ 2 ;
    
    NSMutableData *uncompressedData = [ NSMutableData dataWithLength :length+halfLength];
    
    
    zStream. next_in = bytes;
    
    zStream. avail_in = ( unsigned int )length;
    
    zStream. avail_out = 0 ;
    
    
    NSInteger bytesProcessedAlready = zStream. total_out ;
    
    while (zStream. avail_in != 0 ) {
        
        
        if (zStream. total_out - bytesProcessedAlready >= [uncompressedData length ]) {
            
            [uncompressedData increaseLengthBy :halfLength];
            
        }
        
        
        zStream. next_out = ( Bytef *)[uncompressedData mutableBytes ] + zStream. total_out -bytesProcessedAlready;
        
        zStream. avail_out = ( unsigned int )([uncompressedData length ] - (zStream. total_out -bytesProcessedAlready));
        
        
        
        status = inflate (&zStream, Z_NO_FLUSH );
        
        
        
        if (status == Z_STREAM_END ) {
            
            break ;
            
        } else if (status != Z_OK ) {
            
            return nil ;
        }
    }
    
    status = inflateEnd (&zStream);
    
    if (status != Z_OK ) {
        
        return nil ;
        
    }
    
    [uncompressedData setLength : zStream. total_out -bytesProcessedAlready];  // Set real length
    return uncompressedData;

}

+ (BOOL)isExistsForTargetFile:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isFilePath = [fileManager fileExistsAtPath:fileName];
    if (!isFilePath) {
//        NSLog(@"文件不存在");
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL)deleteFileAtPath:(NSString *)delete_path
{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSError *error = nil;
    return [fileManager removeItemAtPath:delete_path error:&error];
}

+ (BOOL)CreatFileDirectoryForPath:(NSString *)dirPath
{
    if(![IHFMCommonTools isExistsForTargetFile:dirPath]) {
        @autoreleasepool {
            BOOL res=[[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res == NO) {
                NSLog(@" 文件创建失败");
            }
            return res;
        }
    }
    else return YES;
}

+ (NSString *)creatDocDicAddFilePath:(NSString *)targetPath;
{
    // document dicrectory
    NSString *docDic = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDic,targetPath];
    BOOL isOK = [IHFMCommonTools CreatFileDirectoryForPath:filePath];
    if (isOK) {
        return filePath;
    }else return nil;
    
    
}


/*!
 *  @author lhongsong, 15-07-09 15:07:25
 *
 *  清理文件夹目录下的所有文件
 */
+ (BOOL)clearFileDirectoryOnPath:(NSString *)dirPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileArray = [manager contentsOfDirectoryAtPath:dirPath error:&error];
    if(fileArray)
    {
        for(int i = 0 ; i < fileArray.count ; i++)
        {
            NSString *path = [dirPath stringByAppendingPathComponent:fileArray[i]];
            [manager removeItemAtPath:path error:&error];
        }
        return YES;
    }
    else
    {
        return YES;
    }
}

+ (UIImage *)tailorImage:(UIImage *)innerImg tailorRect:(CGRect)rect
{
    
    CGImageRef smallImage = CGImageCreateWithImageInRect(innerImg.CGImage, rect);
    /**!
     @auto hulinhua 
     @param release
     */
    UIImage *img = [UIImage imageWithCGImage:smallImage];
    CGImageRelease(smallImage);
    return img;
}

#pragma mark - >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   监测网络块 

#pragma mark - 检测当前网络状态
+ (BOOL)currentNetworkStatus
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    return [r currentReachabilityStatus];
}

+ (BOOL)isConnectedByWifi
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    }
    else
        return NO;
}

+ (BOOL)isConnectedByWwan
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == ReachableViaWWAN) {
        return YES;
    }
    else
        return NO;
}

+ (NetworkType)NetworkStatus
{
    NetworkType Type = 0;
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == NotReachable) {
        Type = NoNetwork;
    }
    else if ([r currentReachabilityStatus] == ReachableViaWiFi)
    {
        Type = WifiNetwork;
    }
    else if ([r currentReachabilityStatus] == ReachableViaWWAN)
    {
        Type = WwanNetwork;
    }
    return Type;
}

+ (NetworkType)NetworkStatusWithHostName:(NSString*)hostName;
{
    NetworkType Type = 0;
    Reachability *r = [Reachability reachabilityWithHostName:hostName];
    if ([r currentReachabilityStatus] == NotReachable) {
        Type = NoNetwork;
    }
    else if ([r currentReachabilityStatus] == ReachableViaWiFi)
    {
        Type = WifiNetwork;
    }
    else if ([r currentReachabilityStatus] == ReachableViaWWAN)
    {
        Type = WwanNetwork;
    }
    return Type;
}


#pragma -mark 获取到沙盒路径
+ (NSString *)getCaches
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *cachePath = [cache objectAtIndex:0];
    return cachePath;
    
}

#pragma -mark 截图
+ (UIImage *)capImageByView:(UIView *)capView
{
    CGRect rect = [capView bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [capView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageViewData = UIImagePNGRepresentation(img);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName = @"capImage.png";
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageViewData writeToFile:savedImagePath atomically:YES];
    return img;
}

+ (instancetype)getCurrentViewControllerAtView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (id)nextResponder;
        }
    }
    return nil;
}


+ (double)freeDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    return freespace/1024/1024;
}

+ (id)getJsonFromFile:(NSString *)filePath
{
    BOOL isexist = [IHFMCommonTools isExistsForTargetFile:filePath];
    if (isexist) {
        
        NSString *sjonStr = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
        return  [self dictionaryWithJsonString:sjonStr];
        
        
    }else
    {
        return nil;
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
