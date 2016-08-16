//
//  IHFDataSliderImageCache.h
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/3/16.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHFDataSliderImageCache : NSObject

// 自定义表名
#define tableNameForSliderCache @"ihfDataSliderImagedown"


// 创建表
+ (BOOL)creatTable;


// 插入一条数据
+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID pictureCount:(NSInteger)idx cacheIng:(NSString *)ing;


// 查询表中所有数据
+ (NSMutableArray *)executeQueryAll;

// 查询缓存状态，如果return nil 则没有缓存过
+ (NSMutableArray *)isCachePicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID;


+ (BOOL)updataCacheIdx:(NSString *)patientID study:(NSString *)stuID series:(NSString *)seriresID  maxDownIdx:(NSInteger)idx cache:(NSString *)boolStr;

// 删除某个系列的下载
+ (BOOL)deleteDataContainSeriesID:(NSString *)seriresID;

+ (BOOL)removeAllRecord;

@end
