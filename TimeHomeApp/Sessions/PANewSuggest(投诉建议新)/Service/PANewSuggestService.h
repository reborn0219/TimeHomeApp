//
//  PANewSuggestService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PASuggestListModel.h"
#import "PASuggestDetailModel.h"
@interface PANewSuggestService : PABaseRequestService

@property (nonatomic, strong)NSMutableArray *submitedImgArray; //提交完成返回的imageNameArray
@property (nonatomic, strong)NSMutableArray * suggestArray;//投诉列表

@property (nonatomic, strong)PASuggestDetailModel * suggestDetailModel;//投诉详情

/**
 新增投诉建议

 @param contactMobile 联系方式
 @param complaintDetails 投诉内容
 @param attachmentIds 附件列表
 @param success 成功
 @param failed 失败
 */
- (void)submitSuggestWithContactMobile:(NSString *)contactMobile
                      complaintDetails:(NSString *)complaintDetails
                         attachmentIds:(NSArray *)attachmentIds
                               success:(ServiceSuccessBlock)success
                                failed:(ServiceFailedBlock)failed;


/**
 上传图片

 @param images 图片数组
 @param success success description
 @param failed failed description
 */
- (void)uploadImages:(NSArray <UIImage*>*)images
             success:(ServiceSuccessBlock)successed
              failed:(ServiceFailedBlock)failed;

/**
 获取投诉列表

 @param page 页码
 @param successed successed description
 @param failed failed description
 */
- (void)loadSuggestListWithPage:(NSInteger )page
                        success:(ServiceSuccessBlock)successed
                         failed:(ServiceFailedBlock)failed;

/**
 加载投诉建议详情

 @param orderId orderId description
 @param successed successed description
 @param failed failed description
 */
- (void)loadSuggestDetailWithOrderId:(NSString *)orderId
                             success:(ServiceSuccessBlock)successed
                              failed:(ServiceFailedBlock)failed;
@end
