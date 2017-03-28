# YzcChart
 ![img](https://github.com/Yzc-jason/YzcChart/blob/master/chartGIf.gif)
 
## From CocoaPods【使用CocoaPods

```ruby
pod 'YzcChart'
```
## Manually 【手动导入】
- Drag all source files under floder YzcChart to your project.【将YzcChart文件夹中的所有源代码拽入项目中】
- Import the main header file：#import "YzcChartView.h"【导入主头文件：#import "YzcChartView.h"】

## Examples【示例】
#### lineChart
```objc
    YzcChartView *chartView = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 100, 350, 200) dataSource:self style:YzcChartStyleLine];
    [chartView showInView:self.scrollView];

```
#### barChart
```objc
 YzcChartView *chartView2 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleBar];
    [chartView2 showInView:self.scrollView];
```
#### Must be achieved delegate void【必须实现的代理方法】
```objc
///横坐标标题数组
- (NSMutableArray *)chartConfigAxisXValue:(YzcChartView *)chart;

///数值数组
- (NSMutableArray *)chartConfigAxisYValue:(YzcChartView *)chart;

```

#### optional delegate method 【可配置的代理方法】
```objc
///显示数值范围
- (CGRange)chartRange:(YzcChartView *)chart;


/**
 图表效果配置

 @param chart chart
 @return 配置model
 */
- (YzcConfigModel *)chartEffectConfig:(YzcChartView *)chart;

#pragma mark - 柱状图功能

- (NSInteger)barChartTargetValue:(YzcChartView *)chart;

/**
 柱状图样式

 @param chart chart
 @return bool
 */
- (BarChartStyle)barChartStyle:(YzcChartView *)chart;
```

#### optional Attributes 【可选属性】
```objc
///左上角显示单位(未国际化)
@property (copy, nonatomic) NSString *unitString;
///是否显示左上角单位，默认隐藏
@property (nonatomic, assign) BOOL isHiddenUnit;
///最后一个数值是否显示在柱状上面,默认隐藏
@property (nonatomic, assign) BOOL isShowLastValue;
///横坐标显示间隔数
@property (nonatomic, assign) NSInteger intervalValue;

```
