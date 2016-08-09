//
//  IHFTextFileldView.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/5.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFTextFileldView.h"

#define MainControlColor [UIColor colorWithRed:48 / 255.0 green:145 / 255.0 blue:251 / 255.0 alpha:1]

@implementation IHFTextFileldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textFiled = [[UITextField alloc] initWithFrame:self.bounds];
        
        
        textFiled.layer.borderWidth = 1.0;
        textFiled.layer.borderColor = MainControlColor.CGColor;
        [textFiled setValue:MainControlColor forKeyPath:@"_placeholderLabel.textColor"];
        [textFiled setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:textFiled];
    }
    return self;
}

- (void)setPlaceholderLable:(NSString *)placeholderLable
{
    textFiled.placeholder = placeholderLable;
}

- (void)resignFirstResponderr
{
    if ([textFiled isFirstResponder]) {
        [textFiled resignFirstResponder];
    }
}

- (void)setTextFileLabel:(NSString *)textFileLabel
{
    textFiled.text = textFileLabel;
}

- (NSString *)textFileLabel
{
    if ([textFiled.text isEqual:@""]) {
        return nil;
    }
    else
    {
        return textFiled.text;
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
