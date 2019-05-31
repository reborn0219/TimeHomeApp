//
//  THAboutUsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THAboutUsViewController.h"
#import "THBaseTableViewCell.h"

#import "THCommitSuggestionsViewController.h"

#import "SharePresenter.h"
#import "WebViewVC.h"

#import "L_SuggestionViewController.h"

@interface THAboutUsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *leftTitles;
    NSMutableArray *rightTexts;
    NSArray *allRightTitles;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THAboutUsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":SheZhi}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:SheZhi];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"关于我们";
    
    leftTitles = @[@[@"版本号",@"微信公众号"],@[@"功能介绍",@"分享应用",@"意见反馈"]];
    rightTexts = [[NSMutableArray alloc]init];
    
    //当前的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSMutableString* versionStr = [[NSMutableString alloc] initWithString:currentVersion];//存在堆区，可变字符串
    if (versionStr.length >= 3) {
        [versionStr insertString:@"." atIndex:versionStr.length - 2];
        [versionStr insertString:@"." atIndex:versionStr.length - 1];
    }else {
        versionStr = [[NSMutableString alloc] initWithString:currentVersion];
    }
    
    [rightTexts addObject:versionStr];
    [rightTexts addObject:@"平安社区SafeHome"];
    
    allRightTitles = @[@"使用条款和隐私政策",@"平安社区（北京）科技有限公司",@"版权所有",@"Copyright 2017",@"All Rights Reserved",@"客服：400-655-5110"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self createTableView];
        
    });
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];

    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return WidthSpace(240)+70;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    
    if (section == 0) {
        UIImageView *logoImageView = [[UIImageView alloc]init];
        logoImageView.image = [UIImage imageNamed:@"平安社区-logo-新-拷贝"];
        [view addSubview:logoImageView];
        logoImageView.sd_layout.widthIs(WidthSpace(240)).heightIs(WidthSpace(240)).centerXEqualToView(view).centerYEqualToView(view);
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    }
    return 30*(allRightTitles.count + 1)+20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    
    if (section == 1) {
        
        for (int i = 0 ; i < allRightTitles.count; i++) {
            
            if (i == 0) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.font = DEFAULT_FONT(14);
                [button setTitleColor:UIColorFromRGB(0x276DDC) forState:UIControlStateNormal];
                [view addSubview:button];
                button.frame = CGRectMake(17, 30+30*i, SCREEN_WIDTH-17*2, 30);
                [button setTitle:allRightTitles[i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(tiaokuanClick) forControlEvents:UIControlEventTouchUpInside];
            }else {
                UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 30+30*i, SCREEN_WIDTH-17*2, 30)];
                textLabel.font = DEFAULT_FONT(14);
                textLabel.textColor = TITLE_TEXT_COLOR;
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.text = allRightTitles[i];
                [view addSubview:textLabel];
            }
        }
    }
    
    return view;
}
/**
 *  使用条款
 */
- (void)tiaokuanClick {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url=@"http://times.usnoon.com:88/cmpapp/xiyie/index.html";
    webVc.title = @"使用条款和隐私政策";
    [self.navigationController pushViewController:webVc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.baseTableViewCellStyle = BaseTableViewCellStyleValue1;
        cell.rightLabel.text = rightTexts[indexPath.row];
    }else {
        cell.baseTableViewCellStyle = BaseTableViewCellStyleDefault;
    }
    
    cell.leftLabel.text = leftTitles[indexPath.section][indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    @WeakObj(self);
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                //功能介绍
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                webVc.url = @"http://api.usnoon.com/apphtml/function.html";
                webVc.title = @"功能介绍";
                [self.navigationController pushViewController:webVc animated:YES];
            }
                break;
            case 1:
            {
                //分享应用
                ShareContentModel * SCML = [[ShareContentModel alloc]init];
                SCML.shareTitle          = @"平安社区";
                SCML.shareImg            = SHARE_LOGO_IMAGE;
                SCML.shareContext        = [NSString stringWithFormat:@"平安社区 你的智能管家!"];
                SCML.shareUrl            = [NSString stringWithFormat:@"%@/20170907/index.html",kH5_SEVER_URL];
                SCML.type                = 6;
                SCML.shareSuperView      = self.view;
                SCML.shareType           = SSDKContentTypeAuto;
                [SharePresenter creatShareSDKcontent:SCML];
                
            }
                break;
            case 2:
            {
                /**
                 *  意见反馈
                 */
                NSLog(@"11111111");
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
                L_SuggestionViewController *suggestVC = [storyBoard instantiateViewControllerWithIdentifier:@"L_SuggestionViewController"];
                [self.navigationController pushViewController:suggestVC animated:YES];

            }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
}


@end
