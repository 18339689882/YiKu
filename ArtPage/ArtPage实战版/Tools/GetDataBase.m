//
//  GetDataBase.m
//  SQ
//
//  Created by wangze on 14-3-24.
//  Copyright (c) 2014年 wangze. All rights reserved.
//

#import "GetDataBase.h"

@implementation GetDataBase

@synthesize fmdb;
@synthesize fmrs;

static GetDataBase *dataBase = nil;

//得到数据库，单例的数据库
+ (GetDataBase *)shareDataBase
{
    if (!dataBase)
    {
        @synchronized(self)
        {
            if (!dataBase)
            {
                dataBase = [[GetDataBase alloc] init];
                NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/WZProject.db"]];
                NSLog(@"===%@===", dbPath);
                dataBase.fmdb = [FMDatabase databaseWithPath:dbPath];
                if (![dataBase.fmdb open])
                {
                    dataBase = nil;
                }
            }
        }
    }
//    else //防止数据库被删除后就不能创建新的数据库了
//    {
//        //相当于创建数据库文件
//        if (![dataBase.fmdb open])
//        {
//            dataBase = nil;
//        }
//    }
    return dataBase;
}


//判断表格是否存在
- (BOOL)isExistTable:(NSString *)tableName
{
    BOOL value = NO;
    if ([fmdb tableExists:tableName])
    {
        value = YES;
        NSLog(@"%@存在", tableName);
    }
    return value;
}

//根据对象中的某个字段判断是否在数据库中存在
- (BOOL)isExistTable:(NSString *)tableName andObject:(id)object andObjectAtIndex:(int)index
{
    BOOL value = NO;
    
    NSMutableString *sqlString = [NSMutableString string];
    NSString *propertyStr = [[AssignToObject propertyKeysWithString:tableName] objectAtIndex:index];
    [sqlString appendString:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like ?", tableName, propertyStr]];
    NSString *valueStr = [object valueForKey:propertyStr];
    dataBase.fmrs = [fmdb executeQuery:sqlString, valueStr];
    while ([fmrs next])
    {
        value = YES;
    }
    return value;
}

//根据对象中的两个字段判断是否在数据库中存在
- (BOOL)isTwoExistTable:(NSString *)tableName andObject:(id)object andObjectAtIndex:(int)index andObjectAtIndex:(int)index1
{
    BOOL value = NO;
    
    NSMutableString *sqlString = [NSMutableString string];
    
    NSMutableArray *arr =[AssignToObject propertyKeysWithString:tableName];
    NSString *tempStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?", tableName, [arr objectAtIndex:index], [arr objectAtIndex:index1]];
    [sqlString appendString:tempStr];
    
    NSString *str1 = [object valueForKey:[arr objectAtIndex:index]];
    NSString *str2 = [object valueForKey:[arr objectAtIndex:index1]];
    dataBase.fmrs = [fmdb executeQuery:sqlString, str1, str2];
    while ([fmrs next])
    {
        value = YES;
    }
    return value;
}


#pragma mark - 创建表格

//创建表格（会自动加上id作为主键）
- (void)wzCreateTableID:(NSString *)tableName
{
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"CREATE TABLE %@", tableName]];
    [sqlString appendString:@"("];
    
    for (NSString *string in [AssignToObject propertyKeysWithString:tableName])
    {
        [sqlString appendString:string];
        [sqlString appendString:@", "];
    }
    [sqlString appendString:@"primaryId integer primary key autoincrement"];
    [sqlString appendString:@")"];
    NSLog(@"%@",sqlString);
    
    [fmdb executeUpdate:sqlString];
}


//执行插入操作时，把model中的属性和值放到一个字典中。
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andModel:(id)object
{
    BOOL value = NO;
    
    BOOL exist = [[GetDataBase shareDataBase] isExistTable:tableName];
    if (!exist)
    {
        //如果数据库表不存在就先创建一个数据库表。
        [[GetDataBase shareDataBase] wzCreateTableID:tableName];
    }
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (NSString *propertyStr in [AssignToObject propertyKeysWithString:tableName])
    {
        if ([object valueForKey:propertyStr])
        {
            [dicData setObject:[object valueForKey:propertyStr] forKey:propertyStr];
        }
    }
    
    NSLog(@"%@", dicData);
    
    //添加数据
    value = [[GetDataBase shareDataBase] wzInsertRecorderDataWithTableName:tableName valuesDictionary:dicData];
    
    return value;
}

//arr传的是包含多个字典的数组
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andDicArray:(NSArray *)arr
{
    BOOL value = NO;
    
    BOOL exist = [[GetDataBase shareDataBase] isExistTable:tableName];
    if (!exist)
    {
        //如果数据库表不存在就先创建一个数据库表。
        [[GetDataBase shareDataBase] wzCreateTableID:tableName];
    }
    
    //开启事务避免批量数据插入时候卡顿的情况
    [[[GetDataBase shareDataBase] fmdb] beginTransaction];
    
    for (NSMutableDictionary *dic in arr)
    {
        value = [[GetDataBase shareDataBase] wzInsertRecorderDataWithTableName:tableName valuesDictionary:dic];
    }
    //事务开启后要有提交操作才能完整执行整个事务。
    [[[GetDataBase shareDataBase] fmdb] commit];
    
     return value;
}

//arr传的是包含多个对象的数组
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr
{
    BOOL value = NO;
    
    BOOL exist = [[GetDataBase shareDataBase] isExistTable:tableName];
    if (!exist)
    {
        //如果数据库表不存在就先创建一个数据库表。
        [[GetDataBase shareDataBase] wzCreateTableID:tableName];
    }
    
    //开启事务避免批量数据插入时候卡顿的情况
    [[[GetDataBase shareDataBase] fmdb] beginTransaction];
    
    for (id object in arr)
    {
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        for (NSString *propertyStr in [AssignToObject propertyKeysWithString:tableName])
        {
            if ([object valueForKey:propertyStr])
            {
                [dicData setObject:[object valueForKey:propertyStr] forKey:propertyStr];
            }
        }
        
        //添加数据
        value = [[GetDataBase shareDataBase] wzInsertRecorderDataWithTableName:tableName valuesDictionary:dicData];
    }
    
    //事务开启后要有提交操作才能完整执行整个事务。
    [[[GetDataBase shareDataBase] fmdb] commit];
    
    return value;
}

//把上个方法中的字典数据插入数据库
- (BOOL)wzInsertRecorderDataWithTableName:(NSString *)tableName valuesDictionary:(NSMutableDictionary *)dic
{
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"INSERT INTO %@", tableName]];
    [sqlString appendString:@" ("];
    NSArray *array = [dic allKeys];
    for (NSString *string in array)
    {
        [sqlString appendString:string];
        [sqlString appendString:@","];
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length] - 1, 1)];
    [sqlString appendString:@") VALUES ("];
    for (int i = 0; i < [array count]; ++i)
    {
        [sqlString appendString:@"?,"];
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length]-1, 1)];
    [sqlString appendString:@")"];
    
    if ([fmdb executeUpdate:sqlString withArgumentsInArray:[dic allValues]])
    {
        return YES;
    }
    return NO;
}


#pragma mark - 删除记录
//删除记录
- (void)wzDeleteRecordDataWithTableName:(NSString *)tableName andDictionary:(NSMutableDictionary *)keyDic
{
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ LIKE ?", tableName, [[keyDic allKeys] objectAtIndex:0]]];
    
    NSInteger j = [[keyDic allKeys] count];
    
    if (j > 1)
    {
        for (int i = 1; i < j; ++i) {
            NSString *strKey = [[keyDic allKeys] objectAtIndex:i];
            
            [sqlString appendString:[NSString stringWithFormat:@" AND %@ LIKE ?", strKey]];
        }
    }
    
    [fmdb executeUpdate:sqlString withArgumentsInArray:[keyDic allValues]];
}


-(void)wzDeleteReCordFromTableName:(NSString *)tableName
{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    [fmdb executeUpdate:sqlString];
}

#pragma mark - 修改记录

//修改记录
- (void)wzModifyRecorderData:(NSString *)tableName andNewDictionary:(NSMutableDictionary *)dic andOriginDictionary:(NSMutableDictionary *)keyDic;
{
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"UPDATE %@ SET ",tableName]];
    NSInteger m = [[dic allKeys] count];
    for (int i = 0; i < m; i++)
    {
        [sqlString appendString:[[dic allKeys] objectAtIndex:i]];
        [sqlString appendString:@" = ?, "];
        
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length] - 2, 2)];
    
    [sqlString appendString:@" WHERE "];
    
    NSInteger j = [[keyDic allKeys] count];
    for (int i = 0; i < j; i++)
    {
        [sqlString appendString:[[keyDic allKeys] objectAtIndex:i]];
        [sqlString appendString:@" LIKE ? "];
        [sqlString appendString:@"AND "];
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length] - 4, 4)];
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString *str in [dic allValues])
    {
        [mutableArr addObject:str];
    }
    for (NSString *str in [keyDic allValues])
    {
        [mutableArr addObject:str];
    }
    
    [fmdb executeUpdate:sqlString withArgumentsInArray:mutableArr];
}


#pragma mark - 获取记录

- (NSMutableArray *)wzGetRecorderDataWithTableName:(NSString *)tableName from:(NSString *)fromIdStr to:(NSString *)toIdStr
{
    //from 是指从哪个主键开始查询， to 是指查询到哪个主键结束。
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableString *sqlString = [NSMutableString string];
    
    [sqlString appendString:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id > ? AND id <= ?", tableName]];
    dataBase.fmrs = [fmdb executeQuery:sqlString,fromIdStr,toIdStr];
    
    while ([fmrs next])
    {
        id user = [AssignToObject reflectDataFromOtherObject:fmrs
                                                andObjectStr:tableName];
        [returnArray addObject:user];
    }
    return returnArray;
}

//获取记录
- (NSMutableArray *)wzGetRecorderDataForTwoWithTableName:(NSString *)tableName andDicitonary:(id)keyDic
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName]];
    
    NSInteger j = [[keyDic allKeys] count];
    for (int i = 0; i < j; i++)
    {
        [sqlString appendString:[[keyDic allKeys] objectAtIndex:i]];
        [sqlString appendString:@" LIKE ? "];
        [sqlString appendString:@"AND "];
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length] - 4, 4)];
    
    
    dataBase.fmrs = [fmdb executeQuery:sqlString withArgumentsInArray:[keyDic allValues]];
    
    while ([fmrs next])
    {
        id user = [AssignToObject reflectDataFromOtherObject:fmrs
                                                andObjectStr:tableName];
        [returnArray addObject:user];
    }
    
    return returnArray;
}

//根据数据库的表名称查询数据库表中所有的数据对象
-(NSMutableArray *)wzGainTableRecoderID:(NSString *)tableName
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
    dataBase.fmrs = [fmdb executeQuery:sqlString];
    
    while ([fmrs next])
    {
        id obj = [AssignToObject reflectDataFromOtherObject:fmrs
                                                andObjectStr:tableName];
        [returnArray addObject:obj];
    }
    return returnArray;
}

@end
