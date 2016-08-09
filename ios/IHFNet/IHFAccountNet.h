//
//  IHFAccountNet.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/3.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFNetBase.h"

@interface IHFAccountNet : IHFNetBase


+ (NSURLSessionTask*)registeredAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack;

+ (NSURLSessionTask*)loginAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack;

+ (NSURLSessionTask *)changePasswordAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack;


/// 验证邮箱，用于找回密码身份验证
+ (NSURLSessionTask *)validationEmailAPI:(NSDictionary *)param callBack:(IHFMResponseBack)callBack;

@end
