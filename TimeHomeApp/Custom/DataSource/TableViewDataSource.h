//

/**
 封装UITableViewDataSource 类，简化列表数据处理
 **/
#import <Foundation/Foundation.h>


typedef void (^TableViewCellSettingBlock)(id cell, id item,NSIndexPath * indexPath);


@interface TableViewDataSource : NSObject <UITableViewDataSource>
///初始化
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellSettingBlock)settingCellBlock;
///处理返回cell对象
- (id)itemDataAtIndexPath:(NSIndexPath *)indexPath;
///是否显分组
@property(nonatomic,assign) BOOL isSection;
///列表数据源
@property (nonatomic, strong) NSMutableArray *items;
///cell标识
@property (nonatomic, copy) NSString *cellIdentifier;
///设置cell内容回调
@property (nonatomic, copy) TableViewCellSettingBlock settingCellBlock;
@property(nonatomic,assign) BOOL isDefaultCell;

@end
