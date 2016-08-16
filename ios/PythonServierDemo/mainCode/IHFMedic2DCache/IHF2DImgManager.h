//
//  IHF2DImgManager.h
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/15.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IHFImgCache2DLocal @"IHEFEMedicImageLocalCache"

@interface IHF2DImgManager : NSObject

/*! 取图片 */
+ (NSArray *)getPngOrJpegFromCache:(NSString *)patientID stuid:(NSString *)stuID series:(NSString *)seriesID sopStr:(NSString *)sopID ASC_Str:(NSString *)asc fileName:(NSString *)file_name;

/*! 保存图片 */
+ (BOOL)savePngOrJpegIntoLocal:(NSString *)patientID study:(NSString *)stuID series:(NSString *)seriesID sopStr:(NSString *)sopID ASC_Str:(NSString *)asc fileName:(NSString *)file_name imgdata:(id)image imageInfo:(NSString *)imgInfo;

+ (NSMutableArray *)executeQueryAllFileNameArrayFromStudyID:(NSString *)stuID seriesID:(NSString *)serID;

/*! 清除所有缓存 */
+ (BOOL)removeAllCache;

@end
