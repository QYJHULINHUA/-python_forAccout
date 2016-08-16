//
//  IHFMedicImgSeriresInfo.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/16.
//  Copyright © 2016年 linhua hu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "IHFMantleMTL.h"

typedef struct {
    int     imgType;
    float   ww;
    float   wl;
    float   imgLocation[3];
    float   sliceLocation;
    float   space[2];
    float   slope;
    BOOL    reflex;
    BOOL    RGB;
    BOOL    unSigned;
    float   imageOrien[6];
    int     rows;
    int     columns;
    
    
} IHFMimage_attribute;


@interface IHFImgAttribute_Model : IHFMantleMTL

@property (nonatomic ,strong)NSNumber *createtime;
@property (nonatomic ,strong)NSNumber *imageId;
@property (nonatomic ,strong)NSNumber *imageNo;
@property (nonatomic ,strong)NSNumber *seriesId;
@property (nonatomic ,strong)NSNumber *study_id;
@property (nonatomic ,strong)NSNumber *updatetime;
@property (nonatomic ,strong)NSString *imageinstanceUID;
@property (nonatomic ,strong)NSString *image_attribute;
@property (nonatomic ,strong)NSString *positionUID;

@property (nonatomic ,assign)IHFMimage_attribute imgAttribute;

- (void)configImageAttribute;



@end

@interface IHFMedicImgSeriresInfo : NSObject

@property (nonatomic ,copy)NSMutableArray *imageList;

- (IHFImgAttribute_Model*)getImageAttributeModelForImageIdx:(NSInteger)idx;

@end
