//
//  RaiN_RedPacketDetails.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_RedPacketDetails.h"
#import "RedPacketCell.h"
#import "ShakePassageVC.h"
#import "L_MyMoneyViewController.h"
#import "RedPacketPresenters.h"
#import "WebViewVC.h"
#import "L_GuideAttentionVC.h"
#import "L_WithdrawMoneyViewController.h"
@interface RaiN_RedPacketDetails ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *tableData;
@end

@implementation RaiN_RedPacketDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_topBg setHidden:YES];
    [_centerBg setHidden:YES];
    [_tableView setHidden:YES];
    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"红包详情";
    
    _btnBorderView.layer.cornerRadius = 24/2;
    _btnBorderView.layer.borderColor = (UIColorFromRGB(0xfe3f3e)).CGColor;
    _btnBorderView.layer.borderWidth = 1.0f;
    _btnBorderView.layer.masksToBounds = YES;
    
    [self createDataSource];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [_tableView registerNib:[UINib nibWithNibName:@"RedPacketCell" bundle:nil] forCellReuseIdentifier:@"RedPacketCell"];
    
    [self deleteVC];
    [self createRightBarButton];
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
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    NSMutableArray *arr4 = [[NSMutableArray alloc] init];
    NSMutableArray *arr5 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrController.count; i++) {
        if ([arrController[i] isKindOfClass:[RaiN_RedPacketDetails class]]) {
            [arr1 addObject:arrController[i]];
        }
        
        if ([arrController[i] isKindOfClass:[ShakePassageVC class]]) {
            [arr2 addObject:arrController[i]];
        }
        
        if ([arrController[i] isKindOfClass:[L_MyMoneyViewController class]]) {
            [arr3 addObject:arrController[i]];
        }
        
        if ([arrController[i] isKindOfClass:[L_WithdrawMoneyViewController class]]) {
            [arr4 addObject:arrController[i]];
        }
        
        if ([arrController[i] isKindOfClass:[L_GuideAttentionVC class]]) {
            [arr5 addObject:arrController[i]];
        }
    }
    
    if (arr1.count > 1) {
        for (int i = 0; i < arrController.count; i++){
            if ([arrController[i] isKindOfClass:[RaiN_RedPacketDetails class]]) {
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
    
    if (arr3.count > 1) {
        for (int i = 0; i < arrController.count; i++){
            if ([arrController[i] isKindOfClass:[L_MyMoneyViewController class]]) {
                [arrController removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    if (arr4.count > 1) {
        for (int i = 0; i < arrController.count; i++){
            if ([arrController[i] isKindOfClass:[L_WithdrawMoneyViewController class]]) {
                [arrController removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    if (arr5.count > 1) {
        for (int i = 0; i < arrController.count; i++){
            if ([arrController[i] isKindOfClass:[L_GuideAttentionVC class]]) {
                [arrController removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    self.navigationController.viewControllers = arrController;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self createDataSource];
}
#pragma mark ----- 列表数据
- (void)createDataSource {
    
    
    if (_pushTag != 2) {
        
        
        NSString *h5Url = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlink"]];
        
        if ([XYString isBlankString:h5Url]) {
            
            [_checkView setHidden:YES];
        }else{
            [_checkView setHidden:NO];
            
        }
        //大图标
        
        
         [_topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"reddetailpic"]]] placeholderImage:PLACEHOLDER_IMAGE];
        //小图标
        [_littleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlogo"]]] placeholderImage:PLACEHOLDER_IMAGE];
        //商品名称
        _titleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redadvname"]];
        //金额
        _moneylabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"amount"]];
        
        if ([_moneylabel.text doubleValue] == 0.00) {
            _moneylabel.hidden = YES;
            _dollarLabel.text = @"已领完";
        }else {
            _dollarLabel.text = @"￥";
            _moneylabel.hidden = NO;
        }
        if (!_tableData) {
            _tableData = [[NSMutableArray alloc] initWithArray:_dataSource[0][@"redenvelopeinfolist"]];
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
                [selfWeak.nothingnessView setHidden:YES];
                [_dataSource removeAllObjects];
                NSDictionary *tempDic = (NSDictionary *)data;
                [_dataSource addObject:tempDic];
                _topBg.hidden = NO;
                _centerBg.hidden = NO;
                _tableView.hidden = NO;
                
                NSString *h5Url = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlink"]];
                
                if ([XYString isBlankString:h5Url]) {
                    
                    [_checkView setHidden:YES];
                }else{
                    [_checkView setHidden:NO];

                }
                [_topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"reddetailpic"]]] placeholderImage:PLACEHOLDER_IMAGE];
                //小图标
                [_littleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlogo"]]] placeholderImage:PLACEHOLDER_IMAGE];
                //商品名称
                _titleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redadvname"]];
                //金额
                _moneylabel.text = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"amount"]];
                
                NSString * flag = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"flag"]];
                
                if (flag.integerValue == 4) {
                    
                    _moneylabel.hidden = YES;
                    _dollarLabel.text = @"已过期";
                    _moneyBtn.hidden =YES;
                }else {
                    
                    if (([_moneylabel.text floatValue] == 0.00)) {
                        _moneylabel.hidden = YES;
                        _dollarLabel.text = @"已领完";
                        _moneyBtn.hidden =YES;

                    }else {
                        _dollarLabel.text = @"￥";
                        _moneylabel.hidden = NO;
                        _moneyBtn.hidden = NO;

                    }
                   
                }
                
               
                
                if (!_tableData) {
                    _tableData = [[NSMutableArray alloc] initWithArray:_dataSource[0][@"redenvelopeinfolist"]];
                }
                [_tableView reloadData];
                
            }else {
                //失败
                _topBg.hidden = YES;
                _centerBg.hidden = YES;
                _tableView.hidden = YES;
                [selfWeak.nothingnessView setHidden:NO];
                [selfWeak showNothingnessViewWithType:NoContentTypeNetwork Msg:@"加载失败" eventCallBack:nil];
                [selfWeak.nothingnessView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
            [_topBg setHidden:NO];
            [_centerBg setHidden:NO];
            [_tableView setHidden:NO];
        });
    }];
    
    
}

#pragma mark ---- 列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedPacketCell"];
    
    NSString *picUrl = [NSString stringWithFormat:@"%@",_tableData[indexPath.row][@"fileurl"]];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:kHeaderPlaceHolder];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_tableData[indexPath.row][@"nickname"]];
    
    NSString *timeStr =[NSString stringWithFormat:@"%@",_tableData[indexPath.row][@"createtime"]];
    if (timeStr.length > 16) {
        timeStr = [timeStr substringToIndex:16];
    }
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    cell.timeLabel.text = timeStr;
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",_tableData[indexPath.row][@"amount"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark --- 按钮点击事件
/**
 查看更多
 */
- (IBAction)checkMoreClick:(id)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    if([[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlink"]] hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlink"]]];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"redlink"]]];
    }
    webVc.isGetCurrentTitle = YES;
    webVc.title = @"红包详情";
    [self.navigationController pushViewController:webVc animated:YES];

    
}

/**
 我的余额
 */
- (IBAction)moneyBtnClick:(id)sender {
    //余额
    UIStoryboard *myTabBoard = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
    L_MyMoneyViewController *myMoneyVC = [myTabBoard instantiateViewControllerWithIdentifier:@"L_MyMoneyViewController"];
    [myMoneyVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:myMoneyVC animated:YES];
}
/**
 分享
 */
- (void)RightButtonClick {
    
    NSString *advid = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"advid"]];
    NSString *ticketid = [NSString stringWithFormat:@"%@",_dataSource[0][@"ticketinfo"][@"ticketid"]];
//    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [RedPacketPresenters shareRedEnvelopeWithUserticketid:advid andTicketid:ticketid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
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
@end
