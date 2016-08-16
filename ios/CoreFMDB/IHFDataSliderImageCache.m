//
//  IHFDataSliderImageCache.m
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/3/16.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHFDataSliderImageCache.h"
#import "CoreFMDB.h"
#import "IHFMCommonTools.h"

@implementation IHFDataSliderImageCache

+ (BOOL)creatTable
{
    NSString *createSQLStr = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoIncrement,patientID text,studyID text,seriesID text,time text,pictureCount text,cacheIng text,maxIdx text)",tableNameForSliderCache];
    return [CoreFMDB executeUpdate:createSQLStr];
}


// 插入一条数据
+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID pictureCount:(NSInteger)idx cacheIng:(NSString *)ing
{
    NSString *downLoadTime = [IHFMCommonTools getCurrentDateAndTimeString];
    NSString *picNum = [NSString stringWithFormat:@"%ld",idx];
    NSString *insertStr = [NSString stringWithFormat:@"insert into %@(patientID,studyID,seriesID,time,pictureCount,cacheIng,maxIdx) values('%@','%@','%@','%@','%@','%@','%@')",tableNameForSliderCache,patientID,studyID,seiresID,downLoadTime,picNum,@"YES",@"0"];
    return [CoreFMDB executeUpdate:insertStr];
}


// 查询表中所有数据
+ (NSMutableArray *)executeQueryAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@;",tableNameForSliderCache];
    return [IHFDataSliderImageCache queryDataList:sql];
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
                                   ,@"time":[set stringForColumn:@"time"]
                                   ,@"pictureCount":[set stringForColumn:@"pictureCount"]
                                   ,@"cacheIng":[set stringForColumn:@"cacheIng"]
                                   ,@"maxIdx":[set stringForColumn:@"maxIdx"]};
            
            [arr addObject:dic];
        }
        
    }];
    return arr;
}



+ (NSMutableArray *)isCachePicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID
{

    NSString *sql = [NSString stringWithFormat:@"select * from %@ where patientID='%@' and studyID='%@' and seriesID='%@'",tableNameForSliderCache,patientID,studyID,seiresID];
    
    NSMutableArray *arr = [IHFDataSliderImageCache queryDataList:sql];
    return arr;
}

// 更新下载进度
+ (BOOL)updataCacheIdx:(NSString *)patientID study:(NSString *)stuID series:(NSString *)seriresID  maxDownIdx:(NSInteger)idx cache:(NSString *)boolStr
{
    NSString *sql;
    if (idx == -1) {
        sql = [NSString stringWithFormat:@"UPDATE %@ SET cacheIng = '%@' WHERE seriesID = '%@'",tableNameForSliderCache,boolStr,seriresID];
    }
    else
    {
        sql = [NSString stringWithFormat:@"UPDATE %@ SET maxIdx = '%d', cacheIng = '%@' WHERE seriesID = '%@'",tableNameForSliderCache,idx,boolStr,seriresID];
    }
    
    BOOL isok = [CoreFMDB executeUpdate:sql];
    
    return isok;
}

+ (BOOL)deleteDataContainSeriesID:(NSString *)seriresID
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where seriesID='%@'",tableNameForSliderCache,seriresID];
    return [CoreFMDB executeUpdate:sql];
}

// 清除所有记录
+ (BOOL)removeAllRecord
{
    return [CoreFMDB truncateTable:tableNameForSliderCache];
}


@end
