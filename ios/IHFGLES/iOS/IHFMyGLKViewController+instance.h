//
//  IHFMyGLKViewController+instance.h
//  Simple_Texture2D
//
//  Created by v.q on 15/12/20.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "IHFMyGLKViewController.h"

@interface IHFMyGLKViewController (instance)
+ (IHFMyGLKViewController *)initialFromStoryboad:(NSString *)storyboadName withIndentifier:(NSString *)identifier;

+ (IHFMyGLKViewController *)getIHFMyGLKViewController;
@end
