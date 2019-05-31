//
//  PAMyRedBagVcoucherViewController.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAMyRedBagVoucherViewController.h"

#import "PAVoucherTableViewCell.h"
#import "PARedBagView.h"

#import "PARedBagDetailModel.h"
#import "PARedBagModel.h"

#import "PARedBagPresenter.h"

#import "PARedBagDetailViewController.h"
#import "PAVoucherDetailViewController.h"


typedef NS_ENUM(NSUInteger, MYREDBAG_STATUS) {
    MYREDBAG_STATUS_UNRECEIVED = 0,//未领取
    MYREDBAG_STATUS_RECEIVED,//已领取
    MYREDBAG_STATUS_USED,//已使用
    MYREDBAG_STATUS_INVALID,//已过期
};

@interface PAMyRedBagVoucherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong,nonatomic) NSMutableArray *tableViewArrays;

@property (strong,nonatomic) NSMutableArray *unReceivedRedbags;
@property (strong,nonatomic) NSMutableArray *receivedRedbags;

@property (strong,nonatomic) NSMutableArray *unUsedVouchers;
@property (strong,nonatomic) NSMutableArray *usedVouchers;
@property (strong,nonatomic) NSMutableArray *invalidVouchers;

@end

@implementation PAMyRedBagVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    [self setupSegment];
    [self setupTableView];
    
    [self exchhangeTableView:self.tableViewArrays.firstObject];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self httpRequestForGetList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MYREDBAG_TABLE_TYPE)tableType{
    if (_tableType) {
        return _tableType;
    }
    return MYREDBAG_TABLE_TYPE_REDBAG;
}

#pragma mark - Network

- (void)httpRequestForGetList{
    
    [self hiddenNothingnessView];
    
    @WeakObj(self);

    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    AD_TYPE adType = (self.tableType==MYREDBAG_TABLE_TYPE_REDBAG?AD_TYPE_REDBAG:AD_TYPE_ENVELOPE);
    [PARedBagPresenter getRedEnvelopeListWithType:adType
                                  UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                        [[THIndicatorVC sharedTHIndicatorVC]stopAnimating];
                                        
                                          if (resultCode == SucceedCode) {
                                              
                                              [selfWeak classifyUnsortRedbags:data];
                                              
                                              [selfWeak updateNothingView];
                                              [selfWeak setSegmentControlTitleByData];
                                              [[selfWeak currentTableView] reloadData];                                              
                                              
                                          }else if (resultCode == FailureCode) {
                                              
                                              [selfWeak showToastMsg:data Duration:3.0];
                                              
                                              [[selfWeak currentTableView] reloadData];
                                              
                                              [selfWeak showNothingnessViewWithType:NoContentTypeNetwork
                                                                                               Msg:@"加载失败"
                                                                                     eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                                  [selfWeak httpRequestForGetList];
                                              }];
                                              
                                          }else{
                                              
                                              [[selfWeak currentTableView] reloadData];
                                              [selfWeak showNothingnessViewWithType:NoContentTypeNetwork
                                                                                Msg:@"链接失败，请检查网络!"
                                                                      eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                                  [selfWeak httpRequestForGetList];
                                              }];
                                          }
                                      });
    }];
}

#pragma mark - UI

-(void)setupTitle{
    if (self.tableType == MYREDBAG_TABLE_TYPE_REDBAG) {
        self.title = @"我的红包";
    }else if (self.tableType == MYREDBAG_TABLE_TYPE_VOUCHER){
        self.title = @"我的卡券";
    }
}

-(void)setupSegment{
    
    [self.segmentControl removeAllSegments];
    
    if (self.tableType == MYREDBAG_TABLE_TYPE_REDBAG) {
        
        [self.segmentControl insertSegmentWithTitle:@"未领取(0)" atIndex:0 animated:NO];
        [self.segmentControl insertSegmentWithTitle:@"已领取(0)" atIndex:1 animated:NO];
        
    }else if (self.tableType == MYREDBAG_TABLE_TYPE_VOUCHER){
        
        [self.segmentControl insertSegmentWithTitle:@"未使用(0)" atIndex:0 animated:NO];
        [self.segmentControl insertSegmentWithTitle:@"已使用(0)" atIndex:1 animated:NO];
        [self.segmentControl insertSegmentWithTitle:@"已失效(0)" atIndex:2 animated:NO];
    }else{
        [self.segmentControl insertSegmentWithTitle:@"未知错误" atIndex:0 animated:NO];
    }
    
    self.segmentControl.selectedSegmentIndex = 0;
}

-(void)setupTableView{
    
    if (self.tableViewArrays) {
        [self.tableViewArrays removeAllObjects];
    }else{
        self.tableViewArrays = [NSMutableArray array];
    }
    
    if (self.tableType == MYREDBAG_TABLE_TYPE_REDBAG) {
        
        BaseTableView *unReceiveTableView = [[BaseTableView alloc]initWithFrame:CGRectZero];
        BaseTableView *receivedTableView = [[BaseTableView alloc]initWithFrame:CGRectZero];
        
        [self.tableViewArrays addObject:unReceiveTableView];
        [self.tableViewArrays addObject:receivedTableView];
        
    }else if (self.tableType == MYREDBAG_TABLE_TYPE_VOUCHER){
        
        BaseTableView *unReceiveTableView = [[BaseTableView alloc]initWithFrame:CGRectZero];
        BaseTableView *receivedTableView = [[BaseTableView alloc]initWithFrame:CGRectZero];
        BaseTableView *invalidTableView = [[BaseTableView alloc]initWithFrame:CGRectZero];
        
        [self.tableViewArrays addObject:unReceiveTableView];
        [self.tableViewArrays addObject:receivedTableView];
        [self.tableViewArrays addObject:invalidTableView];
    }
    
    for (BaseTableView *tableView in self.tableViewArrays) {
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = UIColorFromRGB(0xF1F1F1);
        tableView.separatorStyle =UITableViewCellAccessoryNone;
        
        [tableView registerNib:[UINib nibWithNibName:@"PAVoucherTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAVoucherTableViewCell"];
    }
}

-(void)exchhangeTableView:(UITableView *)tableView{
    
    [[self currentTableView]removeFromSuperview];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger appendCount = self.tableType==MYREDBAG_TABLE_TYPE_REDBAG?0:1;

    return [[self ArrayForTableType:self.tableType AndStatus:self.segmentControl.selectedSegmentIndex+appendCount] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PAVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAVoucherTableViewCell"];
    
    NSInteger appendCount = self.tableType==MYREDBAG_TABLE_TYPE_REDBAG?0:1;
    cell.voucher = [self ArrayForTableType:self.tableType AndStatus:self.segmentControl.selectedSegmentIndex+appendCount][indexPath.row];
    
    // 立即领取红包
    @WeakObj(self);
    cell.cellEventBlock = ^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        NSLog(@"%@ %ld",data, indexPath.row);
    
        PARedBagDetailModel *redBagDetail = data;
        
        PARedBagModel *redBag = [PARedBagModel redBagWithDetail:redBagDetail];
                
        [PARedBagView showWithRedBag:redBag EventBlock:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            if (index == 0) {
                PARedBagModel *redBag = data;
                [selfWeak openRedBag:redBag];
            }
        }];
    };    
    
    return cell;
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger appendCount = self.tableType==0?0:1;

    PARedBagDetailModel *redBag = [self ArrayForTableType:self.tableType AndStatus:self.segmentControl.selectedSegmentIndex+appendCount][indexPath.row];
    
    if (self.tableType == MYREDBAG_TABLE_TYPE_REDBAG) {
        
        PARedBagDetailViewController *redBagDetailVC = [[PARedBagDetailViewController alloc]initWithNibName:@"PARedBagDetailViewController" bundle:nil];
        redBagDetailVC.redBag = redBag;
        if (redBag.state == 0) {
            return;//未领取
        }
        [self.navigationController pushViewController:redBagDetailVC animated:YES];
        
    }else if (self.tableType == MYREDBAG_TABLE_TYPE_VOUCHER){
        
        PAVoucherDetailViewController *voucherDetailVC = [[PAVoucherDetailViewController alloc]initWithNibName:@"PAVoucherDetailViewController" bundle:nil];
        voucherDetailVC.voucher = redBag;
        
        [self.navigationController pushViewController:voucherDetailVC animated:YES];
        
    }
}

#pragma mark - Actions

- (IBAction)segementSelect:(UISegmentedControl*)sender {
    
    [self exchhangeTableView:self.tableViewArrays[sender.selectedSegmentIndex]];
    
    for (UITableView *tableView in self.tableViewArrays) {
        [tableView reloadData];
    }
    
    //[[self currentTableView] reloadData];
    
    [self updateNothingView];    
}

-(void)updateNothingView{
    
    NSInteger appendCount = self.tableType == MYREDBAG_TABLE_TYPE_REDBAG?0:1;
    
    NSArray *currentTableDataArray = [self ArrayForTableType:self.tableType AndStatus:self.segmentControl.selectedSegmentIndex + appendCount];
    
    if (currentTableDataArray.count == 0) {
        NoContentType contentType = (self.tableType==MYREDBAG_TABLE_TYPE_REDBAG?NoContentTypeMyRedList:NoContentTypeMyCouponList);
        [[self currentTableView] showNothingnessViewWithType:contentType
                                          Msg:(self.tableType==MYREDBAG_TABLE_TYPE_REDBAG?@"暂无红包":@"暂无卡券")
                                eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                    [self httpRequestForGetList];
                                }];
    }
}

- (void)setSegmentControlTitleByData{
    
    if (self.tableType == MYREDBAG_TABLE_TYPE_REDBAG) {
        
        [self.segmentControl setTitle:[NSString stringWithFormat:@"未领取(%ld)",[self ArrayForTableType:MYREDBAG_TABLE_TYPE_REDBAG AndStatus:MYREDBAG_STATUS_UNRECEIVED].count] forSegmentAtIndex:0 ];
        [self.segmentControl setTitle:[NSString stringWithFormat:@"已领取(%ld)",[self ArrayForTableType:MYREDBAG_TABLE_TYPE_REDBAG AndStatus:MYREDBAG_STATUS_RECEIVED].count] forSegmentAtIndex:1 ];
        
    }else if (self.tableType == MYREDBAG_TABLE_TYPE_VOUCHER){
        
        [self.segmentControl setTitle:[NSString stringWithFormat:@"未使用(%ld)",[self ArrayForTableType:MYREDBAG_TABLE_TYPE_VOUCHER AndStatus:MYREDBAG_STATUS_RECEIVED].count] forSegmentAtIndex:0 ];
        [self.segmentControl setTitle:[NSString stringWithFormat:@"已使用(%ld)",[self ArrayForTableType:MYREDBAG_TABLE_TYPE_VOUCHER AndStatus:MYREDBAG_STATUS_USED].count] forSegmentAtIndex:1 ];
        [self.segmentControl setTitle:[NSString stringWithFormat:@"已失效(%ld)",[self ArrayForTableType:MYREDBAG_TABLE_TYPE_VOUCHER AndStatus:MYREDBAG_STATUS_INVALID].count] forSegmentAtIndex:2 ];
    }
}

#pragma mark - Data

-(void)classifyUnsortRedbags:(NSArray*)redbags{
    
    //初始化数据源
    if(self.unReceivedRedbags){
        [self.unReceivedRedbags removeAllObjects];
    }else{
        self.unReceivedRedbags = [NSMutableArray array];
    }
    
    if(self.receivedRedbags){
        [self.receivedRedbags removeAllObjects];
    }else{
        self.receivedRedbags = [NSMutableArray array];
    }
    
    if(self.unUsedVouchers){
        [self.unUsedVouchers removeAllObjects];
    }else{
        self.unUsedVouchers = [NSMutableArray array];
    }
    
    if(self.usedVouchers){
        [self.usedVouchers removeAllObjects];
    }else{
        self.usedVouchers = [NSMutableArray array];
    }
    
    if(self.invalidVouchers){
        [self.invalidVouchers removeAllObjects];
    }else{
        self.invalidVouchers = [NSMutableArray array];
    }
    
    
    for (PARedBagDetailModel *redBag in redbags) {
        
        if (self.tableType == MYREDBAG_TABLE_TYPE_REDBAG) {//我的红包
            if(redBag.state == 0){//未领取
                [self.unReceivedRedbags addObject:redBag];
            }else if(redBag .state == 1){//已领取
                [self.receivedRedbags addObject:redBag];
            }
        }else if (self.tableType == MYREDBAG_TABLE_TYPE_VOUCHER){//我的卡券
            if(redBag.state == 1){//已领取
                [self.unUsedVouchers addObject:redBag];
            }else if(redBag.state == 2){//已核销
                [self.usedVouchers addObject:redBag];
            }else if(redBag.state == 3){//已过期
                [self.invalidVouchers addObject:redBag];
            }
        }
    }
}

-(NSArray *)ArrayForTableType:(MYREDBAG_TABLE_TYPE)type AndStatus:(MYREDBAG_STATUS)status{
    
    if (type == MYREDBAG_TABLE_TYPE_REDBAG) {//我的红包
        
        if (status == MYREDBAG_STATUS_UNRECEIVED) {//未领取
            
            return _unReceivedRedbags;
            
        }else if(status == MYREDBAG_STATUS_RECEIVED){//已领取
            
            return _receivedRedbags;
        }
        
    }else if (type == MYREDBAG_TABLE_TYPE_VOUCHER){//我的卡券
        
        if (status == MYREDBAG_STATUS_RECEIVED) {//未使用
            
            return _unUsedVouchers;
            
        }else if(status == MYREDBAG_STATUS_USED){//已使用
            
            return _usedVouchers;
            
        }else if(status == MYREDBAG_STATUS_INVALID){//已失效
            
            return _invalidVouchers;
        }
    }
    
    return nil;
}

#pragma mark - helper

-(BaseTableView*)currentTableView{
    return self.tableViewArrays[self.segmentControl.selectedSegmentIndex];
}

@end
