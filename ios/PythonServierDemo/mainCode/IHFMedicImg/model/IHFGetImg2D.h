//
//  IHFGetImg2D.h
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/14.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IHFPatientModel.h"
#import "IHF2DImgPictureStatu.h"


typedef NS_ENUM(NSInteger, MD2D_ImgStatuCode) {
    
    
    MDErrorUnknown     = -1, // 未知错误
    
    MDErrorReq         = -2, // 请求错误
    
    MDErrorLocal       = -3, // 本地无数据,不处理
    
    MDErrorReqIng      = -4, // 本地无数据，图片正在请求过程中
    
    MDErrorWillReq     = -5, // 本地无数据，图片准备去请求
    
    MDErrorNet         = -6, // 下载失败
    
    MDErrorLocalabnormal = -7, // 本地数据异常（本地本应该存在数据，但取图失败）
    
    MDSuccess          = 1,  // 图片请求成功
    
    MDSuccessLossy     = 2,  // 图片请求成，有损
    
    
};



/** CBcode == MD2D_ImgStatuCode */
typedef void(^IHF2DImgCallback)(NSNumber * __nullable CBcode,id __nullable data,id __nullable msg);

#define OperationMaxCount 2 //最大并发数目
#define OperaQueueMax 4     //线程池最大数目
#define String_Null @"defatult_null"


/*!
 *! 移动影像2D图片请求控制
 */
@interface IHFGetImg2D : NSObject
{
    
    __block IHF2DImgCallback RTCallBack;// 实时的临时最新的图片回调容器，可空！！
    
    __block NSString         *RTFileName;/*!实时的临时最新的图片回调容器名 */
    
    __block int              cacheQueueBeg_idx;/*! 从第几个开始缓存 default 0*/
    
    BOOL invalidate;  // default NO
    
    NSString *downloadseiresID;
    
    BOOL initMark;
}

/*!
 *  @brief 压缩率
 */
@property (nonatomic , assign)CGFloat lossRate;

@property (nonatomic , copy ,nullable) NSArray *dacmArr;


@property (nonatomic , strong , nonnull)IHF2DImgPictureStatu *picStaus;

/*!
 @param patientID 病人号
 */
@property (nonatomic , strong, readonly,nullable)NSString *patientID;

/*!
 @param studyID 检查号
 */
@property (nonatomic , strong, readonly, nullable)NSString *studyID;

/*!
 @param seriesID 系列号
 */
@property (nonatomic , strong, readonly, nullable)NSString *seriesID;

/*!
 *  @brief modity
 */
@property (nonatomic , strong , nullable)NSString *modity;

/*!
 @param dicFileNameArray dcm文件数组
 */
@property (nonatomic , strong, readonly, nullable)NSArray  *dicFileNameArray;

/*!
 @param filePaht 服务器dcm文件路径
 */
@property (nonatomic , strong, readonly, nullable)NSString *filePaht;

/*!
 @param image2DCacheQueue 2d图片缓存队列池
 */
@property (nonatomic , strong, readonly, nonnull)NSOperationQueue *image2DCacheQueue;

/*!
 @param imageCacheArray 要缓存的图片容器
 */
@property (nonatomic , strong, readonly, nullable)__block NSMutableArray  *imageCacheArray;

/*!
 @param pInfo 系列信息
 */
@property (nonatomic , strong, nullable)IHFPatientModel *pInfo;


/*!
 *  @author hulinhua, 16-04-20 15:04:26
 *
 *  @brief 请求2d图片
 *
 *  @param picIdx   第几张图片（从0开始，跟滑动条一致）
 *  @param Lossy    图片有损率（0～100）
 *  @param isMove   请求图片是否为移动中
 *  @param response 请求回调快
 *
 *  @return MD2D_ImgStatuCode
 */
- (MD2D_ImgStatuCode)req2DImage:(NSInteger)picIdx
        isMoveing:(BOOL)isMove
           result:(_Nullable IHF2DImgCallback)response;

/*!
 @ 使无效，退出时务必调用，不然主动缓存不会停止！
 */
- (void)invalidate;

@end


