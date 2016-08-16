//
//  YX_ReqModel.m
//  yingxiangliuchen
//
//  Created by ihefe－hulinhua on 16/7/20.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "YX_ReqModel.h"

@implementation YX_ReqModel

@end




@implementation YX_ReqModel_login

+(instancetype)getShareInstance
{
    static YX_ReqModel_login *instace = nil;
    if (!instace) {
        instace = [YX_ReqModel_login new];
    }
    return instace;
}

@end

@implementation YX_ReqModel_RisData

+(instancetype)getShareInstance
{
    static YX_ReqModel_RisData *instace = nil;
    if (!instace) {
        instace = [YX_ReqModel_RisData new];
    }
    return instace;
}

- (void)setRisListDic:(NSDictionary *)risListDic
{
    _risListDic = risListDic;
    _risListArr = risListDic[@"data"];
    _currentP_L_info = _risListArr[0];
    
}

@end