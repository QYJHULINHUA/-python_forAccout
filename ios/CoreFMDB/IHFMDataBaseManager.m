//
//  IHFMDataBaseManager.m
//  FMDB_Demo
//
//  Created by ihefe－hulinhua on 16/1/15.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHFMDataBaseManager.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "CoreFMDB.h"

#define DATABASE_PATH @"IHFImgCache.db"

@implementation IHFMDataBaseManager

+ (BOOL)creatTable
{
    NSString *createSQLStr = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoIncrement,patientID text,studyID text,seriesID text,sopID text,asc text,pictureIdx integer,alternate text,time datetime)",tableName_cache];
    return [CoreFMDB executeUpdate:createSQLStr];

}

+ (NSArray *)executeColumns
{
    return [CoreFMDB executeQueryColumnsInTable:tableName_cache];
}

+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr pictureIdx:(NSInteger)idx
{
    NSDate *timeNow = [NSDate date];
    NSString *executeStr = [NSString stringWithFormat:@"insert into %@ (patientID,studyID,seriesID,sopID,asc,pictureIdx,alternate,time) values('%@','%@','%@','%@','%@',%ld,'alternate_default','%@');",tableName_cache,patientID,studyID,seiresID,sopID,ascStr,idx,timeNow];
    return [CoreFMDB executeUpdate:executeStr];
}

+ (NSMutableArray *)queryDataList:(NSString *)sql
{
    NSMutableArray *arr = [NSMutableArray array];
    [CoreFMDB executeQuery:sql queryResBlock:^(FMResultSet *set) {
        while ([set next]) {
            NSDictionary *dic = @{ @"id":[set stringForColumn:@"id"]
                                   ,@"patientID":[set stringForColumn:@"patientID"]
                                   ,@"studyID":[set stringForColumn:@"studyID"]
                                   ,@"seriesID":[set stringForColumn:@"seriesID"]
                                   ,@"sopID":[set stringForColumn:@"sopID"]
                                   ,@"asc":[set stringForColumn:@"asc"]
                                   ,@"pictureIdx":[set stringForColumn:@"pictureIdx"]
                                   ,@"alternate":[set stringForColumn:@"alternate"]
                                   ,@"time":[set stringForColumn:@"time"]};
            
            [arr addObject:dic];
        }
        
    }];
    return arr;
}

+ (NSMutableArray *)executeQueryAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@;",tableName_cache];
    return [IHFMDataBaseManager queryDataList:sql];
}

+ (NSMutableArray *)executeQueryLimtNumble:(NSInteger)idx
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ weher limit %ld",tableName_cache,idx];
    return [IHFMDataBaseManager queryDataList:sql];
    
}

+ (NSMutableArray *)getAllPatientIDLimit:(NSInteger)idx
{
    NSMutableArray *dataListArr = [IHFMDataBaseManager executeQueryLimtNumble:idx];
    NSMutableSet *set = [NSMutableSet set];
    [dataListArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:obj[@"patientID"]];
    }];
    NSMutableArray *arr = [NSMutableArray array];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    return arr;
}

+ (NSInteger)executeCountTable
{
    return [CoreFMDB countTable:tableName_cache];
}

+ (BOOL)removeAllRecord
{
    return [CoreFMDB truncateTable:tableName_cache];
}

+ (BOOL)isExistPicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr pictureIdx:(NSInteger)idx
{

    NSString *sql = [NSString stringWithFormat:@"select * from %@ where patientID='%@' and studyID='%@' and seriesID='%@' and sopID='%@' and asc='%@' and pictureIdx=%ld",tableName_cache,patientID,studyID,seiresID,sopID,ascStr,idx];
    NSMutableArray *arr = [IHFMDataBaseManager queryDataList:sql];
    BOOL result = NO;
    if (arr) {
        if (arr.count > 0) {
            result = YES;
        }
    }
    return result;
}

+ (BOOL)deleteDataContainPatientIDs:(NSMutableArray *)patientIDs
{
    BOOL result = YES;
    for (NSString *obj in patientIDs) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where patientID='%@'",tableName_cache,obj];
        BOOL isok = [CoreFMDB executeUpdate:sql];
        if (!isok) {
            result = NO;
        }
    }
    return result;
    
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

@end
