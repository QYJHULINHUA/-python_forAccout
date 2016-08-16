//
//  IHFIMGView.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHFMedicImgReq.h"
#import "IHFMyGLKViewController.h"
#import "GLES_ImageData.h"


@class IHFMDicViewController;


@interface IHFIMGView : UIView<IHFMyGLKViewControllerDelegate>
{
    UILabel *progressLabel;
    
    
}

@property(nonatomic ,weak)IHFMDicViewController *medicImgVC;

@property(nonatomic ,weak)UISlider *slider;

@property (nonatomic , strong)IHFMedicImgReq *reqClass;

@property (nonatomic , strong)UIImageView *errImageView;

@property (nonatomic , strong)IHFMyGLKViewController *openGLVC;

@property (nonatomic , strong)GLES_ImageData *currentImg;

@property (nonatomic , assign)NSInteger currentPicIdx;

- (void)configPatientModel:(IHFPatientModel *)model;

- (void)reqImg:(CGFloat)sliadeValue;

- (void)controllerMedicImageViewWithTool:(NSString *)toolName;

- (void)setSharpenValue:(CGFloat )value;

- (void)setColorWithIDx:(NSInteger)idx;



@end
