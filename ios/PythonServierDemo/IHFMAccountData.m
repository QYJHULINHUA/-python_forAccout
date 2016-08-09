//
//  IHFMAccountData.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/2.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMAccountData.h"

@implementation IHFMAccountData

+(instancetype)shareInstance
{
    static IHFMAccountData *account = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[IHFMAccountData alloc] init];
    });
    
    return account;
}


- (void)setLoginData:(NSDictionary*)loginData
{
    if (loginData) {
        _accessToken = loginData[@"accessToken"];
        _useruid = loginData[@"useruid"];
        _userright = loginData[@"userright"];
    }
}

@end
