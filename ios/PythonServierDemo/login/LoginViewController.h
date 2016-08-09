//
//  LoginViewController.h
//  iChat
//
//  Created by ihefe－song on 15/9/9.
//  Copyright (c) 2015年 ihefe29. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *accontView;

@property (weak, nonatomic) IBOutlet UITextField *passwordView;

@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;

- (IBAction)Register:(id)sender;

- (IBAction)forgot:(id)sender;



@end
