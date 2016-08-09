//
//  IHFAccountData.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/8.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHFAccountData : NSObject

+ (instancetype)getShareSingle;

@property (nonatomic,copy)NSDictionary *accountInfoDic;

@end
