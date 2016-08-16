//
//  YX_Net.h
//  yingxiangliuchen
//
//  Created by ihefe－hulinhua on 16/7/20.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHFNetBase.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

#define kNEWIP @"http://192.168.10.20:9091/webserver-2.0"

typedef void(^IMG_responseBack)(int success,id response);

@interface YX_Net : IHFNetBase
+(void)loginWith:(NSString *)id1 pw:(NSString *)id2 callBack:(IHFMResponseBack)response;

+ (void)getRisList:(NSString*)token callBack:(IHFMResponseBack)response;

+ (void)getImageSeriesListWithStudyID:(NSString *)studyID RelateID:(NSString *)relateID callBack:(IHFMResponseBack)risCallBack;

+ (void)getImageListAndAttribute:(NSNumber *)seriesId callBack:(IHFMResponseBack)response;

+ (void)getJPEGLSPictrueDataFor2DPatientIDLossyerror:(NSString *)p_id studyID:(NSString *)stu_id seriesID:(NSString *)ser_id FileName:(NSString *)fileName lossyerror:(CGFloat)loss callBack:(IHFMResponseBack)response;

+ (AFHTTPRequestOperation *)getJPEGLSPictrueDataFor2DPatientID:(NSString *)p_id studyID:(NSString *)stu_id seriesID:(NSString *)ser_id FileName:(NSString *)fileName lossyerror:(CGFloat)loss callBack:(IHFMResponseBack)response;


@end
