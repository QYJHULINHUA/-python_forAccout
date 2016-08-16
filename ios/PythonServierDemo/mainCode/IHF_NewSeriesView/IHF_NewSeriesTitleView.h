//
//  IHF_NewSeriesTitleView.h
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/24.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHF_NewSeriesTitleView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancel_Btn;

+ (instancetype)getIHF_NewSeriesTitleView;

- (void)addTarget:(id)target action:(SEL)action;
@end
