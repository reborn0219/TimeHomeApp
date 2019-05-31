//
//  SharePresenter.h
//  YouLifeApp
//
//  Created by us on 15/9/8.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BasePresenters.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ShareContentModel : NSObject

@property(nonatomic,assign)SSDKContentType shareType;
@property(nonatomic,copy)NSString * shareContext;
@property(nonatomic,copy)NSString * shareTitle;
@property(nonatomic,copy)NSString * shareUrl;
@property(nonatomic,copy) id  shareImg;
@property(nonatomic,strong)UIView * shareSuperView;
@property(nonatomic,strong)UIViewController * shareSuperVC;
@property(nonatomic,strong) NSArray *shareList;//


/**
 *  0 app下载 1 社区公告 2 社区新闻 3 访客通行 4 帖子 5 活动 6 关于我们 9 新闻分享
 */
@property (nonatomic, assign) NSInteger type;

/**
 来源id
 */
@property (nonatomic, strong) NSString *sourceid;

@end

typedef enum
{
    QQtype,
    WeiXintype,
    ZhiFuBaotype,
    WeiBotype,
    
}thirdPartType;

typedef void(^AcitivityCallBack)(NSInteger isShareSuccess,NSInteger platformType);

@interface SharePresenter : BasePresenters

///shareSDK
+(void)creatShareSDKcontent:(ShareContentModel *) SCML;
+(void)thirdPartLogin:(ShareContentModel *)SCML withType: (thirdPartType)type;

///shareSDK
- (void)creatShareSDKcontent:(ShareContentModel *) SCML withCallBack:(AcitivityCallBack)acitivityCallBack;

+(instancetype)getInstance;
+(void)creatShareSDKPiccontent:(ShareContentModel *)SCML;
@end
