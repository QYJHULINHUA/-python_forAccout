//
//  IHFMAccountData.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/2.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHFMAccountData : NSObject

+(instancetype)shareInstance;

@property(nonatomic,copy)NSString *accessToken;
@property(nonatomic,copy)NSString *userright;
@property(nonatomic,copy)NSString *useruid;

- (void)setLoginData:(NSDictionary*)loginData;

@end
