//
//  IHFMedicImgReq.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHFPatientModel.h"
#import "IHFMedicImgSeriresInfo.h"
#import "IHF2DImgPictureStatu.h"
#import "IHFGetImg2D.h"
#import "YX_Net.h"

typedef void (^successCallBack_Block)(BOOL success);

@class IHFIMGView;

@interface IHFMedicImgReq : NSObject

@property (nonatomic , weak)IHFIMGView *medicImgMainView;

@property (nonatomic , strong)IHFMedicImgSeriresInfo *sopMHDJson;

@property (nonatomic  , copy)IHFPatientModel *patientModel;

- (void)getseriesInfoCallBack:(successCallBack_Block)isSuccess;

@property (nonatomic , strong) IHF2DImgPictureStatu *imgStatus;

@property (nonatomic , strong)IHFGetImg2D *Img2DReqInterface;

- (int)reqPictureData:(NSInteger)idx isMove:(BOOL)move callBack:(IMG_responseBack)response;



@end
