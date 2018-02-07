//
//  TCEmptyPermissionRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEmptyPermissionRequest.h"
#import "TCPermissionNode+CoreDataClass.h"

@interface TCEmptyPermissionRequest()
@property (nonatomic, assign)   NSInteger     corpID;
@end

@implementation TCEmptyPermissionRequest

- (instancetype) initWithCorpID:(NSInteger)cid
{
    self = [super init];
    if (self)
    {
        _corpID = cid;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCPermissionNode *> *nodeArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataArray = [request.responseJSONObject objectForKey:@"data"];
        if (dataArray)
        {
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            NSArray *resArray = [TCPermissionNode mj_objectArrayWithKeyValuesArray:dataArray context:context];
            success ? success (resArray) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/permission/resource/%ld",_corpID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

/*
- (id)requestArgument
{
    return nil;
}
 */
/*
- (NSInteger)cacheTimeInSeconds
{
    return  NSIntegerMax;
}
*/
@end
