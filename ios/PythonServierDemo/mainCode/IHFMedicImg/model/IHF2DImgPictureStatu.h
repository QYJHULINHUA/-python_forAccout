//
//  IHF2DImgPictureStatu.h
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/4/21.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHF2DImgPictureStatu : NSObject

/*!
 *  @author hulinhua, 16-04-21 10:04:00
 *
 *  @brief seresID
 */
@property (nonatomic , strong)NSString *seriesName;

@property (nonatomic , assign)BOOL haveDownload; // default NO

@property (nonatomic , assign)NSInteger pictureNum;

@property (nonatomic , assign)NSInteger pictureTotal;

@end
