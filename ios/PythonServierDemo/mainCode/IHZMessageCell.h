//
//  IHZMessageCell.h
//  iChatApp
//
//  Created by 0115 on 16/6/1.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHZMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


- (void)zcl_prepare;

@end
