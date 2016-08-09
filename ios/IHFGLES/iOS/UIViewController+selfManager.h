//
//  UIViewController+selfManager.h
//  Simple_Texture2D
//
//  Created by v.q on 15/12/20.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (selfManager)

- (BOOL)installGLK:(UIViewController *)glkVC WithRect:(CGRect)rect;

- (BOOL)installGLK:(UIViewController *)glkVC WithRect:(CGRect)rect ToView:(UIView *)view;

- (BOOL)insertGLK:(UIViewController *)glkVC WithRect:(CGRect)rect ToView:(UIView *)view belowSubview:(UIView *)subView;

- (BOOL)uninstallGLK:(UIViewController *)glkVC;
@end
