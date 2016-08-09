//
//  IHFLinearMeasureVIew.m
//  Simple_Texture2D
//
//  Created by v.q on 15/12/17.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "IHFLinearMeasureVIew.h"

@interface IHFLinearMeasureVIew ()
@property (nonatomic,strong) NSMutableArray *movedPointArray;
@property (nonatomic,strong) UIBezierPath *linePath;
@end

@implementation IHFLinearMeasureVIew
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.0];
        self.movedPointArray = [NSMutableArray array];
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestHandle:)];
        panGest.maximumNumberOfTouches = 1;
        panGest.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panGest];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.movedPointArray.count > 1) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetRGBStrokeColor(context, 255.f/255, 0.f, 0.f, 1.0);
        CGContextBeginPath(context);
        CGPoint point = CGPointFromString([self.movedPointArray firstObject]);
        CGContextMoveToPoint(context,point.x, point.y);
        CGPoint pointEnd = CGPointFromString([self.movedPointArray lastObject]);
        CGContextAddLineToPoint(context,pointEnd.x, pointEnd.y);
        CGContextStrokePath(context);
    }
}

- (void)setNeedingClear:(BOOL)aNeedingClear{
    if (aNeedingClear) {
        [self clear];
    }
    _needingClear = aNeedingClear;
}

- (void)panGestHandle:(UIPanGestureRecognizer *)panGest
{
    if (panGest.state == UIGestureRecognizerStateBegan) {
        [self.movedPointArray removeAllObjects];
    }
    CGPoint point = [panGest locationInView:panGest.view];
    [self.movedPointArray addObject:NSStringFromCGPoint(point)];

//    NSString *first = [self.movedPointArray firstObject];
//    NSString *last = [self.movedPointArray lastObject];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMeasureItems"
//                                                       object:[NSArray  arrayWithObjects:first,last,nil]];
    
    [self setNeedsDisplay];
}

- (void)clear
{
    if (self.movedPointArray.count==0) {
        return;
    }
    [self.movedPointArray removeAllObjects];
    [self setNeedsDisplay];
}
@end
