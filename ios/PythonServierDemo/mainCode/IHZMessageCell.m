//
//  IHZMessageCell.m
//  iChatApp
//
//  Created by 0115 on 16/6/1.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHZMessageCell.h"

@implementation IHZMessageCell

- (void)zcl_prepare
{
    _tagLabel.layer.cornerRadius = _tagLabel.frame.size.width/2;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
