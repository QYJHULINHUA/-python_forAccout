//
//  IHFMCommonTools.h
//  IHFMedicImage
//
//  Created by ihefe－hulinhua on 15/6/18.
//  Copyright (c) 2015年 ihefe－hlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"


extern void MakeIQIView(NSMutableArray *arr,UIView *superView,NSInteger iqiTag);


typedef NS_ENUM (NSInteger, NetworkType)
{
    NoNetwork   = 0,
    WifiNetwork = 1,
    WwanNetwork = 2,
    
};

@interface IHFMCommonTools : NSObject

/*!
 @param requestRandom 获得一个随机数
 @param randomFrom 获得一个随机数 ［from to）为其随机的范围
 @return 上面一个return一个字符串，后面的为整数
 */
+(NSString *)requestRandom;
+(int)randomFrom:(int)from to:(int)to;

/**
 @param stringIsNUllToId 获得一个为nil的空字符串
 @return 返回字符串
 */
+(NSString *)stringIsNUllToId:(id)element;

/**
 @param createImageWithColor 创建一个纯颜色的图片
 @param color 图片的颜色
 @param rect 图片的大小
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGRect)rect;

/**
 @param getCurrentDateAndTimeString 获取当前时间
 @return 返回string
 */
+ (NSString *)getCurrentDateAndTimeString;

/**
 @param decompressData 将一块压缩的内存数据解压
 *
 */
+ ( NSData *)decompressData:( NSData *)compressedData;

/**
 @param isExistsForTargetFile 判断目标文件或者文件夹是否存在
 @param fileName 文件路径
 */
+ (BOOL)isExistsForTargetFile:(NSString*)fileName;

/**
 @param CreatFileDirectoryForPath 创建文件夹
 @param dirPath 文件夹路径
 @return YES creat success, else false
 */
+ (BOOL)CreatFileDirectoryForPath:(NSString *)dirPath;

/**!
 @auto hulinhua
 @docDicAddFilePath 在NSDocumentationDirectory下穿件targetPath文件夹
 @param targetPath 目标文件夹，不需要包含沙盒路径
 @return 返回完整路径，如果存在直接返回，不存在创建路径
 */
+ (NSString *)creatDocDicAddFilePath:(NSString *)targetPath;

/*!
 *  @author lhongsong, 15-07-09 13:07:53
 *
 *  删除当前文件夹路径下的所有文件
 *
 *  @param dirPath 文件夹路径
 *
 *  @return 是否成功
 */

+ (BOOL)deleteFileAtPath:(NSString *)delete_path;


+ (BOOL)clearFileDirectoryOnPath:(NSString *)dirPath;


/**
 @param tailorImage 对图片进行裁剪 
 @param innerImg 要进行裁剪的图片
 @param rect 裁剪的位子
 @param 返回裁剪得到的图片
 */
+ (UIImage *)tailorImage:(UIImage *)innerImg tailorRect:(CGRect)rect;

#pragma mark - >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 网络监测块

/* 检测当前网络状态 */
+ (BOOL)currentNetworkStatus;
//+ (ReachableSingleton *) sharedInstance;//单例

+ (BOOL)isConnectedByWifi; //是否使用3g， GPRS网络
+ (BOOL)isConnectedByWwan; //是否使用Wi-Fi

/* 获取当前网络类型 */
+ (NetworkType)NetworkStatus;

+ (NetworkType)NetworkStatusWithHostName:(NSString*)hostName;
#pragma mark - 实时监测网络状态的方法

/**!
 @auto hulinhua 实时监测网络状态的方法，这里仅提供写法
 
 @param ********************************************************** 检查某一个网址的连通性
 
 
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(methed:)
                                             name: kReachabilityChangedNotification
                                           object: nil];
hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
[hostReach startNotifier]; //开始监听,会启动一个run loop
 

 @param ********************************************************** 检查某一个网址的连通性
 
 */



#pragma mark - 实时监测网络状态的方法OVER

#pragma mark - 获取沙盒路径
+ (NSString *)getCaches;

#pragma mark - 根据传入的view截图,返回图片
+ (UIImage *)capImageByView:(UIView *)capView;

#pragma mark - 获得当前视图所在的vc
+ (instancetype)getCurrentViewControllerAtView:(UIView *)view;

#pragma mark - 获得空闲存储大小
+ (double)freeDiskSpaceInBytes;

#pragma mark - 将json文件解析
+ (id)getJsonFromFile:(NSString *)filePath;


@end
