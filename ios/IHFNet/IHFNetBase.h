//
//  IHFNetBase.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/3.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define BASEURL @"http://192.168.15.61:8765"

//>!  网络回调
typedef void(^IHFMResponseBack)(NSNumber *success,id response);

//>! 请求成功回调
typedef void(^IHFMReqSuccessBlock)(id responseSuccess);

//>! 请求失败回调
typedef void(^IHFMReqSuccessFailure)(id responseSuccess);


@interface IHFNetBase : NSObject


@property (nonatomic ,assign)NSInteger errorCode;

@property (nonatomic ,copy)NSString *errorMsg;

@end
