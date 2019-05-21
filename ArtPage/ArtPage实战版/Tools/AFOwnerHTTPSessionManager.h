//
//  AFOwnerHTTPSessionManager.h
//  7.1AFNetWorking
//
//  Created by 王泽 on 2018/9/19.
//  Copyright © 2018年 Huashankeji. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFOwnerHTTPSessionManager : AFHTTPSessionManager

@property(nonatomic, strong) AFURLSessionManager *urlSessionManager;

+ (instancetype)shareManager;

//外面指定下载路径和文件名的下载方法
- (void)downloadFileURL:(NSString *)url
           filesavePath:(NSString *)path
               fileName:(NSString *)sourceName
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


//默认指定下载路径和文件名的下载方法
- (void)downloadFileURL:(NSString *)url
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

//暂停当前正在下载的任务
- (void) suspendAllDownload;

//继续下载暂停过的任务
- (void) startAllDownload;

//取消掉所有的当前下载任务
- (void)cancelAllDownloads;

@end
