//
//  IHFSharpenView.h
//  IHFMedicImage2.0
//
//  Created by Yoser on 1/5/16.
//  Copyright © 2016 ihefe_hlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IHFSharpenViewDelegate <NSObject>


- (void)SharpenViewChangeValue:(CGFloat)value;

- (void)SharpenViewMoveDelegate:(UIPanGestureRecognizer *)pan;

@end

@interface IHFSharpenView : UIView

@property (assign, nonatomic) CGFloat sharpenValue;

@property (weak, nonatomic) id<IHFSharpenViewDelegate>delegate;

@end
