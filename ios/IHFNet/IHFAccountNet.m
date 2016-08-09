//
//  IHFAccountNet.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/3.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFAccountNet.h"

@implementation IHFAccountNet

+ (NSURLSessionTask*)registeredAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack
{

    NSURLSessionTask *task = [self getSessionTask:@"1001" param:param completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            callBack ([NSNumber numberWithBool:NO],@"网络连接异常");
        }else
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([str isEqual: @""]|| str == nil || [str isKindOfClass:[NSNull class]]) {
                str = @"注册失败";
            }
            if ([str isEqualToString:@"注册成功"]) {
                callBack ([NSNumber numberWithBool:YES],@"注册成功");
            }
            else
            {
                callBack ([NSNumber numberWithBool:NO],str);
            }
        }
    }];
    [task resume];
    return task;
}

+ (NSURLSessionTask*)loginAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack
{
    NSURLSessionTask *task = [self getSessionTask:@"1002" param:param completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            callBack([NSNumber numberWithBool:NO],@"链接网络异常");
        }else
        {
            NSError *err = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (!dic) {
                callBack([NSNumber numberWithBool:NO],@"登录失败");
            }else
            {
                NSString *status = dic[@"status"];
                if (status.integerValue < 0) {
                    NSString *errStr = dic[@"data"];
                    callBack([NSNumber numberWithBool:NO],errStr);
                }else
                {
                    callBack([NSNumber numberWithBool:YES],dic[@"data"]);
                }
            }
            
        }
    }];
    [task resume];
    return task;
    
}

+ (NSURLSessionTask *)changePasswordAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack
{
    NSURLSessionTask *task = [self getSessionTask:@"1003" param:param completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            callBack([NSNumber numberWithBool:NO],@"链接网络异常");
        }else
        {
            NSError *err = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (!dic) {
                callBack([NSNumber numberWithBool:NO],@"修改密码失败");
            }else
            {
                NSString *status = dic[@"status"];
                if (status.integerValue < 0) {
                    NSString *errStr = dic[@"data"];
                    callBack([NSNumber numberWithBool:NO],errStr);
                }else
                {
                    callBack([NSNumber numberWithBool:YES],dic[@"data"]);
                }
            }
            
        }
    }];
    [task resume];
    return task;
    
}

+ (NSURLSessionTask *)validationEmailAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack
{
    NSURLSessionTask *task = [self getSessionTask:@"1004" param:param completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            callBack([NSNumber numberWithBool:NO],@"链接网络异常");
        }else
        {
            NSError *err = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (!dic) {
                callBack([NSNumber numberWithBool:NO],@"登录失败");
            }else
            {
                NSString *status = dic[@"stauts"];
                if (status.integerValue < 0) {
                    NSString *errStr = dic[@"data"];
                    callBack([NSNumber numberWithBool:NO],errStr);
                }else
                {
                    callBack([NSNumber numberWithBool:YES],dic[@"data"]);
                }
            }
            
        }
    }];
    [task resume];
    return task;
    
}

+(NSURLSessionTask*)getSessionTask:(NSString *)apiAction param:(NSDictionary *)param completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASEURL,apiAction]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    if (param) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *data=[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody=data;
    }
    request.HTTPMethod = @"POST";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:completionHandler];
    
    return task;
}


//+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
//{
//    if (jsonString == nil) {
//        return nil;
//    }
//    
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    if(err)
//    {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return dic;
//}

@end

