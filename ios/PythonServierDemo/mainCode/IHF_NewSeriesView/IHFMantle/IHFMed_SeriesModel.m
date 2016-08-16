//
//  IHFMed_SeriesModel.m
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/6/12.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHFMed_SeriesModel.h"

@implementation IHFMed_SeriesModel


- (void)setOfflineInfoDic:(NSDictionary *)offlineInfoDic
{
    _offlineInfoDic = offlineInfoDic;
    _studyid = offlineInfoDic[@"studyID"];
    _name = offlineInfoDic[@"name"];
    _py = offlineInfoDic[@"namePY"];
    _seriesId = offlineInfoDic[@"seriesIdx"];
    _seriesinstanceuid = offlineInfoDic[@"seriesID"];
    _modality = offlineInfoDic[@"modality"];
    _exambodypart = offlineInfoDic[@"examBodyPart"];
    _sex = offlineInfoDic[@"sex"];
    _seriestime = offlineInfoDic[@"seriesDate"];
    _patientid = offlineInfoDic[@"patientID"];
    _birthdate = offlineInfoDic[@"patienBirth"];
    NSMutableArray *imgnum = offlineInfoDic[@"imgAttributeArr"];
    _imagenum = [NSNumber numberWithUnsignedInteger:imgnum.count];
    
    
}

@end
