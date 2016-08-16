//
//  IHF2DImgManager.m
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/15.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHF2DImgManager.h"
#import "IHF2DImageCacheManager.h"
#import "IHFJPEGLSClient.h"


@implementation IHF2DImgManager

+ (NSString *)documentsDirectory
{
    static NSString *document = nil;
    if (!document) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        document = [paths objectAtIndex:0];
    }
    return document;
}

+ (NSArray *)getPngOrJpegFromCache:(NSString *)patientID stuid:(NSString *)stuID series:(NSString *)seriesID sopStr:(NSString *)sopID ASC_Str:(NSString *)asc fileName:(NSString *)file_name
{
    UIImage *result;
    
    NSDictionary *isExist = [IHF2DImageCacheManager isExistPicture:patientID study:stuID series:seriesID sop:sopID asc:asc fileName:file_name];
    
    if (isExist) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@",[self documentsDirectory],IHFImgCache2DLocal,patientID,stuID,seriesID,sopID,asc,file_name];
        
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        if (imageData == nil) {
            return nil;
        }
        result = [IHFJPEGLSClient getImageFormJPEGLSData:imageData];
        if (!result) {
            NSLog(@"解压生成图片数据失败");
            BOOL isok =[IHF2DImageCacheManager deleteDataContainWithSeriesAndFileName:seriesID fileName:filePath];
            if (!isok) {
                NSLog(@"2DManeger____IHF2DImageCache 清除该张缓存失败，请根据该log定位到问题所在，找到原因");
            }
            return nil;
        }
        else
        {
            return @[result,isExist];
        }
        
    }else
    {
        return nil;
    }
    
    
}

+ (NSMutableArray *)executeQueryAllFileNameArrayFromStudyID:(NSString *)stuID seriesID:(NSString *)serID
{
    return [IHF2DImageCacheManager executeQueryAllFileNameArrayFromStudyID:stuID seriesID:serID];
}

+ (BOOL)savePngOrJpegIntoLocal:(NSString *)patientID study:(NSString *)stuID series:(NSString *)seriesID sopStr:(NSString *)sopID ASC_Str:(NSString *)asc fileName:(NSString *)file_name imgdata:(id)image imageInfo:(NSString *)imgInfo
{
    NSString *filePath = [self getDirectoryAtPath:patientID study:stuID series:seriesID sopStr:sopID ASC_Str:asc fileName:file_name];
    
    if (!filePath) return NO;
    
    BOOL write =[image writeToFile:filePath atomically:YES];
    if (write) {
        return [IHF2DImageCacheManager insetData:patientID study:stuID series:seriesID sop:sopID asc:asc fileName:file_name imageAttrubute:imgInfo];
    }else
    {
        return NO;
    }
}

+ (NSString *)getDirectoryAtPath:(NSString *)patientID study:(NSString *)studyID series:(NSString *)seriesID sopStr:(NSString *)sopID ASC_Str:(NSString *)asc fileName:(NSString *)file_name
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@",[self documentsDirectory],IHFImgCache2DLocal,patientID,studyID,seriesID,sopID,asc];
    
    if (![self isExistsForTargetFile:filePath])
    {
        if (![self CreatFileDirectoryForPath:filePath])
        {
            return nil;
        }
    }
    
    NSString *fileP = [NSString stringWithFormat:@"%@/%@",filePath,file_name];
    return fileP;
}

+ (BOOL)autoCleanCache
{
    double memeroy = [IHF2DImageCacheManager freeDiskSpaceInBytes];
    if (memeroy > 500)
    {
        return YES;
    }
    else
    {
        NSMutableArray *pat_arr = [IHF2DImageCacheManager getAllPatientIDLimit:1000];
        if (pat_arr) {
            return [IHF2DImageCacheManager deleteDataContainPatientIDs:pat_arr];
        }
        else
        {
            return NO;
        }
    }
    
}

+ (BOOL)isExistsForTargetFile:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isFilePath = [fileManager fileExistsAtPath:fileName];
    if (!isFilePath) {
        //        NSLog(@"文件不存在");
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL)CreatFileDirectoryForPath:(NSString *)dirPath
{
    if(![self isExistsForTargetFile:dirPath]) {
        @autoreleasepool {
            BOOL res=[[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res == NO) {
                NSLog(@" 文件创建失败");
            }
            return res;
        }
    }
    else return YES;
}
+ (BOOL)removeAllCache
{
    BOOL isok = [IHF2DImageCacheManager removeAllRecord];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self documentsDirectory],IHFImgCache2DLocal];
    BOOL isok1 = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    return isok&&isok1;
    
}

@end
