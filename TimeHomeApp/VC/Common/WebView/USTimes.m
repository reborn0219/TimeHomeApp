//
//  USTimes.m
//  TimeHomeApp
//
//  Created by us on 16/4/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "USTimes.h"
#import "PublishPostVC.h"
#import "SharePresenter.h"
#import "PersonalDataVC.h"
#import "MyFollowVC.h"
#import "MyFansVC.h"
#import "SysPresenter.h"
#import "CommunityManagerPresenters.h"

@implementation USTimes
/**
 跳转商城
 */
- (void)gotoShopWebView {
    [self.webVC gotoShopWebView];
}
/**
 支付宝支付
 */
- (void)jumpToAliPay:(id)param {
    [self.webVC jumpToAliPay:param];
}

/**
 隐藏或显示右上角分享按钮
 */
- (void)hiddenOrShowRightBarButton:(id)param {
    
    [self.webVC hiddenOrShowRightBarButton:param];
    
}

/**
 隐藏或显示右上角分享按钮
 */
- (void)hideNavigationBarHTML:(id)param {
    
    [self.webVC hideNavigationBarHTML:param];
    
}

/**
 复制到剪切板
 */
- (void)pasteMsg:(id)param {
    [self.webVC pasteMsg:param];
}
/**
 更新分享
 */
- (void)updateShareMessage:(id)param {
    [self.webVC updateShareMessage:param];
}
/**
 点赞
 */
- (void)praiseClick:(id)param {
    [self.webVC praiseClick:param];
}
/**
 评论
 */
- (void)commentClick:(id)param {
    [self.webVC commentClick:param];
}

/**
 展示h5弹窗提示
 */
- (void)showH5MsgInfo:(id)param {
    [self.webVC showH5MsgInfo:param];
}
/**
 跳转到微信支付
 */
- (void)jumpToWXPay:(id)param {
    [self.webVC jumpToWXPay:(id)param];
}
/**
 帖子详情举报分享发布
 */
- (void)reportAction:(id)param {
    [self.webVC reportAction:param];
}

/**
 收藏回调
 */
- (void)refreshCollect {
    [self.webVC refreshCollect];
}

/**
 关注回调
 */
- (void)refreshAttention {
    [self.webVC refreshAttention];
}

/**
 编辑发布成功回调
 */
- (void)refreshEdit {
    [self.webVC refreshEdit];
}
/**
 token失效判断
 */
-(void)relogin
{
    [self.webVC relogin];
}

/**
 跳转邻趣首页
 */
- (void)jumpIndexLQ {
    [self.webVC jumpIndexLQ];
}
/**
 点赞列表
 */
- (void)dianzanlist:(id)param {
    [self.webVC dianzanlist:param];
}

/**
 点击放大图片
 */
- (void)showimage:(id)param {
    [self.webVC showimage:param];
}

- (void)sixin:(id)param {
    [self.webVC sixin:param];
}

- (void)shareFromh5:(id)param {
    
    [self.webVC shareFromh5:param];
}


-(void)upLoadImg:(id)param {
    
    [self.webVC upLoadImg:param];
}

-(void)share_posts:(id)param {
    
    NSString * string = param;
    NSArray *array = [string componentsSeparatedByString:@","];
    NSLog(@"---分享帖子数据---%@",array);
    _webVC.sharePostArr = array;
    
}
-(void)setTitle:(id)param {
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"title-----%@",param);
       selfWeak.webVC.navigationItem.title = param;
    });
    
}
-(float)getKeyBoardHeight {
//    alert(@"getKeyBoardHeight", @"ok");
    NSString * model = [[UITextInputMode currentInputMode] primaryLanguage];
    
    NSLog(@"------getKeyBoardHeight--------%@-",model);
    
    return 240.0f;
}
-(void)delpost:(id)param {
    
    NSLog(@"param-帖子删除--:%@",param);
}
-(void)checkfollow:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"param---:%@",param);
        NSString * string = param;
        NSArray *array = [string componentsSeparatedByString:@","];

        if (array.count>=2) {
            NSString * str_1 = [array firstObject];
            NSString * str_2 = [array objectAtIndex:1];
            NSString * type = [str_1 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSString * topicID = [str_2 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"checkfollow" object:@{topicID:type}];
        }
    });
    
}
#pragma mark - 跳转发布帖子页面
-(void)pubpost:(id)param {

    dispatch_async(dispatch_get_main_queue(), ^{
        
//        AppDelegate * appdelegate = GetAppDelegates;

        PublishPostVC * ppVC =[[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PublishPostVC"];
        ppVC.navigationItem.title = self.webVC.title;
        ppVC.topicID = param;
        [self.webVC.navigationController pushViewController:ppVC animated:YES];
        NSLog(@"参数=====%@",param);
        
        
    });
}


-(void)addinte:(id)param {
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"积分参数==0新闻 1评论===%@",param);
        NSString * tempStr = param;
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
        [selfWeak.webVC showToastMsg:[NSString stringWithFormat:@"恭喜首次贴子评论成功，增加%@积分！",tempStr] Duration:4.0f];
    });
    
    
}
-(void)showpersonal:(id)param {
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"详细资料参数=====%@",param);
       
        NSString * tempStr = param;
        
        NSString * userid = [tempStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
    //    if ([userid isEqualToString:tempID]) {
    //        return;
    //    }
        AppDelegate * appDelegate = GetAppDelegates;
        if ([userid isEqualToString:appDelegate.userData.userID]) {
            
            [selfWeak.webVC showToastMsg:@"亲,这是您自己的账号！" Duration:2.5f];
            return;
        }
        PersonalDataVC * pdVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalDataVC"];
        pdVC.userID = userid;
        
        [selfWeak.webVC.navigationController pushViewController:pdVC animated:YES];
    });
    
}
-(void)share:(id)param {
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"分享参数=====%@",param);
        NSString * string = param;
        NSArray *array = [string componentsSeparatedByString:@","];
        
        if (array.count==3) {
            
            NSString * str_1 = [array firstObject];
            NSString * str_2 = [array objectAtIndex:1];
            NSString * str_3 = [array lastObject];
            NSString * shareUrl = [str_1 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSString * content = [str_2 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSString * type = [str_3 stringByReplacingOccurrencesOfString:@"'" withString:@""];
//            if(content.length >20)
//            {
//                content = [content substringToIndex:20];
//            }
           // [self.webVC showToastMsg:otherParam Duration:2.5f];
            ShareContentModel * SCML = [[ShareContentModel alloc]init];
            SCML.shareTitle = @"";
            SCML.shareImg = SHARE_LOGO_IMAGE;
            SCML.shareContext = content;
            SCML.shareUrl= shareUrl;
            SCML.type = type.integerValue;
            SCML.shareSuperView = selfWeak.webVC.view;
            SCML.shareType = SSDKContentTypeWebPage;
    //      SCML.shareType = SSDKContentTypeAuto;
            [SharePresenter creatShareSDKcontent:SCML];
            
        }else if(array.count == 4) {
            
            NSString * str_1 = [array firstObject];
            NSString * str_2 = [array objectAtIndex:1];
            NSString * str_3 = [array objectAtIndex:2];
            NSString * str_4 = [array lastObject];
            NSString * shareUrl = [str_1 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSString * content = [str_2 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSString * type = [str_3 stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSString * picUrl = [str_4 stringByReplacingOccurrencesOfString:@"'" withString:@""];


            // [self.webVC showToastMsg:otherParam Duration:2.5f];
            ShareContentModel * SCML = [[ShareContentModel alloc]init];
            SCML.shareTitle = @"";
            SCML.shareImg = SHARE_LOGO_IMAGE;
            
            if(![XYString isBlankString:picUrl])
            {
                SCML.shareImg = picUrl;
            }
            SCML.shareContext = content;
            SCML.shareUrl= shareUrl;
            SCML.type = type.integerValue;
            SCML.shareSuperView = self.webVC.view;
    //        SCML.shareType = SSDKContentTypeWebPage;
            SCML.shareType = SSDKContentTypeAuto;
            [[SharePresenter getInstance] creatShareSDKcontent:SCML withCallBack:^(NSInteger isShareSuccess, NSInteger platformType) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    JSValue *add = self.webVC.context[@"shareCallBack"];
                    NSLog(@"Func==add: %@", add);
                    NSDictionary *shareDict = @{
                                                @"isSuccess":[NSString stringWithFormat:@"%ld",(long)isShareSuccess],
                                                @"platformType":[NSString stringWithFormat:@"%ld",(long)platformType]
                                                };
                    [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                    
                });
                
            }];

        }
    });
}

-(void)showimg:(id)param {
    ///function:-[USTimes showimg::] line:50 content:放大图片参数=====http://10.0.0.200:88/times/ext/images/2016-04-27/1461748042995.jpg|http://10.0.0.200:88/times/ext/images/2016-04-27/1461753415568.jpg,0

    @WeakObj(self);
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString * string = param;
        
        NSArray *array = [string componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        NSString * imglistStr = [array firstObject];
        
        NSString * typeIndex =  [array lastObject];
        NSArray * imglist = [imglistStr componentsSeparatedByString:@"|"];
        NSLog(@"放大图片参数=====%@",param);
        [selfWeak tapPicture:typeIndex.integerValue  withImgList:imglist];
        
    });
}

-(void)tapPicture :(NSInteger)index withImgList:(NSArray *)imgList {

    NSLog(@"index====%ld",(long)index);
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        selfWeak.webVC.currentIndex = index;
        selfWeak.webVC.imageList = [NSMutableArray  arrayWithArray:imgList];
        
    });
    
    
}
-(void)getversion:(id)param {
    NSLog(@"获取系统版本号：%@",[[UIDevice currentDevice] systemVersion]);
        
}
-(void)fensi:(id)param
{
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        AppDelegate * appdelegate = GetAppDelegates;
        NSDictionary *dict = [XYString getObjectFromJsonString:param];

        ///我的粉丝
        MyFansVC * mfVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"MyFansVC"];
        mfVC.userid = [dict objectForKey:@"userid"];
        mfVC.username = [dict objectForKey:@"nickname"];
        [selfWeak.webVC.navigationController pushViewController:mfVC animated:YES];
        NSLog(@"参数=====%@",param);
        
        
    });
}
-(void)guanzhu:(id)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        AppDelegate * appdelegate = GetAppDelegates;
       
        NSDictionary *dict = [XYString getObjectFromJsonString:param];

        ///关注
        MyFollowVC * mfVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"MyFollowVC"];
        mfVC.userid = [dict objectForKey:@"userid"];
        mfVC.username = [dict objectForKey:@"nickname"];

        [self.webVC.navigationController pushViewController:mfVC animated:YES];
        NSLog(@"参数=====%@",param);
        
        
    });
}
/**
 H5返回App
 */
-(void)popView
{
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.webVC popView];
    });
    
}

-(void)callphone
{
    @WeakObj(self);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.webVC];
        [CommunityManagerPresenters getPropertyPhoneUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                if(resultCode==SucceedCode)
                {
                    
                    NSArray * phoneArr = (NSArray *)data;
                    if (phoneArr.count>0) {
                        NSDictionary * dic = [phoneArr firstObject];
                        NSString * telephone = [dic objectForKey:@"telephone"];
                        
                        if (![XYString isBlankString:telephone]) {
                            
                            [SysPresenter callPhoneStr:telephone withVC:selfWeak.webVC];
                            
                        }else
                        {
                            [AppDelegate showToastMsg:@"暂无物业电话，请您到物业办公楼咨询!"Duration:4.0];
                        }

                    }

                }
                else if(resultCode==FailureCode)
                {
                    [AppDelegate showToastMsg:@"暂无物业电话，请您到物业办公楼咨询!" Duration:5.0];
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {
                    [AppDelegate showToastMsg:@"网络连接失败!"Duration:3.0];
                }
                
            });
            
        }];

      
    });
}
@end
