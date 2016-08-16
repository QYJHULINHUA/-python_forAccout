//
//  IHFJPEGLSClient.h
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/13.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IHFJPEGLSClient : NSObject

/**!
 @auto hulinhua
 @param data jpeg_ls 的压缩文件
 @return UIImage 解压后并生成的图片
 */
+ (UIImage *)getImageFormJPEGLSData:(NSData *)data;

@end
