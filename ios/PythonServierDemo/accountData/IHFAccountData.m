//
//  IHFAccountData.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/8.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFAccountData.h"

@implementation IHFAccountData

+ (instancetype)getShareSingle
{
    static IHFAccountData *accont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accont = [[IHFAccountData alloc] init];
    });
    return accont;
}

@end
