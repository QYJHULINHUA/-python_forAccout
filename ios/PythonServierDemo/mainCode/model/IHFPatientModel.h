//
//  IHFPatientModel.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHFPatientModel : NSObject

@property (nonatomic ,copy)NSDictionary *stuDic;
@property (nonatomic ,copy)NSDictionary *seriesDic;

@property (nonatomic ,copy)NSString *patientid;
@property (nonatomic ,copy)NSString *relatetopacs;
@property (nonatomic ,copy)NSString *py;
@property (nonatomic ,copy)NSNumber *stu_id;
@property (nonatomic ,copy)NSString *studyid;

@property (nonatomic ,copy)NSNumber *imagenum;
@property (nonatomic ,copy)NSString *modality;
@property (nonatomic ,copy)NSNumber *seriesId;
@property (nonatomic ,copy)NSString *seriesinstanceuid;


@end
