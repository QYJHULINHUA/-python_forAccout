//
//  IHFMyGLKViewController+instance.m
//  Simple_Texture2D
//
//  Created by v.q on 15/12/20.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "IHFMyGLKViewController+instance.h"

@implementation IHFMyGLKViewController (instance)
+ (IHFMyGLKViewController *)initialFromStoryboad:(NSString *)storyboadName withIndentifier:(NSString *)identifier
{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:storyboadName bundle:nil];
    IHFMyGLKViewController *myGLKVC = [myStoryboard instantiateViewControllerWithIdentifier:identifier];
    return myGLKVC;
}

+ (IHFMyGLKViewController *)getIHFMyGLKViewController
{
   return [IHFMyGLKViewController initialFromStoryboad:@"Main_iPad" withIndentifier:@"glkvc"];
}
@end
