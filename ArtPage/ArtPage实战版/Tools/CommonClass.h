//
//  CommonClass.h
//  7.1AFNetWorking
//
//  Created by 王泽 on 2018/8/21.
//  Copyright © 2018年 Huashankeji. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MBProgressHUD.h"
//#import "AFNetworkReachabilityManager.h"

@interface CommonClass : UIView

//编码函数
+ (NSString *)UEncode:(NSString *)str;

//加载提示
+ (void)showMBProgressHUD:(NSString *)showMessage andWhereView:(UIView *)view;
+ (void)hideMBprogressHUD:(UIView *)view;

//提示框信息
+(void)showAlertWithMessage:(NSString *)msg;

//判断网络是否连接
//+(BOOL)isConnectionAvailable;

//设置Label的行间距
+(NSMutableAttributedString *)setLabelGapWithStr:(id)labelStr andGap:(float)gamNum;
//获取当前的时间
+(NSString *)currentTime:(NSDate *)currentDate;

@end
