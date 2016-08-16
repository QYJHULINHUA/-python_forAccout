//
//  IHFDataDownloadManager.h
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/3/2.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IHFDataDownloadManager : NSObject

// 自定义表名
#define tableNameForDownload @"ihfimageDownload"


// 创建表
+ (BOOL)creatTable;

//查询出表所有的列 (表字段)
+ (NSArray *)executeColumns;

// 插入一条数据
+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID regtime:(NSString *)regTime modility:(NSString *)modilityStr patientName:(NSString *)name pictureTotalNumble:(NSInteger)num;

// 查询表中所有数据
+ (NSMutableArray *)executeQueryAll;


// 查询表中数据总数
+ (NSInteger)executeCountTable;

// 清除所有记录
+ (BOOL)removeAllRecord;

/*
 @! 查询数据是否存在
 @ return 0 不存在／retuan1 已存在下载／ruturn 2下载完成
 */

+ (int)isExistPicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID;

// 更新下载进度
+ (BOOL)updataDownProgress:(NSString *)patientID study:(NSString *)stuID series:(NSString *)seriresID  progress:(CGFloat)x size:(CGFloat)y;

// 删除某个系列的下载
+ (BOOL)deleteDataContainSeriesID:(NSString *)seriresID;


@end
