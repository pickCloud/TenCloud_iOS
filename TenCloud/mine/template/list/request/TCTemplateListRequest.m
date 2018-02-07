//
//  TCTemplateListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCTemplateListRequest.h"
#import "TCTemplate+CoreDataClass.h"

@interface TCTemplateListRequest()
//@property (nonatomic, assign)   NSInteger     corpID;
@end

@implementation TCTemplateListRequest

/*
- (instancetype) initWithCorpID:(NSInteger)cid
{
    self = [super init];
    if (self)
    {
        _corpID = cid;
        self.ignoreCache = YES;
    }
    return self;
}
 */

- (void) startWithSuccess:(void(^)(NSArray<TCTemplate *> *templateArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataArray = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"dta array:%@",dataArray);
        if (dataArray)
        {
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            NSArray *tmplArray = [TCTemplate mj_objectArrayWithKeyValuesArray:dataArray context:context];
            success ? success (tmplArray) : nil;
        }
        /*
        if (corpDictArray && corpDictArray.count >= 1)
        {
            NSDictionary *corpDict = corpDictArray.firstObject;
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            TCCorp *corp = [TCCorp mj_objectWithKeyValues:corpDict context:context];
            success ? success(corp) : nil;
        }
         */
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *url = [NSString stringWithFormat:@"/api/permission/template/list/%ld",cid];
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

@end
