//
//  RaiN_VoucherDetailsVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_VoucherDetailsVC.h"
#import "ShakePassageVC.h"
#import "RedPacketPresenters.h"
#import "SharePresenter.h"
#import "RaiN_TheQrCodeAlert.h"
#import "WebViewVC.h"
@interface RaiN_VoucherDetailsVC ()
{
    RaiN_TheQrCodeAlert *alertVC;
}
@end

@implementation RaiN_VoucherDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开门红";
    
    _bgView.layer.cornerRadius = 5.0f;
    _bgView.layer.masksToBounds = YES;
    
    _topImageView.layer.cornerRadius = 34/2;
    _useNowBtn.layer.cornerRadius = 5.0f;
    
    _leftLittleView.layer.cornerRadius = 5.0f;
    _rightLittleView.layer.cornerRadius = 5.0f;
    [self deleteVC];
    [self createDataSource];
    
    
    [self createRightBarButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    if (SCREEN_HEIGHT >= 812) {
//        _bgViewToBottom.constant = bottomSafeArea_Height + 10;
//    }else {
//        _bgViewToBottom.constant = 10;
//    }
}

- (void)createRightBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    
    UIImage *image = [UIImage imageNamed:@"红包详情分享"];
    [button setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(RightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = backButton;
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self createDataSource];
}
#pragma mark ----- 数据
- (void)createDataSource {
    
    [_useNowBtn setHidden:YES];

    if (_pushTag != 2) {
        ///顶部小图
    

        [_topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"merchantlogo"]]] placeholderImage:PLACEHOLDER_IMAGE];
        _topTitleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"productname"]];
        ///中间大图
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"pic"]]] placeholderImage:PLACEHOLDER_IMAGE];
        _centerMoneyLabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"ticketname"]];
        ///使用条件
        _conditionsLabel.text = [NSString stringWithFormat:@"使用条件：%@",_dataSource[0][@"ticketinfo"][@"usecondition"]];
        ///使用时间
        _timeLabel.text = [NSString stringWithFormat:@"使用条时间：%@",_dataSource[0][@"ticketinfo"][@"usedate"]];
        ///按钮状态
        if ([_dataSource[0][@"ticketinfo"][@"flag"] integerValue] == 1) {
            [_useNowBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            _useNowBtn.backgroundColor = (UIColorFromRGB(0xfe3f3e));
            _useNowBtn.userInteractionEnabled = YES;
        }else if ([_dataSource[0][@"ticketinfo"][@"flag"] integerValue] == 2) {
            [_useNowBtn setTitle:@"已使用" forState:UIControlStateNormal];
            _useNowBtn.backgroundColor = (UIColorFromRGB(0x8a5454));
            _useNowBtn.userInteractionEnabled = NO;
        }else if ([_dataSource[0][@"ticketinfo"][@"flag"] integerValue] == 4) {
            [_useNowBtn setTitle:@"已过期" forState:UIControlStateNormal];
            _useNowBtn.backgroundColor =(UIColorFromRGB(0x8a5454));
            _useNowBtn.userInteractionEnabled = NO;
        }else
        {
            [_useNowBtn setTitle:@"已过期" forState:UIControlStateNormal];
            _useNowBtn.backgroundColor =(UIColorFromRGB(0x8a5454));
            _useNowBtn.userInteractionEnabled = NO;
        }
        
        return;
    }
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [RedPacketPresenters getRedEnvlopeinfoWithUserticketid:_ticketid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode == SucceedCode) {
                //成功
                [_useNowBtn setHidden:NO];

                [selfWeak.nothingnessView setHidden:YES];
                NSDictionary *tempDic = (NSDictionary *)data;
                [_dataSource removeAllObjects];
                _scrollerView.hidden = NO;
                [_dataSource addObject:tempDic];
                
                ///小图
                [_topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"merchantlogo"]]] placeholderImage:PLACEHOLDER_IMAGE];
                ///标题
                _topTitleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"productname"]];
                ///大图
                [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"pic"]]] placeholderImage:PLACEHOLDER_IMAGE];
                ///金钱
                _centerMoneyLabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"ticketname"]];
                
                ///使用说明
                _conditionsLabel.text = [NSString stringWithFormat:@"使用条件：%@",_dataSource[0][@"ticketinfo"][@"usecondition"]];
                
                ///时间
                _timeLabel.text = [NSString stringWithFormat:@"使用时间：%@",[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"usedate"]]];
                ///按钮状态
                if ([_dataSource[0][@"ticketinfo"][@"flag"] integerValue] == 2) {
                    [_useNowBtn setTitle:@"已使用" forState:UIControlStateNormal];
                    _useNowBtn.backgroundColor = (UIColorFromRGB(0x8a5454));
                    _useNowBtn.userInteractionEnabled = NO;
                }else if ([_dataSource[0][@"ticketinfo"][@"flag"] integerValue] == 1) {
                    [_useNowBtn setTitle:@"立即使用" forState:UIControlStateNormal];
                    _useNowBtn.backgroundColor = (UIColorFromRGB(0xfe3f3e));
                    _useNowBtn.userInteractionEnabled = YES;
                }else if ([_dataSource[0][@"ticketinfo"][@"flag"] integerValue] == 4) {
                    [_useNowBtn setTitle:@"已过期" forState:UIControlStateNormal];
                    _useNowBtn.backgroundColor =(UIColorFromRGB(0x8a5454));
                    _useNowBtn.userInteractionEnabled = NO;
                }else
                {
                    [_useNowBtn setTitle:@"已过期" forState:UIControlStateNormal];
                    _useNowBtn.backgroundColor =(UIColorFromRGB(0x8a5454));
                    _useNowBtn.userInteractionEnabled = NO;
                }
                
                
                
            }else {
                //失败
                _scrollerView.hidden = YES;
                [selfWeak.nothingnessView setHidden:NO];
                [selfWeak showNothingnessViewWithType:NoContentTypeNetwork Msg:@"加载失败" eventCallBack:nil];
                [selfWeak.nothingnessView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
        });
    }];
    
    [_useNowBtn setHidden:NO];

}

/**
 删除重复入栈的控制器
 */
- (void)deleteVC {
    NSMutableArray*arrController =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (arrController.count < 4) {
        return;
    }
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrController.count; i++) {
        if ([arrController[i] isKindOfClass:[RaiN_VoucherDetailsVC class]]) {
            [arr1 addObject:arrController[i]];
        }
        
        if ([arrController[i] isKindOfClass:[ShakePassageVC class]]) {
            [arr2 addObject:arrController[i]];
        }
    }
    
    if (arr1.count > 1) {
        for (int i = 0; i < arrController.count; i++){
            if ([arrController[i] isKindOfClass:[RaiN_VoucherDetailsVC class]]) {
                [arrController removeObjectAtIndex:i];
                break;
            }
        }
    }
    if (arr2.count > 1) {
        for (int i = 0; i < arrController.count; i++){
            if ([arrController[i] isKindOfClass:[ShakePassageVC class]]) {
                [arrController removeObjectAtIndex:i];
                break;
            }
        }
    }
    self.navigationController.viewControllers = arrController;
}


#pragma mark ----- 按钮点击事件

/**
 查看更多详情
 */
- (IBAction)checkMoreClick:(id)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    NSString *h5Url = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"couponurl"]];
    NSString *ID = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"id"]];
    AppDelegate *appDlgt = GetAppDelegates;
    if([h5Url hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&id=%@",h5Url,appDlgt.userData.token,ID];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&id=%@",h5Url,appDlgt.userData.token,ID];
    }
    webVc.isGetCurrentTitle = YES;
    webVc.title = @"代金券详情";
    [self.navigationController pushViewController:webVc animated:YES];
}

/**
 立即使用
 */
- (IBAction)useNowClick:(id)sender {
    NSString *qrStr = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"qrurl"]];
    NSString *logoSTr = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"qrurl"]];
    NSDictionary *dic = @{@"qrUrl":qrStr,@"logo":logoSTr};
    alertVC = [RaiN_TheQrCodeAlert shareRaiN_TheQrCodeAlert];
    [alertVC showInVC:self WithData:dic];
}
/**
 分享
 */
- (void)RightButtonClick {
    
    NSString *advid = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"advid"]];
    NSString *ticketid = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"ticketid"]];
    [RedPacketPresenters shareRedEnvelopeWithUserticketid:advid andTicketid:ticketid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode == SucceedCode) {
                //成功
            }else {
                //失败
            }
        });
    }];
    
    ShareContentModel * SCML = [[ShareContentModel alloc]init];
    UIImage *images = [UIImage imageNamed:@"摇摇开门红包分享通用图片"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"sharepic"]]];
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (img != nil) {
                SCML.shareImg = @[img];
            }else {
                SCML.shareImg = @[images];
            }
            [SharePresenter creatShareSDKPiccontent:SCML];
            
            
        });
        
    });
    

}
-(void)subReceivePushMessages:(NSNotification*) aNotification
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(aNotification.object == nil)
        {
            return ;
        }
        
        NSDictionary *dic = [NullPointerUtils toDealWithNullPointer:(NSDictionary *)aNotification.object];
        /** 消息类型 */
        NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if (type.integerValue == 30501) {
            
            NSString * ticketid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ticketid"]];
            
            
            if ([ticketid isEqualToString:_ticketid]) {
                
                [alertVC dismissViewControllerAnimated:NO completion:nil];
                [_useNowBtn setTitle:@"已使用" forState:UIControlStateNormal];
                _useNowBtn.backgroundColor = (UIColorFromRGB(0x8a5454));
                _useNowBtn.userInteractionEnabled = NO;
            }
        }
        
    });
}
@end
