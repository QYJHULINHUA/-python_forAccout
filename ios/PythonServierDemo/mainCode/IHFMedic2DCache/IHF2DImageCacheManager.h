//
//  IHF2DImageCacheManager.h
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/15.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>

// 自定义表名
#define T_2DImageCacheTableName @"ihf2dImageCacheName"

/*! 2D图片缓存数据库 */
@interface IHF2DImageCacheManager : NSObject


//查询出表所有的列 (表字段)
+ (NSArray *)executeColumns;

// 插入一条数据
+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr fileName:(NSString *)file_name imageAttrubute:(NSString*)imageInfo;

// 查询表中所有数据
+ (NSMutableArray *)executeQueryAll;

/*! 查询该序列缓存过的所有文件 */
+ (NSMutableArray *)executeQueryAllFileNameArrayFromStudyID:(NSString *)stuID seriesID:(NSString *)serID;

// 取前idx条数据
+ (NSMutableArray *)executeQueryLimtNumble:(NSInteger)idx;

// 查询前idx条数据中所有的patientid
+ (NSMutableArray *)getAllPatientIDLimit:(NSInteger)idx;

// 查询表中数据总数
+ (NSInteger)executeCountTable;

// 清除所有记录
+ (BOOL)removeAllRecord;

// 查询数据是否存在
+ (NSDictionary *)isExistPicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr fileName:(NSString *)file_name;

+ (BOOL)deleteDataContainPatientIDs:(NSMutableArray *)patientIDs;
+ (BOOL)deleteDataContainWithSeriesAndFileName:(NSString *)seriesID fileName:(NSString *)fileName;

+ (double)freeDiskSpaceInBytes;

@end
