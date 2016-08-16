//
//  IHF2DImageCacheManager.m
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/15.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHF2DImageCacheManager.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "CoreFMDB.h"


@implementation IHF2DImageCacheManager

+(void)load
{
    [self creatTable];
}

/*! 创建表 */
+ (BOOL)creatTable
{
    NSString *createSQLStr = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoIncrement,patientID text,studyID text,seriesID text,sopID text,asc text,fileName text,alternate text,time datetime)",T_2DImageCacheTableName];
    return [CoreFMDB executeUpdate:createSQLStr];
    
}

+ (NSArray *)executeColumns
{
    return [CoreFMDB executeQueryColumnsInTable:T_2DImageCacheTableName];
}

+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr fileName:(NSString *)file_name imageAttrubute:(NSString*)imageInfo
{
    NSDate *timeNow = [NSDate date];
    NSString *executeStr = [NSString stringWithFormat:@"insert into %@ (patientID,studyID,seriesID,sopID,asc,fileName,alternate,time) values('%@','%@','%@','%@','%@','%@','%@','%@');",T_2DImageCacheTableName,patientID,studyID,seiresID,sopID,ascStr,file_name,imageInfo,timeNow];
    BOOL isok = [CoreFMDB executeUpdate:executeStr];
    
    return isok;
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
                                   ,@"fileName":[set stringForColumn:@"fileName"]
                                   ,@"alternate":[set stringForColumn:@"alternate"]
                                   ,@"time":[set stringForColumn:@"time"]};
            
            [arr addObject:dic];
        }
        
    }];
    return arr;
}

+ (NSMutableArray *)executeQueryAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@;",T_2DImageCacheTableName];
    return [self queryDataList:sql];
}

+ (NSMutableArray *)executeQueryAllFileNameArrayFromStudyID:(NSString *)stuID seriesID:(NSString *)serID
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where studyID='%@' and seriesID='%@';",T_2DImageCacheTableName,stuID,serID];
    NSMutableArray *arr = [NSMutableArray array];
    [CoreFMDB executeQuery:sql queryResBlock:^(FMResultSet *set) {
        while ([set next]) {
            [arr addObject:[set stringForColumn:@"fileName"]];
        }
        
    }];
    return arr;
}

+ (NSMutableArray *)executeQueryLimtNumble:(NSInteger)idx
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ weher limit %ld",T_2DImageCacheTableName,idx];
    return [self queryDataList:sql];
    
}

+ (NSMutableArray *)getAllPatientIDLimit:(NSInteger)idx
{
    NSMutableArray *dataListArr = [self executeQueryLimtNumble:idx];
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
    return [CoreFMDB countTable:T_2DImageCacheTableName];
}

+ (BOOL)removeAllRecord
{
    return [CoreFMDB truncateTable:T_2DImageCacheTableName];
}

+ (NSDictionary *)isExistPicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID sop:(NSString *)sopID asc:(NSString *)ascStr fileName:(NSString *)file_name
{
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where patientID='%@' and studyID='%@' and seriesID='%@' and sopID='%@' and asc='%@' and fileName='%@'",T_2DImageCacheTableName,patientID,studyID,seiresID,sopID,ascStr,file_name];
    NSMutableArray *arr = [self queryDataList:sql];
    if (arr.count>0) {
        return arr[0];
    }else
    {
        return nil;
    }
    
}

+ (BOOL)deleteDataContainWithSeriesAndFileName:(NSString *)seriesID fileName:(NSString *)fileName
{

    NSString *sql = [NSString stringWithFormat:@"delete from %@ where seriesID='%@' and fileName='%@'",T_2DImageCacheTableName,seriesID,fileName];
    return [CoreFMDB executeUpdate:sql];

}

+ (BOOL)deleteDataContainPatientIDs:(NSMutableArray *)patientIDs
{
    BOOL result = YES;
    for (NSString *obj in patientIDs) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where patientID='%@'",T_2DImageCacheTableName,obj];
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
