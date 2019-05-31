#  App权限控制说明


## 权限控制范围:

    1.使用权限，例如按钮是否可以点击、列表是否可以点击
    2.页面展示权限，例如页面是否有查看权限
    3.点击事件、消息推送跳转权限

## 实现原理

    1.对UIButton、UIBarButtonItem、等控件的点击事件进行拦截
    2.对UIViewController的显示事件进行拦截
    3.对UITableView、UICollectionView的点击事件进行拦截
        
## 配置
    1.需在社区运营管理云平台的（http://192.168.200.222:8080/root/index.html）功能模块设置好基础资源ID等信息
    2.首页动态获取服务端的功能菜单，并赋值SourceID至CollectionViewCell
    3.通过对点击、选择事件的拦截，进行指定跳转，或者权限提示
    


