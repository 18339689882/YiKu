//
//  CommonClass.m
//  7.1AFNetWorking
//
//  Created by 王泽 on 2018/8/21.
//  Copyright © 2018年 Huashankeji. All rights reserved.
//

#import "CommonClass.h"
#import "MBProgressHUD.h"
//#import "Reachability.h"

@implementation CommonClass

NSString *result = nil;

+ (NSString *)UEncode:(NSString *)str
{
    result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                   (CFStringRef)str,
                                                                                   NULL,
                                                                                   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                   kCFStringEncodingUTF8));
    return result;
}

+ (void)showMBProgressHUD:(NSString *)showMessage andWhereView:(UIView *)view
{
    MBProgressHUD *loadingView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    loadingView.label.text = showMessage;
}

+ (void)hideMBprogressHUD:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(void)showAlertWithMessage:(NSString *)msg{
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:msg
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}

////判断是否有网络连接
//+(BOOL)isConnectionAvailable
//{
//    BOOL isExistenceNetwork = YES;
//
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = NO;
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = YES;
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = YES;
//            break;
//    }
//
//    return isExistenceNetwork;
//}


+(NSMutableAttributedString *)setLabelGapWithStr:(id)labelStr andGap:(float)gamNum
{
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:gamNum];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelStr length])];
    return attributedString;
}

+(NSString *)currentTime:(NSDate *)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:currentDate];
    
    return destDateString;
}

@end
