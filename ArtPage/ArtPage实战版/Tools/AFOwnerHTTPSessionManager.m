//
//  AFOwnerHTTPSessionManager.m
//  7.1AFNetWorking
//
//  Created by 王泽 on 2018/9/19.
//  Copyright © 2018年 Huashankeji. All rights reserved.
//

#import "AFOwnerHTTPSessionManager.h"

@implementation AFOwnerHTTPSessionManager

+ (instancetype)shareManager
{
    static AFOwnerHTTPSessionManager *ownerManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ownerManager = [[AFOwnerHTTPSessionManager alloc] init];
    });
    
    return ownerManager;
}

//懒加载生成下载管理对象
-(AFURLSessionManager *)urlSessionManager
{
    if (!_urlSessionManager)
    {
        _urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _urlSessionManager;
}

//外面指定下载路径和文件名的下载方法
- (void)downloadFileURL:(NSString *)url
           filesavePath:(NSString *)path
               fileName:(NSString *)sourceName
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [self.urlSessionManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        //block传递参数，类似代理传值
        downloadProgressBlock(downloadProgress);
        
    } destination:^NSURL * (NSURL *targetPath, NSURLResponse *response) {
        
        //返回文件的下载路径
        return [NSURL fileURLWithPath:[path stringByAppendingPathComponent:sourceName]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError * error) {
        
        //block传递参数，类似代理传值
        completionHandler(response, filePath, error);
        
    }];
    
    //开始下载
    [downloadTask resume];
}


//默认指定下载路径和文件名的下载方法
- (void)downloadFileURL:(NSString *)url
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [self.urlSessionManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        //block传递参数，类似代理传值
        downloadProgressBlock(downloadProgress);
        
    } destination:^NSURL * (NSURL *targetPath, NSURLResponse *response) {
        
        //返回文件的下载路径
        NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError * error) {
        
        //block传递参数，类似代理传值
        completionHandler(response, filePath, error);
        
    }];
    
    //开始下载
    [downloadTask resume];
}

//暂停当前正在下载的任务
- (void)suspendAllDownload
{
    if (_urlSessionManager)
    {
        for (NSURLSessionDownloadTask *task in _urlSessionManager.tasks)
        {
            [task suspend];
        }
    }
}

//继续下载暂停过的任务
- (void)startAllDownload
{
    if (_urlSessionManager)
    {
        for (NSURLSessionDownloadTask *task in _urlSessionManager.tasks)
        {
            [task resume];
        }
    }
}


//取消掉所有的当前下载任务
- (void)cancelAllDownloads
{
    if (_urlSessionManager)
    {
        for (NSURLSessionDownloadTask *task in _urlSessionManager.tasks)
        {
            [task cancel];
        }
    }
}

@end
