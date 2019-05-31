//
//  IsFixViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "IsFixViewController.h"

@interface IsFixViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IsFixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"选择是否";
    dataArray = @[@"否",@"是"];
    [self createTableView];
}



- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = LINE_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _indexSelect) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"生活_勾选"]];
        imageView.frame = CGRectMake(0, 0, 20, 20);
        cell.accessoryView = imageView;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = dataArray[indexPath.row];
    cell.textLabel.textColor = TITLE_TEXT_COLOR;
    cell.textLabel.font = DEFAULT_FONT(16);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.indexCallBack) {
        self.indexCallBack(indexPath.row);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

/** 关于分割线 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
