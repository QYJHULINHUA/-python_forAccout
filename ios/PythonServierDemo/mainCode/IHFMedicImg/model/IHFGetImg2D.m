//
//  IHFGetImg2D.m
//  QY_Net_QueueDemo
//
//  Created by ihefe－hulinhua on 16/4/14.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHFGetImg2D.h"
#import "IHF2DImgManager.h"
#import "IHFJPEGLSClient.h"
#import "IHFMedicImgSeriresInfo.h"
#import "YX_Net.h"
#import "IHFDataDownloadManager.h"


@implementation IHFGetImg2D

- (id)init
{
    self = [super init];
    if (self) {
        _image2DCacheQueue = [[NSOperationQueue alloc] init];
        _image2DCacheQueue.qualityOfService = NSQualityOfServiceBackground;
        [_image2DCacheQueue setMaxConcurrentOperationCount:OperationMaxCount];
        invalidate = NO;
        initMark = NO;

    }
    return self;
}


- (void)setPInfo:(IHFPatientModel *)pInfo
{
    initMark = YES;
    _pInfo = pInfo;
    invalidate = NO;
    if (_image2DCacheQueue.operations.count > 0) {
        [_image2DCacheQueue cancelAllOperations];
//        [[IHFOffLineDownManager getOffLineDownManager] automaticCacheRelease:downloadseiresID];
    }
    
    if (pInfo) {
        RTFileName          = String_Null;
        _patientID          = pInfo.patientid;
        _studyID            = pInfo.studyid;
        _seriesID           = pInfo.seriesinstanceuid;
        _modity             = pInfo.modality;
        NSMutableArray *seriesArr = [NSMutableArray array];
        downloadseiresID = _seriesID;
//        [[IHFOffLineDownManager getOffLineDownManager] automaticCacheRetain:downloadseiresID];
       
        
        for (IHFImgAttribute_Model *model in _dacmArr) {
            [seriesArr addObject:model.imageinstanceUID];
        }
        _dicFileNameArray   = seriesArr;
//        _filePaht           = pInfo.imagepath;
        cacheQueueBeg_idx   = 0;

        if (_dicFileNameArray&&_dicFileNameArray.count > 0) {
            _imageCacheArray = [NSMutableArray arrayWithArray:_dicFileNameArray];
            NSMutableArray *arr = [IHF2DImgManager executeQueryAllFileNameArrayFromStudyID:_studyID seriesID:_seriesID];
            [_imageCacheArray removeObjectsInArray:arr];
            
            if ([IHFDataDownloadManager isExistPicture:_patientID study:_studyID series:_seriesID] == 2) {
                _picStaus.haveDownload = YES;
            }else
            {
                [self autoAddOperation];
                
            }
            
            
        }
    }
}

- (MD2D_ImgStatuCode)req2DImage:(NSInteger)picIdx
        isMoveing:(BOOL)isMove
           result:(_Nullable IHF2DImgCallback)response
{
    if (picIdx > _dicFileNameArray.count  || picIdx < 0) {
        NSLog(@"傻逼,你越界了，我懒的理你!!!");
        response ([NSNumber numberWithInt:MDErrorReq],@"请求越界",nil);
        return MDErrorReq;
        
    }else
    {
        if (isMove)
        {
            return [self movingReq2DImage:picIdx  result:response];
        }else
        {
            return [self moveEndReq2DImage:picIdx result:response];
        }
    }
    
}



/*! 移动中请求图片数据 */
- (MD2D_ImgStatuCode)movingReq2DImage:(NSInteger)picIDX result:(_Nullable IHF2DImgCallback)response
{
    // 从本地取图片
    NSArray *image = [self getImageFromLocation:picIDX];
    if (image) {
        response ([NSNumber numberWithInt:MDSuccess],image[0],image[1]);
        return MDSuccess;
    }else
    {
        NSString *fileName = _dicFileNameArray[picIDX];
        

        if ([_imageCacheArray containsObject:fileName]) {
            response ([NSNumber numberWithInt:MDErrorLocal],@"图片数据无缓存",nil);
            return MDErrorLocal;
        }
        else
        {
            BOOL mark = NO;
            NSArray *opearArray = _image2DCacheQueue.operations;
            for (AFHTTPRequestOperation *op in opearArray) {
                if ([op.name isEqualToString:fileName]) {
                    mark = YES;
                }
            }
            if (mark) {
                //正在下载中
                response ([NSNumber numberWithInt:MDErrorLocal],@"图片数据无缓存",nil);
                return MDErrorLocal;
            }else
            {
                response ([NSNumber numberWithInt:MDErrorUnknown],@"未知错误",nil);
                return MDErrorUnknown;
            }
            
        }
        
    }
}

- (NSArray *)getImageFromLocation:(NSInteger)picIDX
{
    NSString *fileName = _dicFileNameArray[picIDX];
    NSArray *image = [IHF2DImgManager getPngOrJpegFromCache:_patientID stuid:_studyID series:_seriesID sopStr:String_Null ASC_Str:String_Null fileName:fileName];
    return image;
}

/*! 移动结束时请求图片数据 */
- (MD2D_ImgStatuCode)moveEndReq2DImage:(NSInteger)picIDX result:(_Nullable IHF2DImgCallback)responseddd
{
    NSArray *image = [self getImageFromLocation:picIDX];
    
    if (image) {
        responseddd ([NSNumber numberWithInt:MDSuccess],image[0],image[1]);
        return MDSuccess;
        
    }else
    {
        if (_lossRate > 0) {
            return [self geLossyPic:picIDX result:responseddd];
            
        }else
        {
            NSString *fileName = _dicFileNameArray[picIDX];
            if ([_imageCacheArray containsObject:fileName]) {
                // 还没加入到缓存队列,跳跃到指定的图片开始下载，并且调整下载队列顺心
                return [self jumpIntoPicture:fileName result:responseddd];
            }
            else
            {
                // 理应该正在下载中,等待图片加载到客户端，并回调显示
                return [self witeImageCallback:fileName result:responseddd];
            }
        }
    }
    
}


- (MD2D_ImgStatuCode)geLossyPic:(NSInteger)picIdx
                               result:(_Nullable IHF2DImgCallback)responseddd
{
    NSString *fileName = _dicFileNameArray[picIdx];
    __weak typeof(self) weakSelf = self;
    
    [YX_Net getJPEGLSPictrueDataFor2DPatientIDLossyerror:_patientID studyID:_studyID seriesID:_seriesID FileName:fileName lossyerror:_lossRate callBack:^(NSNumber *success, id response) {
        
        if (success.boolValue)
        {
            if (responseddd)
            {
                UIImage *img = [IHFJPEGLSClient getImageFormJPEGLSData:response[0]];
                if (img) {
                    NSString *imgInfostr = response[1];
                    
                    responseddd ([NSNumber numberWithInt:MDSuccessLossy],img,@{@"alternate":imgInfostr});
                }else
                {
                    responseddd ([NSNumber numberWithInt:MDErrorUnknown],@"JPEG_LS 解压失败",nil);
                }
                
            }
                
            
        }
        else
        {
            NSLog(@"下载有损图片失败");
        }
        if (weakSelf.picStaus.pictureNum == 0) {
            weakSelf.picStaus.pictureNum = 1;
        }
        [weakSelf getNoLossPicture:picIdx result:responseddd];
    }];
    
    return MDErrorReqIng;
    
}

- (MD2D_ImgStatuCode)getNoLossPicture:(NSInteger)picIdx
                  result:(_Nullable IHF2DImgCallback)responseddd
{
    
    NSArray *image = [self getImageFromLocation:picIdx];
    
    if (image) {
        responseddd ([NSNumber numberWithInt:MDSuccess],image[0],image[1]);
        return MDSuccess;
        
    }else
    {
        NSString *fileName = _dicFileNameArray[picIdx];
        if ([_imageCacheArray containsObject:fileName]) {
            // 还没加入到缓存队列,跳跃到指定的图片开始下载，并且调整下载队列顺心
            return [self jumpIntoPicture:fileName result:responseddd];
        }
        else
        {
            // 理应该正在下载中,等待图片加载到客户端，并回调显示
            return [self witeImageCallback:fileName result:responseddd];
        }
    }
}

/*! 跳跃下载 */
- (MD2D_ImgStatuCode)jumpIntoPicture:(NSString *)fileName result:(_Nullable IHF2DImgCallback)responseddd
{
    NSUInteger jumpIdx = [_imageCacheArray indexOfObject:fileName];
    cacheQueueBeg_idx = (int)jumpIdx;
    
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperation *op1 = [YX_Net getJPEGLSPictrueDataFor2DPatientID:_patientID studyID:_studyID seriesID:_seriesID FileName:fileName lossyerror:0 callBack:^(NSNumber *success, id response) {
        
        if (success.boolValue) {
            if (responseddd) {
                UIImage *img = [IHFJPEGLSClient getImageFormJPEGLSData:response[0]];
                if (img) {
                    NSString *imgInfostr = response[1];
                    responseddd ([NSNumber numberWithInt:MDSuccess],img,@{@"alternate":imgInfostr});
                }else
                {
                    // 见了鬼了，图片数据解析也能失败；
                    responseddd ([NSNumber numberWithInt:MDErrorUnknown],@"JPEG_LS 解压失败",nil);
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    BOOL saveOK = [IHF2DImgManager savePngOrJpegIntoLocal:_patientID study:_studyID series:_seriesID sopStr:String_Null ASC_Str:String_Null fileName:fileName imgdata:response[0] imageInfo:response[1]];
                    if (!saveOK) {
                        NSLog(@"2d图片 ————数据保存失败，请检查");
                    }
                });
                
            }
            
        }else
        {
            // 下载失败，我也没办法，你看着办吧
//            IHFMNetErrorMsg *err = response;
            responseddd ([NSNumber numberWithInt:MDErrorNet],@"shibai",nil);
        }
        if (weakSelf) {
            [weakSelf autoAddOperation];
        }
        
        
    }];
    op1.queuePriority = NSOperationQueuePriorityVeryHigh; // 让她优先下载本张！！
    [_image2DCacheQueue addOperation:op1];
    [_imageCacheArray removeObjectAtIndex:cacheQueueBeg_idx];
    return MDErrorReqIng;
}

/*! 等待网络图片过来 */
- (MD2D_ImgStatuCode)witeImageCallback:(NSString *)fileName result:(_Nullable IHF2DImgCallback)responseddd
{
    
    NSArray *opearArray = _image2DCacheQueue.operations;
    BOOL isCahce = NO;
    for (AFHTTPRequestOperation *obj in opearArray) {

        if ([fileName isEqualToString:obj.name]) {
            isCahce = YES;
            // 数据已经下载了，但是很抱歉，下载还没关来，也是醉了吧～～哈哈
            RTCallBack = responseddd;
            RTFileName = fileName;
            // 不过没关系哈，在它过来的时候，哥哥会让一个逗比送过去的，
        }
    }
    if (isCahce == NO) {
        NSArray *image = [IHF2DImgManager getPngOrJpegFromCache:_patientID stuid:_studyID series:_seriesID sopStr:String_Null ASC_Str:String_Null fileName:fileName];
        if (image) {
            responseddd ([NSNumber numberWithInt:MDSuccess],image[0],image[1]);
        }else
        {
            // 走到这里应该尝试请求一次
            AFHTTPRequestOperation *op = [self getOperation:fileName];
            [_image2DCacheQueue addOperation:op];
            RTCallBack = responseddd;
            RTFileName = fileName;
        }
    }
    
    return MDErrorReqIng;
}



// 自动缓存
- (void)autoAddOperation
{
    if (invalidate == YES) {
        return ;
    }
    if ([IHFDataDownloadManager isExistPicture:_patientID study:_studyID series:_seriesID] == 2) {
        _picStaus.haveDownload = YES;
        return;
    }
    
    _picStaus.pictureNum = _picStaus.pictureTotal - _imageCacheArray.count - _image2DCacheQueue.operationCount;
    if (_picStaus.pictureNum == _picStaus.pictureTotal && initMark) {
        initMark = NO;
//        [[IHFOffLineDownManager getOffLineDownManager] automaticCacheRelease:downloadseiresID];
    }
        
    NSUInteger j =OperaQueueMax - _image2DCacheQueue.operationCount; // 当前需要加几个并发？
    if (j > _imageCacheArray.count) {
        j = _imageCacheArray.count;
    }
    if (j == 0 ) {
        return;
    }

    NSString *fileName;
    for (int i = 0 ; i < j; i ++) {
        if (cacheQueueBeg_idx >= _imageCacheArray.count) {
            /*! 下载到最后一个了，跳到前面下前面的*/
            cacheQueueBeg_idx = 0;
        }
        fileName = _imageCacheArray[cacheQueueBeg_idx];
        
        AFHTTPRequestOperation *op1 = [self getOperation:fileName];
        
        [_image2DCacheQueue addOperation:op1];
        [_imageCacheArray removeObjectAtIndex:cacheQueueBeg_idx];
        
    }
}

- (AFHTTPRequestOperation *)getOperation:(NSString *)fileName
{
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperation *op1 = [YX_Net getJPEGLSPictrueDataFor2DPatientID:_patientID studyID:_studyID seriesID:_seriesID FileName:fileName lossyerror:0 callBack:^(NSNumber *success, id response) {
        if ([fileName isEqualToString:RTFileName]) {
            
            if (RTCallBack) {
                if (success.boolValue) {
                    UIImage *img = [IHFJPEGLSClient getImageFormJPEGLSData:response[0]];
                    NSString *imgInfostr = response[1];
                    RTCallBack ([NSNumber numberWithInt:MDSuccess],img,@{@"alternate":imgInfostr});
                }else
                {
                    
                    RTCallBack ([NSNumber numberWithInt:MDErrorNet],@"失败",nil);
                }
                RTCallBack = nil;
            }
            
            
        }
        if (success.boolValue) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL saveOK = [IHF2DImgManager savePngOrJpegIntoLocal:_patientID study:_studyID series:_seriesID sopStr:String_Null ASC_Str:String_Null fileName:fileName imgdata:response[0] imageInfo:response[1]];
                if (!saveOK) {
                    NSLog(@"2d图片 ————数据保存失败，请检查");
                }
            });
            
        }else
        {
            
            NSLog(@"自动缓存的数据错误:%@",@"shibai");
        }
        if (weakSelf) {
            [weakSelf autoAddOperation];
        }
        
    }];

    return op1;
}

- (void)invalidate
{
    invalidate = YES;
    if (_image2DCacheQueue.operationCount > 0) {
        [_image2DCacheQueue cancelAllOperations];
//        [[IHFOffLineDownManager getOffLineDownManager] automaticCacheRelease:downloadseiresID];
    }
    
}




@end
