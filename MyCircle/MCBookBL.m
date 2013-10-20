//
//  MCBookBL.m
//  MyCircle
//
//  Created by Samuel on 10/17/13.
//
//

#import "MCBookBL.h"

@implementation MCBookBL

//插入Book方法
-(BOOL) create:(MCBook *)model
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao create:model] ? 0 : -1;
}

//删除Book方法
-(BOOL) remove:(MCBook *)model
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao remove:model] ? 0 : -1;
}

//通过belongOrgId删除Book方法
-(BOOL) removeByOrgId:(NSString *)orgId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao removeByOrgId:orgId] ? 0 : -1;
}

//删除所有Book方法
-(BOOL) removeAll
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao removeAll] ? 0 : -1;
}

//查询所用数据方法
-(NSMutableArray*) findAll
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao findAll];
}

@end
