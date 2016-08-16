//
//  IHFMedicImgSeriresInfo.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/16.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMedicImgSeriresInfo.h"

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <cmath>
#include <limits>
#include <cstring>

@implementation IHFImgAttribute_Model
- (void)configImageAttribute
{
    if (!_image_attribute) {
        NSLog(@"ERROR:get image_attribute failure");
    }else
    {
        NSData *aa = [_image_attribute dataUsingEncoding:NSISOLatin1StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:aa
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        if (!dic) {
            NSLog(@"ERROR: get image_attribute dictionary failure");
        }else
        {
            NSArray *positionArr = dic[@"00081140"];
            if (positionArr.count > 0) {
                NSDictionary *firstP = positionArr[0];
                _positionUID = firstP[@"00081155"];
            }
            NSString *orienStr = dic[@"0020,0037"];
            if (orienStr) {
                
                NSArray *aArray = [orienStr componentsSeparatedByString:@","];
                for (int i = 0; i < 6; i  ++) {
                    NSString *value = aArray[i];
                    _imgAttribute.imageOrien[i] = value.floatValue;
                }
            }
            
            NSString *rows = dic[@"0028,0010"];
            NSString *clomns = dic[@"0028,0011"];
            if (rows&&clomns) {
                _imgAttribute.rows = rows.intValue;
                _imgAttribute.columns = clomns.intValue;
            }
            
            
            NSString *str3 = dic[@"0020,0032"];//图像位置
            if (str3) {
                NSArray *aArray = [str3 componentsSeparatedByString:@","];
                for (int i = 0; i < 3; i ++) {
                    NSString *value = aArray[i];
                    _imgAttribute.imgLocation[i] = value.floatValue;
                    
                }
            }
            NSString *str4 = dic[@"0020,1041"];//slice location 四角信息中会用到
            if (str4) {
                _imgAttribute.sliceLocation = str4.floatValue;
            }
            NSString *str5 = dic[@"0028,0004"];//MONOCHROME1＝反射，MONOCHROME2＝正常，rgb＝彩色
            if ([str5 isEqualToString:@"MONOCHROME1"]) {
                _imgAttribute.reflex = YES;
            }else
            {
                _imgAttribute.reflex = NO;
            }
            if ([str5 isEqualToString:@"RGB"]) {
                _imgAttribute.RGB = YES;
            }else
            {
                _imgAttribute.RGB = NO;
            }
            NSString *str6 = dic[@"0028,0030"];//space
            if (str6) {
                NSArray *aArray = [str6 componentsSeparatedByString:@","];
                for (int i = 0; i < 2; i ++) {
                    NSString *value = aArray[i];
                    _imgAttribute.space[i] = value.floatValue;
                    
                }
            }
            NSString *str7 = dic[@"0028,0103"];//是否是有符号还是无符号，0是无符号，1有符号
            if (str7) {
                _imgAttribute.unSigned = !str7.boolValue;
                
            }
            NSString *str8 = dic[@"0028,1050"];//窗位
            if (str8) {
                _imgAttribute.wl = str8.floatValue;
            }
            NSString *str9 = dic[@"0028,1051"];//窗宽
            if (str9) {
                _imgAttribute.ww = str9.floatValue;
            }
            //            NSString *str10 = dic[@"0028,1052"];
            NSString *str12 = dic[@"0028,1053"];//斜率
            if (str12) {
                _imgAttribute.slope = str12.floatValue;
            }
        }
    }
}

@end


@implementation IHFMedicImgSeriresInfo

- (void)setImageList:(NSMutableArray *)imageList
{
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in imageList) {
        IHFImgAttribute_Model *model = [IHFImgAttribute_Model new];
        [model dictionaryToModel:dic];
        [model configImageAttribute];
        [modelArr addObject:model];
    }
    _imageList = modelArr;
}

- (IHFImgAttribute_Model*)getImageAttributeModelForImageIdx:(NSInteger)idx
{
    if (idx <= _imageList.count - 1) {
        return _imageList[idx];
    }
    else
    {
        return nil;
    }
    
}

@end
