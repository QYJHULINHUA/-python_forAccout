//
//  IHFSharpenView.m
//  IHFMedicImage2.0
//
//  Created by Yoser on 1/5/16.
//  Copyright © 2016 ihefe_hlh. All rights reserved.
//

#define SPACEING 10

#define BLUE_COLOR [UIColor colorWithRed:98.f/255.f green:167.f/255.f blue:217.f/255.f alpha:1]


#define MAXSLIDERValue 5.0f

#import "IHFSharpenView.h"

@interface IHFSharpenView()

@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UILabel *showNumLab;

@end

@implementation IHFSharpenView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:18.f/255.f green:18.f/255.f blue:18.f/255.f alpha:1];
        
        
        CGFloat titleLabW = frame.size.width / 125 * 18;
        CGFloat titleLabH = frame.size.height / 64 * 9;
        
        CGFloat barX = 0;
        CGFloat barY = 0;
        CGFloat barW = frame.size.width;
        CGFloat barH = frame.size.height / 3;
        UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(barX, barY, barW, barH)];
        [titleBar setBackgroundColor:[UIColor colorWithRed:22.f/255.f green:22.f/255.f blue:22.f/255.f alpha:1]];
//        RGBACOLOR(22, 22, 22, 1)
        [self addSubview:titleBar];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabW, titleLabH)];
        titleLab.text = @"锐化";
        titleLab.center = CGPointMake(SPACEING + titleLab.frame.size.width * 0.5f, titleBar.center.y);
        [titleLab setFont:[UIFont systemFontOfSize:18.f]];
        [titleLab setTextColor:[UIColor whiteColor]];
        [self addSubview:titleLab];

        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - SPACEING - titleLabW, titleLab.frame.origin.y, titleLabW, titleLabH)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
        UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - SPACEING * 2, frame.size.width / 10)];
        slider.center = CGPointMake(self.frame.size.width * 0.5f, (self.frame.size.height - titleBar.frame.size.height) * 0.5 + titleBar.frame.size.height);
        slider.value = 0.0f;
        slider.maximumValue = MAXSLIDERValue;
        slider.minimumValue = 0.0f;
        slider.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0f];
        [slider setThumbImage:[UIImage imageNamed:@"controlPoint"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"controlPoint"] forState:UIControlStateHighlighted];
        [slider addTarget:self action:@selector(sliderTouches:) forControlEvents:UIControlEventTouchUpInside];  // 结束滑动
        [slider addTarget:self action:@selector(sliderTouches:) forControlEvents:UIControlEventValueChanged];   // 滑动中
        [slider setTintColor:BLUE_COLOR];
        [self addSubview:slider];
        
        CGFloat numLabH = 15;
        CGFloat numLabW = self.frame.size.width * 0.5f;
        CGFloat numLabX = CGRectGetMaxX(confirmBtn.frame) - numLabW;
        CGFloat numLabY = titleBar.frame.size.height + 10;
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(numLabX, numLabY, numLabW, numLabH)];
        [numLab setFont:[UIFont systemFontOfSize:11]];
        [numLab setTextColor:[UIColor whiteColor]];
        [numLab setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.0f]];
        [numLab setText:@"0/1"];
        [numLab setTextAlignment:NSTextAlignmentRight];
        [self addSubview:numLab];
        self.showNumLab = numLab;
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [titleBar addGestureRecognizer:panGes];
        self.slider = slider;
    }
    return self;
}

- (void)setSharpenValue:(CGFloat)sharpenValue
{
    _sharpenValue = sharpenValue;
    self.slider.value = sharpenValue;
    self.showNumLab.text = [NSString stringWithFormat:@"%.2f/%.2f",sharpenValue,MAXSLIDERValue];
}

/*!
 *  滑动条滚动
 */
- (void)sliderTouches:(UISlider *)slider
{
    _sharpenValue = slider.value;
    _showNumLab.text = [NSString stringWithFormat:@"%.2f/%.2f",slider.value,MAXSLIDERValue];
    if([self.delegate respondsToSelector:@selector(SharpenViewChangeValue:)])
    {
        [self.delegate SharpenViewChangeValue:slider.value];
    }
}

- (void)confirmBtnClick:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    if([self.delegate respondsToSelector:@selector(SharpenViewMoveDelegate:)])
    {
        [self.delegate SharpenViewMoveDelegate:pan];
    }
}


@end
