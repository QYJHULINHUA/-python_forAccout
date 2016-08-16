//
//  IHF_SeriesGroup.h
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/28.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHF_SeriesGroup : NSObject
@property (nonatomic, strong) NSArray *seriess;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *modality;
@property (nonatomic, copy) NSString *part;
@property (nonatomic, copy) NSString *stu_id;
@property (nonatomic, copy) NSString *relatetopacs;

@property (nonatomic, copy) NSString *studyInstanceUid;
@property (nonatomic, copy)NSDictionary *stdDic;

@property (nonatomic, assign, getter = isOpened) BOOL opened;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
