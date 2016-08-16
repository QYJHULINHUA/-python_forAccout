//
//  IHFMDataBaseManager.h
//  FMDB_Demo
//
//  Created by ihefe－hulinhua on 16/1/15.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>

// 自定义表名
#define tableName_cache @"ihfimagecache"

@interface IHFMDataBaseManager : NSObject

// 创建表
+ (BOOL)creatTable;

//查询出表所有的列 (表字段)
+ (NSArray *)executeColumns;

// 插入一条数据
+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr pictureIdx:(NSInteger)idx;

// 查询表中所有数据
+ (NSMutableArray *)executeQueryAll;

// 取前idx条数据
+ (NSMutableArray *)executeQueryLimtNumble:(NSInteger)idx;

// 查询前idx条数据中所有的patientid
+ (NSMutableArray *)getAllPatientIDLimit:(NSInteger)idx;

// 查询表中数据总数
+ (NSInteger)executeCountTable;

// 清除所有记录
+ (BOOL)removeAllRecord;

// 查询数据是否存在
+ (BOOL)isExistPicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr pictureIdx:(NSInteger)idx;

+ (BOOL)deleteDataContainPatientIDs:(NSMutableArray *)patientIDs;

+ (double)freeDiskSpaceInBytes;

@end
