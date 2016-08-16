//
//  YX_ReqModel.h
//  yingxiangliuchen
//
//  Created by ihefe－hulinhua on 16/7/20.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YX_ReqModel : NSObject

@end

@interface YX_ReqModel_login : NSObject

+(instancetype)getShareInstance;

@property (nonatomic,copy)NSString *useruid;
@property (nonatomic,copy)NSString *userright;
@property (nonatomic,copy)NSString *accessToken;


@end

@interface YX_ReqModel_RisData : NSObject

+(instancetype)getShareInstance;

@property (nonatomic,copy)NSDictionary *risListDic;
@property (nonatomic,copy)NSArray *risListArr;
@property (nonatomic,copy)NSDictionary *currentP_L_info;


@end
