//
//  IHFMed_SeriesModel.h
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/6/12.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHFMantleMTL.h"
#import <UIKit/UIKit.h>

@interface IHFMed_SeriesModel : IHFMantleMTL


@property (strong, nonatomic) NSString *patientid;
@property (strong, nonatomic) NSString *studyid;
@property (strong, nonatomic) NSString *seriesinstanceuid;

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *birthdate;
@property (strong, nonatomic) NSString *diagnosticdept;
@property (strong, nonatomic) NSString *emergency;
@property (strong, nonatomic) NSString *exambodypart;
@property (strong, nonatomic) NSString *exammethod;
@property (strong, nonatomic) NSString *hospitalid;
@property (strong, nonatomic) NSNumber *imageindex;
@property (strong, nonatomic) NSNumber *imagenum;
@property (strong, nonatomic) NSString *modality;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *py;
@property (strong, nonatomic) NSString *regdate;
@property (strong, nonatomic) NSString *relatetopacs;
@property (strong, nonatomic) NSString *reqdept;
@property (strong, nonatomic) NSString *reqhospital;
@property (strong, nonatomic) NSString *reqpysician;
@property (strong, nonatomic) NSNumber *seriesId;
@property (strong, nonatomic) NSString *seriesdesc;

@property (strong, nonatomic) NSNumber *seriesno;
@property (strong, nonatomic) NSString *seriestime;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *station;
//@property (strong, nonatomic) NSString *stu_id;
//@property (strong, nonatomic) NSString *study_id;
@property (strong, nonatomic) NSString *studyage;

@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSNumber *updatetime;

@property (strong, nonatomic) UIImage *thumbImage;

@property (copy, nonatomic)NSDictionary *offlineInfoDic;
@property (copy, nonatomic)NSDictionary *seriesDic;


@end
