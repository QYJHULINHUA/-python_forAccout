//
//  IHFPatientModel.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFPatientModel.h"

@implementation IHFPatientModel

-(id)copyWithZone:(NSZone *)zone
{
    IHFPatientModel* model = [[self.class alloc]init];
    model.seriesDic = self.seriesDic;
    model.patientid = self.patientid;
    model.relatetopacs = self.relatetopacs;
    model.py = self.py;
    model.stu_id = self.stu_id;
    model.studyid = self.studyid;
    model.imagenum = self.imagenum;
    model.modality = self.modality;
    model.seriesId = self.seriesId;
    model.seriesinstanceuid = self.seriesinstanceuid;
    return model;
}

- (void)setStuDic:(NSDictionary *)stuDic
{
    _stuDic = stuDic;
    _patientid = stuDic[@"patientid"];
    _relatetopacs = stuDic[@"relatetopacs"];
    _py = stuDic[@"py"];
    _stu_id = stuDic[@"stu_id"];
    _studyid = stuDic[@"studyid"];
    
}

- (void)setSeriesDic:(NSDictionary *)seriesDic
{
    _seriesDic = seriesDic;
    
    _imagenum = seriesDic[@"imagenum"];
    _modality = seriesDic[@"modality"];
    _seriesId = seriesDic[@"seriesId"];
    _seriesinstanceuid = seriesDic[@"seriesinstanceuid"];
}


@end
