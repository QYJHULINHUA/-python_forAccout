//
//  ViewController.h
//  Simple_Texture2D
//
//  Created by v.q on 15/11/21.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//


#import <GLKit/GLKit.h>
@class GLES_ImageData;
@protocol IHFMyGLKViewControllerDelegate <NSObject>

@optional
- (void)MYGLKViewCurrentWindowLevel:(CGFloat)wl WindowWidth:(CGFloat)ww;

@end

@interface IHFMyGLKViewController : GLKViewController

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END

@property (assign, nonatomic)BOOL isTouchWindow;

@property (weak, nonatomic, nullable) id<IHFMyGLKViewControllerDelegate>WLdelegate;
//@property (weak, nonatomic) IBOutlet UILabel *pixelXLabel;
//@property (weak, nonatomic) IBOutlet UILabel *pixelYlabel;
//@property (weak, nonatomic) IBOutlet UILabel *pixelValueLabel;
//@property (weak, nonatomic) IBOutlet UIButton *measureBtn;
//@property (weak, nonatomic) IBOutlet UILabel *startPointPos;
//@property (weak, nonatomic) IBOutlet UILabel *endPointPos;
//@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//@property (strong, nonatomic, nullable) UIImage *sourceImage;
//@property (strong, nonatomic, nullable) UIImage *nextImage;
@property (strong, nonatomic, nullable) NSData  *dataFromNextImage;
@property (strong, nonatomic, nullable) GLES_ImageData *sourceimageData;
@property (strong, nonatomic, nullable) GLES_ImageData *nextImageData;

@property (nonatomic) CGFloat xAxisScale;
@property (nonatomic) CGFloat yAxisScale;
@property (nonatomic) CGFloat windowLevelMax;
@property (nonatomic) CGFloat windowLevelMin;
@property (nonatomic) CGFloat windowWidthMax;
@property (nonatomic) CGFloat windowWidthMin;
@property (nonatomic) CGFloat wwValue;
@property (nonatomic) CGFloat wlValue;
@property (nonatomic) CGFloat imgRealAspect;   //!< 图片真实高宽比（考虑w和h方向上的pixel spacing）

@property (nonatomic) CGFloat selectPixel;
@property (nonatomic) CGFloat selectedTableNum;
@property (nonatomic) CGPoint pinchCenter;
@property (nonatomic) CGPoint tapCenter;

@property (nonatomic) CGFloat currentScale;

/*!
 *  @brief  设置新的图片尺寸
 *
 *  @param scaleValue 图片尺寸值
 */
- (void)setNewScale:(CGFloat)scaleValue;


- (BOOL)initWindowThreshold:(CGFloat)wwMax WindowWidthMin:(CGFloat)wwMin WindowLevelMax:(CGFloat)wlMax andWindowLevelMin:(CGFloat)wlMin;

/*!
 *  使用数据流设置数据源
 */
- (BOOL)setNextImageData:(NSData * _Nonnull )data Width:(int)width Height:(int)height;

/*!
 *  设置窗宽窗位
 *
 *  @param wl 窗位
 *  @param ww 窗宽
 */
- (BOOL)setWindowLevel:(CGFloat)wl WindowWidth:(CGFloat)ww;

/*!
 *  设置伪彩
 *
 *  @param colortable 0 - 13
 */
- (BOOL)setColorTableNumber:(CGFloat)colortable;

/*!
 *  是否线性差值
 */
- (void)chooseLinearOrNearest:(BOOL)isLinear;

/*!
 *  锐化程度
 *
 *  @param aSharpenScale 1 - 10
 */
- (void)setCurrentSharpenScale:(CGFloat)aSharpenScale;

/*!
 *  双指缩放
 */
- (void)getScaleAndLocation:(nullable UIPinchGestureRecognizer *)pinch;

/*!
 *  双指拖动 单指窗宽窗位
 */
- (void)PanGestHandle:(nullable UIPanGestureRecognizer *)panGes;

/*!
 *  传入测量单点，相应图像，计算该点CT值
 */
- (CGFloat)calculateCTValue:(CGPoint)touchPoint FromImage:(nonnull UIImage *)img ByView:(nonnull GLKView *)targetView;

/*!
 *  传入测量数组 图像 计算最大 最小 平均CT
 *
 *  @return 字典{@"maxCT":@"123",@"minCT":@"123",@"averageCT":@"123"}
 */
- (nonnull NSDictionary *)calculateArrayCTValue:(nonnull NSArray *)pointArray FromImage:(nonnull UIImage *)img ByView:(nonnull GLKView *)targetView;

/*!
 *  传入图像 中心点 半径 获取平均CT
 */
- (nonnull NSDictionary *)calculateCTaverage:(nonnull UIImage *)img CenterPoint:(CGPoint)point Raduis:(int)radius GlkView:(nonnull GLKView *)view;

/*!
 *  传入View上的点 返回图像上的真实点
 */
- (CGPoint)MYGLKRealPointWithViewPoint:(CGPoint)point;

/*!
 *  传入图像上的真实点 返回View上的点
 */
- (CGPoint)MYGLKViewPointWithRealPoint:(CGPoint)realPoint;

/*!
 *  根据放大中心和放大倍数 缩放并平移图像
 */
- (void)transformWithCenter:(CGPoint)center Scale:(CGFloat)scale isTransform:(BOOL)isTransform;

/*!
 *  旋转90度
 */
- (void)rotate;

/*!
 *  逆向旋转90度
 */
- (void)rotateInverse;

/*!
 *  水平镜像
 */
- (void)horizonMirror;

/*!
 *  垂直镜像
 */
- (void)verticalMirror;

/**
 *  图像值有符号类型还是无符号类型
 *
 *  @param isSinged YES代表有符号类型，NO代表无符号类型
 */
- (void)setPictureValueSigned:(BOOL)isSinged;
@end
