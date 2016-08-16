//
//  IHF_SeriesGroup.m
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/28.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHF_SeriesGroup.h"

@implementation IHF_SeriesGroup

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _stdDic = dic;
        _dateTime = [self stringIsNull:dic[@"studydate"]];
        _modality = [self stringIsNull:dic[@"modality"]];
        _part = [self stringIsNull:dic[@"exambodypart"]];
        _stu_id = [self stringIsNull:dic[@"stu_id"]];
        _relatetopacs = [self stringIsNull:dic[@"relatetopacs"]];
        _studyInstanceUid = [self stringIsNull:dic[@"studyInstanceUid"]];
        _opened = NO;
    }
    return self;
}

- (NSString *)stringIsNull:(id)string
{
    
    if (![string isKindOfClass:[NSString class]])
    {
        string = [NSString stringWithFormat:@"%@",string];
    }
    
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return @"";
        
        
    }else
    {
        
        return (NSString *)string;
    }
}



@end
