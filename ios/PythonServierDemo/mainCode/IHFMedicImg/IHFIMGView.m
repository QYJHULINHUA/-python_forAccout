//
//  IHFIMGView.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFIMGView.h"


@implementation IHFIMGView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _reqClass = [[IHFMedicImgReq alloc] init];
        [self addObserverFor2DImgPicturestatus:_reqClass.imgStatus];
        _reqClass.medicImgMainView = self;
        
        _errImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _errImageView.hidden = YES;
        [self addSubview:_errImageView];
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        progressLabel.textColor = [UIColor greenColor];
        [self addSubview:progressLabel];
    }
    return self;
}
- (void)configPatientModel:(IHFPatientModel *)model
{
    _reqClass.patientModel = model;
    __weak typeof(self) weakSelf = self;
    [_reqClass getseriesInfoCallBack:^(BOOL success) {
        [weakSelf.reqClass reqPictureData:0 isMove:NO callBack:^(int success, id response) {
            [weakSelf handleOfcallBack:success data:response pictureIdx:0];
        }];
    }];
}

- (void)addObserverFor2DImgPicturestatus:(IHF2DImgPictureStatu *)pictatus
{
    [pictatus addObserver:self forKeyPath:@"pictureNum" options:NSKeyValueObservingOptionOld context:NULL];
    [pictatus addObserver:self forKeyPath:@"haveDownload" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    IHF2DImgPictureStatu *status = object;
    if (!status || status.pictureNum < 0)
    {
        NSLog(@"fuck how way u running-----------");
        
        return;
    }
    
    if (status.haveDownload) {
        
    }else
    {
        CGFloat ratt = 100 * (CGFloat)status.pictureNum * 1.00/ (CGFloat)status.pictureTotal;
        NSString *rate = [NSString stringWithFormat:@"%0.1f%%",ratt];
        progressLabel.text = rate;
    }
}

- (void)reqImg:(CGFloat)sliadeValue
{
    NSInteger idx = (_reqClass.patientModel.imagenum.integerValue - 1)* sliadeValue;
    __weak typeof(self) weakSelf = self;
    [_reqClass reqPictureData:idx isMove:NO callBack:^(int success, id response) {
        [weakSelf handleOfcallBack:success data:response pictureIdx:idx];
    }];
    
}

- (void)dealloc
{
    [self.reqClass.imgStatus removeObserver:self forKeyPath:@"pictureNum"];
    [self.reqClass.imgStatus removeObserver:self forKeyPath:@"haveDownload"];
}

/*!
 *  @hulinhua 改变图像尺寸
 *  @brief 略
 */
float space_Mark = 1.0;
- (void)handleOfcallBack:(int)success data:(id)response pictureIdx:(NSInteger)idx
{
    
    _currentPicIdx = idx;
    if (success < 0) {
        [self reqErrorWithErrorCode:success withData:response];
    }else
    {
        self.errImageView.hidden = YES;
        GLES_ImageData *image = [GLES_ImageData GLESWihtImageDataInfo:response];
        self.currentImg = image;
        IHFImgAttribute_Model *model = [self.reqClass.sopMHDJson getImageAttributeModelForImageIdx:idx];
        if (!model)
        {
            NSLog(@"ERROR:get image Attribute failure");
            return ;
            
        }
        CGFloat spacing_x = model.imgAttribute.space[0];
        CGFloat spacing_y = model.imgAttribute.space[1];
        if (model.imgAttribute.ww == 0) {//如果mhdjons信息中窗宽窗位为空 重新配置窗宽窗位
            IHFMimage_attribute temp = model.imgAttribute;
            temp.ww = image.w_w;
            temp.wl = image.w_l;
            model.imgAttribute = temp;
        }
        
        CGFloat aspect = (image.size.width * (spacing_x == 0 ? 1.0 : spacing_x))  / (image.size.height * (spacing_y == 0 ? 1.0 :spacing_y));
        
        if(self.openGLVC == nil)
        {
            IHFMyGLKViewController *openGLVC = [IHFMyGLKViewController new];
            [openGLVC setImgRealAspect:aspect];
            openGLVC.sourceimageData = image;
            [self addSubview:openGLVC.view];
            [(UIViewController*)_medicImgVC addChildViewController:openGLVC];
            openGLVC.view.frame = self.bounds;
            [openGLVC setWindowLevel:model.imgAttribute.wl WindowWidth:model.imgAttribute.ww];
            [openGLVC setColorTableNumber:0];
            self.openGLVC = openGLVC;
            openGLVC.WLdelegate = self;
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:_openGLVC action:@selector(PanGestHandle:)];
            
            UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:_openGLVC action:@selector(getScaleAndLocation:)];
            [self addGestureRecognizer:pan];
            [self addGestureRecognizer:pinch];
            
            [self insertSubview:openGLVC.view belowSubview:_errImageView];
            
        }else
        {
            if (aspect != space_Mark) {
                [self.openGLVC setNewScale:aspect];
            }
            self.openGLVC.nextImageData = image;
            
        }
        space_Mark = aspect;
        [self imageParamConfig:model];

    }
}

- (void)imageParamConfig:(IHFImgAttribute_Model*)model
{
    // 设置窗宽窗位
    if (!self.openGLVC.isTouchWindow) {
        [self.openGLVC setWindowLevel:model.imgAttribute.wl WindowWidth:model.imgAttribute.ww];
    }
}

- (void)controllerMedicImageViewWithTool:(NSString *)toolName
{
    if (!self.openGLVC) {
        return;
    }
    if ([toolName isEqualToString:@"重置未选中"]) {
        [self reset];
    }else if ([toolName isEqualToString:@"伪彩未选中"])
    {
        
    }
    else if ([toolName isEqualToString:@"向左旋转"])
    {
        [self.openGLVC rotateInverse];
    }
    else if ([toolName isEqualToString:@"向右旋转"])
    {
        [self.openGLVC rotate];
    }
    else if ([toolName isEqualToString:@"水平镜像"])
    {
        [self.openGLVC horizonMirror];
    }
    else if ([toolName isEqualToString:@"垂直镜像"])
    {
        [self.openGLVC verticalMirror];
    }
    else if ([toolName isEqualToString:@"锐化"])
    {
        
    }
    else if ([toolName isEqualToString:@"定位线未选中"])
    {
        
    }
}

- (void)setColorWithIDx:(NSInteger)idx
{
    [_openGLVC setColorTableNumber:idx];
}

- (void)setSharpenValue:(CGFloat )value
{
    [self.openGLVC setCurrentSharpenScale:value];
}

- (void)reset
{
    
    IHFImgAttribute_Model *model = [self.reqClass.sopMHDJson getImageAttributeModelForImageIdx:_currentPicIdx];
    if (!model) {
        NSLog(@"error:重置图片错误，请检查");
        return ;
    }
    CGFloat spacing_x = model.imgAttribute.space[0];
    CGFloat spacing_y = model.imgAttribute.space[1];
    
    
    GLES_ImageData *image = self.currentImg;
    CGFloat aspect = (image.width * (spacing_x == 0 ? 1.0 : spacing_x))  / (image.height * (spacing_y == 0 ? 1.0 :spacing_y));
    
    [_openGLVC.view removeFromSuperview];
    [_openGLVC removeFromParentViewController];
    _openGLVC = nil;
    
    IHFMyGLKViewController *openGLVC = [IHFMyGLKViewController new];
    [openGLVC setImgRealAspect:aspect];
    openGLVC.sourceimageData = image;
    [self addSubview:openGLVC.view];
    [(UIViewController*)_medicImgVC addChildViewController:openGLVC];
    openGLVC.view.frame = self.bounds;
    [openGLVC setWindowLevel:model.imgAttribute.wl WindowWidth:model.imgAttribute.ww];
    [openGLVC setColorTableNumber:0];
    self.openGLVC = openGLVC;
    openGLVC.WLdelegate = self;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:_openGLVC action:@selector(PanGestHandle:)];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:_openGLVC action:@selector(getScaleAndLocation:)];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:pinch];
    [self insertSubview:openGLVC.view belowSubview:_errImageView];

}





- (void)MYGLKViewCurrentWindowLevel:(CGFloat)wl WindowWidth:(CGFloat)ww
{
    
}

- (void)reqErrorWithErrorCode:(NSInteger)code withData:(id)respose
{
    switch (code) {
        case -1:// 未知错误
        {
            UIImage *img = [UIImage imageNamed:@"fail_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
            
        case -2:// 请求错误
            //            NSParameterAssert(nil);
            NSLog(@"请求错误");
            break;
            
        case -3:// 本地无数据
        {
            UIImage *img = [UIImage imageNamed:@"error_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
        case -4:// 本地无数据，图片正在请求过程中
        {
            UIImage *img = [UIImage imageNamed:@"error_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
        case -5:// 本地无数据，图片准备去请求
        {
            UIImage *img = [UIImage imageNamed:@"error_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
        case -6:// 下载失败
        {
            UIImage *img = [UIImage imageNamed:@"fail_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
        case -7:// 本地数据异常（本地本应该存在数据，但取图失败）
        {
            UIImage *img = [UIImage imageNamed:@"fail_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
            
        default:
        {
            UIImage *img = [UIImage imageNamed:@"error_photo"];
            self.errImageView.hidden = NO;
            self.errImageView.image = img;
        }
            break;
    }
    
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
