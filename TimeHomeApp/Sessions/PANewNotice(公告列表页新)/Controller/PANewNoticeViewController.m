//
//  PANewNoticeViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewNoticeViewController.h"
#import "PANewNoticeTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PANewNoticeService.h"
#import "WebViewVC.h"
#import "PAWebViewController.h"
#import "PANewNoticeURL.h"
@interface PANewNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *noticeView;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)PANewNoticeService * noticeService;
@end

@implementation PANewNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.noticeView];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"社区公告";
    self.noticeView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [self loadNoticeData:YES];
    }];
    self.noticeView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadNoticeData:NO];

    }];
    [self loadNoticeData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _noticeView.delegate = self;
        _noticeView.dataSource = self;
        _noticeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_noticeView registerClass:[PANewNoticeTableViewCell class] forCellReuseIdentifier:@"PANewNoticeTableViewCell"];
        _noticeView.backgroundColor = UIColorHex(0xF5F5F5);
    }
    return _noticeView;
}
- (PANewNoticeService *)noticeService{
    if (!_noticeService) {
        _noticeService = [[PANewNoticeService alloc]init];
    }
    return _noticeService;
}

#pragma mark - Request
- (void)loadNoticeData:(BOOL)header{
    if (header) {
        _currentPage = 1;
    }
    [self.noticeService loadNewNoticeListWithPage:_currentPage success:^(PABaseRequestService *service) {
        if (self.noticeService.noticeArray.count == 0) {
            [self showNoDataView];
        } else{
            _currentPage+=1;
        }
        [self.noticeView.mj_footer endRefreshing];
        [self.noticeView.mj_header endRefreshing];
        [self.noticeView reloadData];
        
    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        [self.noticeView.mj_footer endRefreshing];
        [self.noticeView.mj_header endRefreshing];
        [self showNoDataView];
    }];
    
}

#pragma mark - Actions
- (void)showNoDataView{
    [self showNothingnessViewWithType:NoNewNoticeData Msg:@"抱歉，您暂时还没有公告消息" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
    }];
}


#pragma mark - TableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticeService.noticeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"PANewNoticeTableViewCell" configuration:^(PANewNoticeTableViewCell * cell) {
        cell.noticeModel = self.noticeService.noticeArray[indexPath.row];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"PANewNoticeTableViewCell";
    PANewNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PANewNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.noticeModel = self.noticeService.noticeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PANewNoticeModel * notice = self.noticeService.noticeArray[indexPath.row];
    PAWebViewController * webview = [[PAWebViewController alloc]init];
    webview.title = notice.title;
    webview.noticeModel = notice;
    AppDelegate * delegate = GetAppDelegates;
    webview.url = [NSString stringWithFormat:@"%@%@?token=%@&noticeCode=%@&userId=%@&communityId=%@",PA_NEW_NOTICEWEB_URL,PANewNoticeWebPath,delegate.userData.token,notice.noticeCode,delegate.userData.userID,delegate.userData.communityid];
    webview.shareUrl = [NSString stringWithFormat:@"%@%@?noticeCode=%@",PA_NEW_NOTICEWEB_URL,PANewNoticeWebSharePath,notice.noticeCode];
    [self.navigationController pushViewController:webview animated:YES];
}

@end
