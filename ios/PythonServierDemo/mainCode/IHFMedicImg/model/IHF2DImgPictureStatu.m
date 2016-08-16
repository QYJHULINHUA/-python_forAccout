//
//  IHF2DImgPictureStatu.m
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/4/21.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHF2DImgPictureStatu.h"

@implementation IHF2DImgPictureStatu

- (id)init
{
    self = [super init];
    if (self) {
        _haveDownload = NO;
        _pictureNum   = 0;
    }
    return self;
}

- (void)dealloc
{

}
@end
