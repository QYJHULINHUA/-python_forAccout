// ViewController.m
//  Simple_Texture2D
//
//  Created by v.q on 15/11/21.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "IHFMyGLKViewController.h"
#include "IHFLinearMeasureVIew.h"
#import "IHFGLESTools.h"
#import "GLES_ImageData.h"

extern void esMain( ESContext *esContext , void *data,GLuint width,GLuint height, UserInfo info);


@interface IHFMyGLKViewController ()<UIGestureRecognizerDelegate>
{
    ESContext _esContext;
}

@property (weak, nonatomic) IBOutlet UISlider *sharpenScaleSlider;
@property (strong, nonatomic) IHFLinearMeasureVIew *measureView;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) NSMutableArray *centerArray;
@property (nonatomic) BOOL isRGB;
@property (nonatomic) BOOL isMeasuring;
@property (nonatomic) BOOL isTransform;
@property (nonatomic) BOOL isSigned;
@property (nonatomic) int  imgWidth;
@property (nonatomic) int  imgHeight;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGPoint pointOffset;
@property (nonatomic) UserInfo myInfo;
@property (strong, nonatomic) UIImage *currentImage;
- (void)setupGL;
- (void)tearDownGL;
@end

@implementation IHFMyGLKViewController

- (instancetype)init
{
    if(self = [super init])
    {
        
        _isTouchWindow = NO;
        self.imgRealAspect = 1.0f;
        self.windowLevelMax = 2048;
        self.windowLevelMin = -1024;
        self.windowWidthMax = 3072;
        self.windowWidthMin = 0;
    }
    return self;
}

#pragma mark - 视图载入时需要做的初始化工作
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _measureView = [[IHFLinearMeasureVIew alloc]initWithFrame:self.view.frame];
//    [self.view insertSubview:_measureView belowSubview:self.measureBtn];
    _measureView.hidden = YES;
    self.isMeasuring = NO;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self initNeededData];
    
    [self setupGL];
    
}

- (BOOL)initWindowThreshold:(CGFloat)wwMax WindowWidthMin:(CGFloat)wwMin WindowLevelMax:(CGFloat)wlMax andWindowLevelMin:(CGFloat)wlMin{
    self.windowLevelMax = wlMax; self.windowLevelMin = wlMin;
    self.windowWidthMax = wwMax; self.windowWidthMin = wwMin;
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setUpMeasureInfo:) name:@"getMeasureItems" object:nil];
}

- (void)initNeededData
{
    [self.sharpenScaleSlider setMaximumValue:1.f];
    [self.sharpenScaleSlider setMinimumValue:0.0f];
    
    self.xAxisScale = 0.7461;
    self.yAxisScale = 0.7461;
    self.wwValue = 1200.0f;
    self.wlValue = -500.0f;
    self.scale = 1.0f;
    self.lastScale = 1.0f;
    self.selectedTableNum = 0.0;
    self.currentScale = 1.0f;
    self.centerArray = [NSMutableArray array];
    
    [self initMyInfoData];
}

- (void)initMyInfoData
{
    _myInfo.isDefault = GL_FALSE;   //0表明非缩放操作，1表示缩放操作
    _myInfo.isSharpen = GL_FALSE;  //未开启锐化，正常的调整窗宽窗位
    _myInfo.isLinear = GL_TRUE;    // 1 进行插值
    _myInfo.scale = self.scale;
    _myInfo.windowLevel = self.wlValue;
    _myInfo.windowWidth = self.wwValue;
    _myInfo.wSpacing = 1.0;
    _myInfo.hSpacing = 1.0;
    if (isnan(self.imgRealAspect)) {
        _myInfo.aspect = 1;
    }
    _myInfo.aspect = self.imgRealAspect;
    _myInfo.x = 0.0f;       //pinch手势中心点的x偏移
    _myInfo.y = 0.0f;       //pinch手势中心点的y偏移
    _myInfo.tableNum = 0.0 ;//选中颜色表序号 0 - 13，请转化为float类型
    _myInfo.gauScale = 0.08; //锐化系数
    _myInfo.region = 5;     //高斯核的大小，为region*region
    _myInfo.sigma = 4;      //高斯核的sigma值
}

#pragma mark - Notification Handler
//- (void)setUpMeasureInfo:(NSNotification *)scence
//{
//    GLKView *view = (GLKView *)self.view;
//    UIImage *img = _sourceimageData.imageData;
//    int width = img.size.width; int height = img.size.height;
//    NSArray *measurePointsArr = [scence object];
//    CGPoint point_start = CGPointFromString((NSString *)[measurePointsArr firstObject]);
//    CGPoint point_end = CGPointFromString((NSString *)[measurePointsArr lastObject]);
//    CGPoint es_start = [IHFGLESTools convertScreenCoordToESCoord:point_start
//                                                       withWidth:view.drawableWidth
//                                                       andHeight:view.drawableHeight];
//    CGPoint es_end = [IHFGLESTools convertScreenCoordToESCoord:point_end
//                                                     withWidth:view.drawableWidth
//                                                     andHeight:view.drawableHeight];
//    MyIndex nIndex = [IHFGLESTools calculateRealPoisitionOfPoint:es_start
//                                                      byUserData:_esContext.userData
//                                                    andImageSize:CGSizeMake(width, height)];
//    MyIndex mIndex = [IHFGLESTools calculateRealPoisitionOfPoint:es_end
//                                                      byUserData:_esContext.userData
//                                                    andImageSize:CGSizeMake(width, height)];
//    float xOffset = mIndex.indexX - nIndex.indexX;
//    float yOffset = mIndex.indexY - nIndex.indexY;
//    float dist = sqrtf(powf(xOffset * self.xAxisScale, 2.0) + powf(self.yAxisScale * yOffset, 2.0));
    
//    [self setUpDistace:dist FromStart:nIndex ToEnd:mIndex];
//}

//- (void)setUpDistace:(float)distance FromStart:(MyIndex)start ToEnd:(MyIndex)end
//{
//    self.distanceLabel.text = [NSString stringWithFormat:@"%.4f",distance];
//    self.startPointPos.text = [NSString stringWithFormat:@"(%d,%d)",start.indexX,start.indexY];
//    self.endPointPos.text = [NSString stringWithFormat:@"(%d,%d)",end.indexX,end.indexY];
//}

#pragma mark - 释放GLES资源
- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    if ( _esContext.shutdownFunc )
    {
        _esContext.shutdownFunc( &_esContext );
    }
}

- (void)dealloc
{
    [self tearDownGL];
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getMeasureItems" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && ([[self view] window] == nil))
    {
        self.view = nil;
        [self tearDownGL];
        if ([EAGLContext currentContext] == self.context)
        {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}

#pragma mark - 初始化GLES上下文
- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    memset( &_esContext, 0, sizeof( _esContext ) );
    [self configCurrentImageInfo:_sourceimageData];
}


- (void)setMyInfoImageAttrubit:(GLES_ImageData*)inputImageData
{
    self.currentImage = inputImageData.imageData;
    _myInfo.isRGB = inputImageData.isRGB;
    _myInfo.is16F = inputImageData.is16F;
    _myInfo.passway = inputImageData.passway;
    _myInfo.isUnsigned = inputImageData.isUnsigned;
    _myInfo.imgW = inputImageData.width;
    _myInfo.imgH = inputImageData.height;
}

// 配置图片数据源信息(第一次图片配置信息)
- (void)configCurrentImageInfo:(GLES_ImageData*)inputImageData
{
    [self setMyInfoImageAttrubit:inputImageData];
    if (inputImageData.bitsPerComponent == 8 || inputImageData.isRGB == YES) {
        
        unsigned char *temp0 = [IHFGLESTools getUbyteImageData:inputImageData.imageData];
        esMain( &_esContext, temp0, inputImageData.width, inputImageData.height, _myInfo);
    }else if (inputImageData.bitsPerComponent == 16)
    {
        float *temp0 = (float *)malloc(sizeof(float)*inputImageData.width*inputImageData.height);
        if (_myInfo.isUnsigned == GL_TRUE) {
            [IHFGLESTools getUnsignFloatData:temp0 FromImage:inputImageData.imageData Width:inputImageData.width Height:inputImageData.height];
        }else
        {
            [IHFGLESTools getFloatData:temp0 FromImage:inputImageData.imageData withWidth:inputImageData.width andHeight:inputImageData.height];
        }
        esMain( &_esContext, temp0, inputImageData.width, inputImageData.height, _myInfo);
        free(temp0);
        temp0 = NULL;
    }
    else
    {
        self.currentImage = nil;
    }
}

// 配置图片数据源信息(切换下一张图片配置信息)
- (void)configNextImageInfo:(GLES_ImageData*)inputImageData
{
    [self setMyInfoImageAttrubit:inputImageData];
    
    if (inputImageData.bitsPerComponent == 8 || inputImageData.isRGB == YES) {
        
        unsigned char *dataPointer = [IHFGLESTools getUbyteImageData:inputImageData.imageData];
        _esContext.drawFunc(&_esContext,_myInfo,dataPointer);
        
    }else if (_nextImageData.bitsPerComponent == 16)
    {
        float *dataPointer = (float *)malloc(sizeof(float)*inputImageData.width*inputImageData.height);
        
        if (_myInfo.isUnsigned == GL_TRUE) {
            [IHFGLESTools getUnsignFloatData:dataPointer FromImage:inputImageData.imageData Width:inputImageData.width Height:inputImageData.height];
        }else
        {
            [IHFGLESTools getFloatData:dataPointer FromImage:inputImageData.imageData withWidth:inputImageData.width andHeight:inputImageData.height];
        }
        
        _esContext.drawFunc( &_esContext,_myInfo, dataPointer);
        free(dataPointer);
        dataPointer = NULL;
    }
    else
    {
        self.currentImage = nil;
    }
}
#pragma mark - 绘制函数
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    _esContext.width = (GLint) view.drawableWidth;
    _esContext.height = (GLuint) view.drawableHeight;
    if (!_esContext.drawFunc) return;
    
    if (_nextImageData != nil)
    {
        [self configNextImageInfo:_nextImageData];
        _nextImageData = nil;
        
        if (_myInfo.newaspect != 0) {
            _myInfo.aspect = _myInfo.newaspect;
        }
        _myInfo.newaspect = 0;
        
    }else
    {
        _esContext.drawFunc( &_esContext,_myInfo, NULL);
    }
    
    if (self.isTransform == YES) {
        _myInfo.x = self.pointOffset.x;
        _myInfo.y = self.pointOffset.y;
        _myInfo.isDefault = GL_TRUE;
        _myInfo.scale = self.scale;
        self.isTransform = NO;
    }
    else{
        self.pointOffset = CGPointZero;
        _myInfo.isDefault = GL_FALSE;
    }
    
    self.scale = 1.0;
    _myInfo.scale = self.scale;
    _myInfo.x = 0.0;
    _myInfo.y = 0.0;
    
    _myInfo.rotateAxis = 0.0;
    _myInfo.rotateAngle = 0.0;
}


#pragma mark - UIGestureRecognizerDelegate 防止pan手势与UISlider的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch.view class] isSubclassOfClass:[UISlider class]]) {
        return NO;
    }else
    {
        return YES;
    }
}

/*
 | a,  b,  0 |
 | c,  d,  0 |
 | tx, ty, 1 |
 */
#pragma mark - 双指缩放
- (void)getScaleAndLocation:(UIPinchGestureRecognizer *)pinch{
    GLKView *view = (GLKView *)self.view;
    if(pinch.state == UIGestureRecognizerStateEnded) {
        self.lastScale = 1.0;
        self.scale = 1.0f;
        [self.centerArray removeAllObjects];
        _myInfo.isDefault = GL_FALSE;
        _myInfo.x = 0.0f;
        _myInfo.y = 0.0f;
        _myInfo.scale = self.scale;
        
        return;
    }
    NSUInteger numOfTouches = pinch.numberOfTouches;
    if ((numOfTouches == 2)&&(pinch.state == UIGestureRecognizerStateChanged))
    {
        self.scale = 1.0 - (self.lastScale - pinch.scale);
        
        CGPoint pointOne = [pinch locationOfTouch:0 inView:pinch.view];
        CGPoint pointTwo = [pinch locationOfTouch:1 inView:pinch.view];
        CGPoint center =
        CGPointMake((pointOne.x + pointTwo.x)/2,
                    (pointOne.y + pointTwo.y)/2);
        
        self.pinchCenter =
        CGPointMake(ScreenScale * 2 * center.x / view.drawableWidth - 1,
                    1 - ScreenScale * 2 * center.y / view.drawableHeight);
        [self.centerArray addObject:NSStringFromCGPoint(self.pinchCenter)];
    }
    
    CGPoint point = CGPointFromString((NSString *)[self.centerArray firstObject]);
    
    _myInfo.isDefault = GL_TRUE;
    _myInfo.x = point.x;
    _myInfo.y = point.y;
    _myInfo.scale = self.scale;
    self.lastScale = pinch.scale;
}

#pragma mark - 单指轻敲获得某点像素值
- (void)tapHandler:(UITapGestureRecognizer *)tapGest
{
    GLKView *targetView = (GLKView *)self.view;
    _myInfo.isDefault = GL_FALSE;
    UIImage *img = _sourceimageData.imageData;
    CGPoint touchPoint = [tapGest locationOfTouch:0 inView:targetView];
    _selectPixel = [self calculateCTValue:touchPoint FromImage:img ByView:targetView];
}

//- (void)setUpPixelDetail:(float)value byX:(int)xPosition andY:(int)yPosition
//{
//    _pixelXLabel.text = [NSString stringWithFormat:@"x = %d",xPosition];
//    _pixelYlabel.text = [NSString stringWithFormat:@"y = %d",yPosition];
//    _pixelValueLabel.text = [NSString stringWithFormat:@"pixel = %.0f",value];
//}

#pragma mark - 单指上下滑动调节窗位，左右滑动调节窗宽
#pragma mark 两指拖曳
static CGPoint startPoint;
static CGPoint currentPoint;
- (void)PanGestHandle:(UIPanGestureRecognizer *)panGes
{
    GLKView *locationView = (GLKView *)self.view;
    _myInfo.isDefault = GL_FALSE;
    if (panGes.numberOfTouches == 1)
    {
        CGPoint velocity = [panGes velocityInView:locationView];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        float slideFactor = 0.1 * slideMult;
        if (self.wlValue <= self.windowLevelMax && self.wlValue >= self.windowLevelMin)
        {
            if (fabs(slideFactor) >= 2.0)
            {
                self.wlValue = self.wlValue - velocity.y * slideFactor ;
            }else
            {
                self.wlValue = self.wlValue - velocity.y * slideFactor * 0.1;
            }
        }
        if (self.wlValue > self.windowLevelMax)
        {
            self.wlValue = self.windowLevelMax;
        }else if (self.wlValue < self.windowLevelMin)
        {
            self.wlValue = self.windowLevelMin;
        }
        
        if (self.wwValue <= self.windowWidthMax && self.wwValue >= self.windowWidthMin)
        {
            if (fabs(slideFactor) >= 2.0)
            {
                self.wwValue = self.wwValue + velocity.x * slideFactor;
            }else
            {
                self.wwValue = self.wwValue + velocity.x * slideFactor * 0.1;
            }
        }
        if (self.wwValue > self.windowWidthMax)
        {
            self.wwValue = self.windowWidthMax;
        }else if (self.wwValue < self.windowWidthMin)
        {
            self.wwValue = self.windowWidthMin;
        }
        
        if([self.WLdelegate respondsToSelector:@selector(MYGLKViewCurrentWindowLevel:WindowWidth:)])
        {
            [self.WLdelegate MYGLKViewCurrentWindowLevel:self.wlValue WindowWidth:self.wwValue];
        }
        
        _myInfo.windowWidth = self.wwValue;
        _myInfo.windowLevel = self.wlValue;
        _isTouchWindow = YES;
    }
    else if (panGes.numberOfTouches == 2 )
    {
        if (panGes.state == UIGestureRecognizerStateBegan || panGes.state == UIGestureRecognizerStatePossible)
        {
            startPoint = [panGes locationInView:panGes.view];
        }
        
        if (panGes.state == UIGestureRecognizerStateChanged)
        {
            currentPoint = [panGes locationInView:panGes.view];
            CGPoint differPoint = CGPointMake(currentPoint.x - startPoint.x, currentPoint.y - startPoint.y);
            
            _myInfo.x =  4 * self.scale * ScreenScale *(differPoint.x) / locationView.drawableWidth ;
            _myInfo.y =  4 * self.scale * ScreenScale *(- differPoint.y) / locationView.drawableHeight ;
            if (_myInfo.x > 1.0 || _myInfo.x <-1.0) {
                _myInfo.x = 0.0;
            }
            if (_myInfo.y > 1.0 || _myInfo.y <-1.0){
                _myInfo.y = 0.0;
            }
            startPoint = currentPoint;
        }
    }
    if (panGes.state == UIGestureRecognizerStateEnded
        || panGes.numberOfTouches == 1)
    {
        _myInfo.x = 0.0; _myInfo.y = 0.0;
        
        currentPoint = CGPointZero;
        
        startPoint = CGPointZero;
    }
}

#pragma mark - 滑动条，用来调整锐化系数
- (IBAction)getSharpenScaleValue:(UISlider *)sender
{
    _myInfo.gauScale = [sender value] ;
}

#pragma mark - 伪彩调整按钮
- (IBAction)selectedColorTable:(UIButton *)sender
{
    ++self.selectedTableNum;
    if (self.selectedTableNum > 14.0) {
        self.selectedTableNum = 0.0;
    }
    _myInfo.tableNum = self.selectedTableNum;
}

#pragma mark - 打开直线测量功能，关闭所有手势操作
- (IBAction)linearMeasure:(UIButton *)sender
{
    self.isMeasuring = !self.isMeasuring;
    _measureView.needingClear = YES;
    _measureView.hidden = self.isMeasuring?NO:YES;
    if (_measureView.hidden == NO) {
        for (UIGestureRecognizer *gest in self.view.gestureRecognizers ) {
            gest.enabled = NO;
        }
    }else{
        for (UIGestureRecognizer *gest in self.view.gestureRecognizers ) {
            gest.enabled = YES;
        }
    }
}

- (IBAction)selectedLinearOrNearest:(UISwitch *)sender
{
    BOOL isLinear = [sender isOn];
    if (isLinear) {
        _myInfo.isLinear = GL_TRUE;
    }else{
        _myInfo.isLinear = GL_FALSE;
    }
}


#pragma mark - 各种set方法
- (BOOL)setWindowLevel:(CGFloat)wl WindowWidth:(CGFloat)ww
{
    self.wlValue = wl;
    self.wwValue = ww;
    _myInfo.windowLevel = self.wlValue;
    _myInfo.windowWidth = self.wwValue;
    
    return YES;
}

- (BOOL)setColorTableNumber:(CGFloat)colortable
{
    self.selectedTableNum = colortable;
    _myInfo.tableNum = self.selectedTableNum;
    return YES;
}

- (void)setSourceimageData:(GLES_ImageData *)sourceimageData
{
    _sourceimageData = sourceimageData;
    
    if(sourceimageData.isUnsigned) _myInfo.isUnsigned = GL_TRUE;
    if(!sourceimageData.isUnsigned) _myInfo.isUnsigned = GL_FALSE;
}

- (void)setNextImageData:(GLES_ImageData *)nextImageData
{
    if(nextImageData != nil)
    {
        _nextImageData = nextImageData;
    }
}

- (void)setDataFromNextImage:(NSData *)dataFromNextImage{
    _dataFromNextImage = dataFromNextImage;
}

- (BOOL)setNextImageData:(NSData *)data Width:(int)width Height:(int)height
{
    if (data == nil) {
        return NO;
    }
    
    self.dataFromNextImage = data;
    self.imgWidth = width;
    self.imgHeight = height;
    
    return YES;
}

- (CGFloat)currentScale{
    UserData *data = _esContext.userData;
    if(data == NULL)
    {
        return 1.0;
    }else
    {
        return data->zoomScale;
    }
}

- (void)setNewScale:(CGFloat)scaleValue
{
    _myInfo.newaspect = scaleValue;
}

- (void)chooseLinearOrNearest:(BOOL)isLinear
{
    if (isLinear) {
        _myInfo.isLinear = GL_TRUE;
    }else{
        _myInfo.isLinear = GL_FALSE;
    }
}

- (void)setCurrentSharpenScale:(CGFloat)aSharpenScale
{
    _myInfo.gauScale = aSharpenScale;
}

#pragma mark - 各种测量方法
- (CGFloat)calculateCTValue:(CGPoint)touchPoint FromImage:(UIImage *)img ByView:(GLKView *)targetView{
    CGPoint tmpPoint = CGPointMake(ScreenScale * 2 * touchPoint.x / targetView.drawableWidth - 1,
                                   1 - ScreenScale * 2 * touchPoint.y / targetView.drawableHeight);
    if(self.currentImage == nil)
    {
        return 0;
    }
    
    int widthLimited = (int) img.size.width;
    int heightLimited = (int) img.size.height;
    MyIndex newIndex =  [IHFGLESTools calculateRealPoisitionOfPoint:tmpPoint byUserData:_esContext.userData andImageSize:img.size];
    if (newIndex.indexX > widthLimited
        || newIndex.indexX < 0
        || newIndex.indexY < 0
        || newIndex.indexY > heightLimited)
    {
        return kImpossibleValue;
    }
    self.selectPixel = [IHFGLESTools getPixelFromImage:img byIndex:newIndex];
//    [self setUpPixelDetail:_selectPixel byX:newIndex.indexX andY:newIndex.indexY];
    return self.selectPixel;
}

//  @return 字典{@"maxCT":@"123",@"minCT":@"123",@"averageCT":@"123"}
- (nonnull NSDictionary *)calculateArrayCTValue:(nonnull NSArray *)pointArray FromImage:(nonnull UIImage *)img ByView:(nonnull GLKView *)targetView
{
    if(self.currentImage == nil)
    {
        return @{@"maxCT":@"0",@"minCT":@"0",@"averageCT":@"0"};
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *pointStr in pointArray) {
        CGPoint point = CGPointFromString(pointStr);
        
        CGPoint es_point = [IHFGLESTools convertScreenCoordToESCoord:point
                                                           withWidth:targetView.drawableWidth
                                                           andHeight:targetView.drawableHeight];
        
        MyIndex index = [IHFGLESTools calculateRealPoisitionOfPoint:es_point byUserData:_esContext.userData andImageSize:img.size];
        
        if(index.indexX >= 0 && index.indexX < img.size.width && index.indexY >= 0 && index.indexY < img.size.height)
        {
            [tempArray addObject:NSStringFromCGPoint(CGPointMake(index.indexX, index.indexY))];
        }
    }
    
    if(tempArray.count == 0)
    {
        return nil;
    }else
    {
        return [IHFGLESTools GLESCalculateArrayCTValue:tempArray FromImage:img];
    }
}

- (NSDictionary *)calculateCTaverage:(UIImage *)img CenterPoint:(CGPoint)point Raduis:(int)radius GlkView:(GLKView *)view
{
    if(self.currentImage == nil)
    {
        return @{@"maxCT":@"0",@"minCT":@"0",@"averageCT":@"0"};
    }
    
    CGPoint newPoint = [self MYGLKRealPointWithViewPoint:point];
    
    return [IHFGLESTools getAveragePixelValue:img Index:(MyIndex){newPoint.x,newPoint.y} withRadius:radius];
}

- (CGPoint)MYGLKRealPointWithViewPoint:(CGPoint)point
{
    if(self.currentImage == nil)
    {
        return CGPointZero;
    }
    
    GLKView *glkView = (GLKView *)self.view;
    CGPoint es_point = [IHFGLESTools convertScreenCoordToESCoord:point
                                                       withWidth:glkView.drawableWidth
                                                       andHeight:glkView.drawableHeight];
    MyIndex index = [IHFGLESTools calculateRealPoisitionOfPoint:es_point byUserData:_esContext.userData andImageSize:self.currentImage.size];
    return CGPointMake(index.indexX, index.indexY);
}

- (CGPoint)MYGLKViewPointWithRealPoint:(CGPoint)realPoint
{
    if(self.currentImage == nil)
    {
        return CGPointZero;
    }
    
    GLKView * glkView = (GLKView *)self.view;
    
    UserData *data = (UserData *)_esContext.userData;
    int width = self.currentImage.size.width;
    int height = self.currentImage.size.height;
    float x = 2 * realPoint.x / width -1;
    float y = 1 - 2 * realPoint.y / height;
    x = data->mvpMat.m[0][0] * x + data->mvpMat.m[1][0] * y + data->mvpMat.m[3][0];
    y = data->mvpMat.m[0][1] * y + data->mvpMat.m[1][1] * y - data->mvpMat.m[3][1];
    
    float viewX = (x + 1) * glkView.drawableWidth / (2 * ScreenScale);
    float viewY = (1 - y) * glkView.drawableHeight / (2 * ScreenScale);
    
    return CGPointMake(viewX, viewY);
}

- (void)transformWithCenter:(CGPoint)center Scale:(CGFloat)scale isTransform:(BOOL)isTransform
{
    if (isTransform == YES) {
        self.pointOffset = center;
        self.scale = scale;
        self.isTransform = YES;
    }
}

- (void)setPictureValueSigned:(BOOL)isSinged{
    self.isSigned = isSinged;
}

- (void)rotate
{
    _myInfo.rotateAngle = -90;
    _myInfo.rotateAxis = 3;
}

- (void)rotateInverse
{
    _myInfo.rotateAngle = 90;
    _myInfo.rotateAxis = 3;
}

- (void)horizonMirror
{
    _myInfo.rotateAngle = 180;
    _myInfo.rotateAxis = 2;
}

- (void)verticalMirror
{
    _myInfo.rotateAngle = 180;
    _myInfo.rotateAxis = 1;
}

@end
