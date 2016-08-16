//
//  IHFMedicImgReq.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMedicImgReq.h"

#import "IHFIMGView.h"



@implementation IHFMedicImgReq
- (id)init
{
    self = [super init];
    if (self) {
        _sopMHDJson = [[IHFMedicImgSeriresInfo alloc] init];
        _imgStatus = [[IHF2DImgPictureStatu alloc] init];
        _Img2DReqInterface = [[IHFGetImg2D alloc] init];
    }
    return self;
}

- (void)getseriesInfoCallBack:(successCallBack_Block)isSuccess
{
    [self setPatientInfo];
    __weak typeof(self) weakSelf = self;
    [YX_Net getImageListAndAttribute:_patientModel.seriesId callBack:^(NSNumber *success, id response) {
        if (success.boolValue) {
            NSArray *imgAttributeArr = response;
            weakSelf.sopMHDJson.imageList = [NSMutableArray arrayWithArray:imgAttributeArr];
            weakSelf.Img2DReqInterface.dacmArr = self.sopMHDJson.imageList;
            weakSelf.Img2DReqInterface.pInfo = weakSelf.patientModel;
            isSuccess (YES);
        }else
        {
            isSuccess (NO);
        }
    }];
    
}

- (void)setPatientInfo
{
    _imgStatus.seriesName       = _patientModel.seriesinstanceuid;
    _imgStatus.pictureTotal     = _patientModel.imagenum.integerValue;
    _Img2DReqInterface.picStaus = _imgStatus;
 
}


- (int)reqPictureData:(NSInteger)idx isMove:(BOOL)move callBack:(IMG_responseBack)response
{
    return [_Img2DReqInterface req2DImage:idx isMoveing:move result:^(NSNumber * _Nullable CBcode, id  _Nullable data, id  _Nullable msg) {
        if (!msg) {
            msg = @"error";
        }
        response (CBcode.intValue,@[data,msg]);
        
    }];
    
}

- (void)dealloc
{
    [_Img2DReqInterface invalidate];
    _Img2DReqInterface = nil;
}



@end
