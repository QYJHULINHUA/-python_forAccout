//
//  IHFDataDownloadManager.m
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/3/2.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHFDataDownloadManager.h"
#import "CoreFMDB.h"
#import "IHFMCommonTools.h"

@implementation IHFDataDownloadManager

+(void)load
{
    [self creatTable];
}

+ (BOOL)creatTable
{
    
    NSString *createSQLStr = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoIncrement,patientID text,studyID text,seriesID text,time text,p_name text,regTime text,size float,progress float,modility text,alternate text)",tableNameForDownload];
    return [CoreFMDB executeUpdate:createSQLStr];
    
}

+ (NSArray *)executeColumns
{
    return [CoreFMDB executeQueryColumnsInTable:tableNameForDownload];
}

+ (BOOL)insetData:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID regtime:(NSString *)regTime modility:(NSString *)modilityStr patientName:(NSString *)name pictureTotalNumble:(NSInteger)num
{
    NSString *downLoadTime = [IHFMCommonTools getCurrentDateAndTimeString];
    CGFloat sizeN = 0;
    CGFloat progressS = 0;
    NSString *insertStr = [NSString stringWithFormat:@"insert into %@(patientID,studyID,seriesID,time,p_name,regTime,size,progress,alternate,modility) values('%@','%@','%@','%@','%@','%@','%0.1f','%0.1f','%d','%@')",tableNameForDownload,patientID,studyID,seiresID,downLoadTime,name,regTime,sizeN,progressS,num,modilityStr];
    return [CoreFMDB executeUpdate:insertStr];
    

}

+ (NSMutableArray *)executeQueryAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@;",tableNameForDownload];
    return [IHFDataDownloadManager queryDataList:sql];
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
                                   ,@"p_name":[set stringForColumn:@"p_name"]
                                   ,@"size":[set stringForColumn:@"size"]
                                   ,@"alternate":[set stringForColumn:@"alternate"]
                                   ,@"progress":[set stringForColumn:@"progress"]
                                   ,@"modility":[set stringForColumn:@"modility"]
                                   ,@"regTime":[set stringForColumn:@"regTime"]
                                   ,@"pictureCount":[set stringForColumn:@"alternate"]};
            
            [arr addObject:dic];
        }
        
    }];
    return arr;
}


+ (NSInteger)executeCountTable
{
    return [CoreFMDB countTable:tableNameForDownload];
}

// 清除所有记录
+ (BOOL)removeAllRecord
{
    return [CoreFMDB truncateTable:tableNameForDownload];
}


+ (BOOL)deleteDataContainSeriesID:(NSString *)seriresID
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where seriesID='%@'",tableNameForDownload,seriresID];
    return [CoreFMDB executeUpdate:sql];
}

// 查询数据是否存在
+ (int)isExistPicture:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seiresID
{
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where patientID='%@' and studyID='%@' and seriesID='%@'",tableNameForDownload,patientID,studyID,seiresID];
    
    NSMutableArray *arr = [IHFDataDownloadManager queryDataList:sql];
    if (arr == nil || arr.count < 1) {
        return 0;
    }else
    {
        NSDictionary *dic = arr[0];
        NSString *progress = dic[@"progress"];
        
        if (progress.floatValue < 1) {
            return 1;
        }
        else
        {
            return 2;
        }
        
    }
    
}

+ (BOOL)updataDownProgress:(NSString *)patientID study:(NSString *)stuID series:(NSString *)seriresID  progress:(CGFloat)x size:(CGFloat)y
{
    NSString *sql;
    if (y == -1) {
        sql = [NSString stringWithFormat:@"UPDATE %@ SET progress = '%f' WHERE seriesID = '%@'",tableNameForDownload,x,seriresID];
    }else
    {
        y = y / (1024 * 1024);
        sql = [NSString stringWithFormat:@"UPDATE %@ SET progress = '%f',size = '%0.1f'  WHERE seriesID = '%@'",tableNameForDownload,x,y,seriresID];
    }
    
    BOOL isok = [CoreFMDB executeUpdate:sql];
    return isok;
}


@end
