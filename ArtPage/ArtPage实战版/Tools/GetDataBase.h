//
//  GetDataBase.h
//  SQ
//
//  Created by wangze on 14-3-24.
//  Copyright (c) 2014年 wangze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AssignToObject.h"

@interface GetDataBase : NSObject

@property(nonatomic, strong) FMDatabase *fmdb;
@property(nonatomic, strong) FMResultSet *fmrs;

//得到数据库，单例的数据库
+ (GetDataBase *)shareDataBase;

//判断表格是否存在（tableName是表名）
- (BOOL)isExistTable:(NSString *)tableName;

//根据对象中的一个字段判断是否在数据库中存在
- (BOOL)isExistTable:(NSString *)tableName andObject:(id)object andObjectAtIndex:(int)index;

//根据对象中的两个字段判断是否在数据库中存在
- (BOOL)isTwoExistTable:(NSString *)tableName andObject:(id)object andObjectAtIndex:(int)index andObjectAtIndex:(int)index;

#pragma mark - 创建表格
//创建表格（会自动加上id作为主键,fieldArray是字段）
- (void)wzCreateTableID:(NSString *)tableName;

#pragma mark - 插入记录
//以model的形式请求插入用户数据
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andModel:(id)object;

//以model数组的形式请求插入用户数据
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr;

//以字典数组的形式请求插入用户数据
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andDicArray:(NSArray *)arr;

//插入记录
- (BOOL)wzInsertRecorderDataWithTableName:(NSString *)tableName valuesDictionary:(NSMutableDictionary *)dic;


#pragma mark - 删除记录
//删除记录(dic中包含了关键字段)
- (void)wzDeleteRecordDataWithTableName:(NSString *)tableName andDictionary:(NSMutableDictionary *)dic;

//删除一个表中所有信息
-(void)wzDeleteReCordFromTableName:(NSString *)tableName;

#pragma mark - 修改记录
//修改记录
- (void)wzModifyRecorderData:(NSString *)tableName andNewDictionary:(NSMutableDictionary *)dic andOriginDictionary:(NSMutableDictionary *)keyDic;


#pragma mark - 获取记录
- (NSMutableArray *)wzGetRecorderDataWithTableName:(NSString *)tableName from:(NSString *)fromIdStr to:(NSString *)toIdStr;

- (NSMutableArray *)wzGetRecorderDataForTwoWithTableName:(NSString *)tableName andDicitonary:(id)keyDic;

//返回数据库表中所有的数据对象
-(NSMutableArray *)wzGainTableRecoderID:(NSString *)tableName;


@end
