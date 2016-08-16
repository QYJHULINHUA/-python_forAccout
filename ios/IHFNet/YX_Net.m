//
//  YX_Net.m
//  yingxiangliuchen
//
//  Created by ihefe－hulinhua on 16/7/20.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "YX_Net.h"

#import "YX_ReqModel.h"

#define image2DURL @"http://192.168.10.20:50003/charlie/ihefeMedImg2DServer"

@implementation YX_Net

+(void)loginWith:(NSString *)id1 pw:(NSString *)id2 callBack:(IHFMResponseBack)response
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"text/plain",@"text/html",@"application/json", nil];
    
    NSDictionary *param = @{
                            @"enterprise_id":@"1",
                            @"subsys_type":@"1",
                            @"login_id":@"lucas",
                            @"pwd":@"lucas"
                            };
    
    
    NSString *suffixStr = @"/login/login";
    NSString *url = [NSString stringWithFormat:@"%@%@",kNEWIP,suffixStr];
    
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        NSArray *data = dic[@"data"];
        response ([NSNumber numberWithBool:YES],data);
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        response ([NSNumber numberWithBool:NO],nil);
    }];
}


//http://192.168.10.20:9091/webserver-2.0/image/studyList

+ (void)getRisList:(NSString*)token callBack:(IHFMResponseBack)response
{
    NSString *url = @"http://192.168.10.20:9091/webserver-2.0/image/studyList";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"access_token"] = token;
    param[@"pagenum"] = @(1);
    param[@"pagesize"] = @(15);
    param[@"modality"] = @"CT";
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = responseObject;
        response ([NSNumber numberWithBool:YES],dic);
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        response ([NSNumber numberWithBool:NO],nil);
    
    }];

}
+ (void)getImageSeriesListWithStudyID:(NSString *)studyID RelateID:(NSString *)relateID callBack:(IHFMResponseBack)risCallBack
{

    NSString *urlStr = @"http://192.168.10.20:9091/webserver-2.0/image/getSeriesList";
    
    NSString *token = [YX_ReqModel_login getShareInstance].accessToken;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"access_token"] = token;
    param[@"relatetopacs"] = relateID;
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        risCallBack ([NSNumber numberWithBool:YES],dic);
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        risCallBack ([NSNumber numberWithBool:NO],nil);
    }];
}


+ (void)getImageListAndAttribute:(NSNumber *)seriesId callBack:(IHFMResponseBack)response
{
    

    NSString *urlStr = @"http://192.168.10.20:9091/webserver-2.0/image/getImageList";
    
    NSString *token = [YX_ReqModel_login getShareInstance].accessToken;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"access_token"] = token;
    param[@"seriesid"] = seriesId;
    [self getAttribuFormServer:urlStr param:param callBack:response];
    
    
    
}

+ (void)getAttribuFormServer:(NSString *)url param:(NSMutableDictionary*)param callBack:(IHFMResponseBack)response
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (!response) return;
        NSDictionary *dic = responseObject;
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArr = dic[@"data"];
            if (dataArr && [dataArr isKindOfClass:[NSArray class]]) {
                response([NSNumber numberWithBool:YES],dataArr);
            }else
            {
                response([NSNumber numberWithBool:NO],@"请求失败");
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (!response) return;
        response([NSNumber numberWithBool:NO],@"请求失败");
    }];
    
//    [self postMethod:manager postUrl:url param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        
////        IHFImageList *imgListModel = [[IHFImageList alloc] init];
////        [imgListModel dictionaryToModel:responseObject];
////        if (imgListModel.imageListData && imgListModel.imageListData.count > 0) {
////            response([NSNumber numberWithBool:YES],imgListModel.imageListData);
////        }else response([NSNumber numberWithBool:NO],@"请求无数据");
//        
//    } failure:^(IHFMNetErrorMsg *req_errMsg) {
//        if (!response) return;
//
//        
//    }];
    
   
}

+ (void)getJPEGLSPictrueDataFor2DPatientIDLossyerror:(NSString *)p_id studyID:(NSString *)stu_id seriesID:(NSString *)ser_id FileName:(NSString *)fileName lossyerror:(CGFloat)loss callBack:(IHFMResponseBack)response
{

    
    NSString *urlStr = [NSString stringWithFormat:@"%@/getCompressedData?patientId=%@&studyId=%@&seriesId=%@&file=%@&lossyerror=%f",image2DURL,p_id,stu_id,ser_id,fileName,loss];
    
    [[self getNet_PictureManager]  GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (!response) return ;
        
        NSDictionary *httpHeadDic = [operation.response allHeaderFields];
        NSString *imgInfo = httpHeadDic[@"imageInfo"];
        if ([imgInfo isEqualToString:@"Error"]) {
            NSString *errorStr = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            response ([NSNumber numberWithBool:NO] , errorStr);
        }else
        {
            response ([NSNumber numberWithBool:YES] , @[responseObject,imgInfo]);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (response) {
            response ([NSNumber numberWithBool:NO],@"shiabi");
        }
    }];
   
}

+ (AFHTTPRequestOperationManager *)getNet_PictureManager
{
    AFHTTPRequestOperationManager *imgReqManager = [AFHTTPRequestOperationManager manager];
    imgReqManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects: @"image/png", nil];
    imgReqManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return imgReqManager;
}


+ (AFHTTPRequestOperation *)getJPEGLSPictrueDataFor2DPatientID:(NSString *)p_id studyID:(NSString *)stu_id seriesID:(NSString *)ser_id FileName:(NSString *)fileName lossyerror:(CGFloat)loss callBack:(IHFMResponseBack)response
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/getCompressedData?patientId=%@&studyId=%@&seriesId=%@&file=%@&lossyerror=%f",image2DURL,p_id,stu_id,ser_id,fileName,loss];

    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects: @"image/png", nil];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    operation.name = fileName;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!response) return ;
        
        NSDictionary *httpHeadDic = [operation.response allHeaderFields];
        NSString *imgInfo = httpHeadDic[@"imageInfo"];
        if ([imgInfo isEqualToString:@"Error"]) {
            NSString *errorStr = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            response ([NSNumber numberWithBool:NO] , @"shibai");
        }else
        {
            if (!imgInfo) {
                response ([NSNumber numberWithBool:NO] , @"shibai");
            }else
            {
                response ([NSNumber numberWithBool:YES] , @[responseObject,imgInfo]);
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (response) {
            response ([NSNumber numberWithBool:NO] ,@"shibai" );
            
        }
        
    }];
    return operation;
}

@end
