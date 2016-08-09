//
//  UIView+HierarchySupport.h
//  Simple_Texture2D
//
//  Created by v.q on 15/12/21.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class IHFMyGLKViewController;
@interface UIView (HierarchySupport)
- (NSArray *)superviews;
- (BOOL)isAncestorOfView:(UIView *)aView;
- (UIView *)nearestCommonAncestorToView:(UIView *)aView;

- (void)addSubGLViewController:(IHFMyGLKViewController *)glVC InRect:(CGRect)rect InVc:(UIViewController *)vc;

- (void)insertGLViewController:(IHFMyGLKViewController *)glVC belowSubview:(UIView *)view InRet:(CGRect)rect InVc:(UIViewController *)vc;

- (void)removeGLViewController:(IHFMyGLKViewController *)glVC;
@end
