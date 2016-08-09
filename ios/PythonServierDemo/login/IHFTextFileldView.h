//
//  IHFTextFileldView.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/5.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHFTextFileldView : UIView
{
    UITextField *textFiled;
}

@property (nonatomic ,copy)NSString *textFileLabel;

@property (nonatomic ,copy)NSString *placeholderLable;

- (void)resignFirstResponderr;


@end
