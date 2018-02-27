//
//  TCCurrentCorp.h
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCurrentCorp;
@class TCCorp;
@class TCTemplate;
@protocol TCCurrentCorpDelegate <NSObject>
- (void) corpModified:(TCCurrentCorp*)corp;
@end

@interface TCCurrentCorp : NSObject <NSCoding>

+ (instancetype) shared;

@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, assign)   NSInteger   cid;
@property (nonatomic, assign)   BOOL        isAdmin;
@property (nonatomic, strong)   NSString    *contact;
@property (nonatomic, strong)   NSString    *mobile;
@property (nonatomic, strong)   NSString    *image_url;

@property (nonatomic, strong)   NSArray     *funcPermissionArray;
@property (nonatomic, strong)   NSArray     *serverPermissionArray;

- (BOOL) isSameWithID:(NSInteger)cid name:(NSString*)corpName;

- (void) setSelectedCorp:(TCCorp*)corp;

- (void) setPermissions:(TCTemplate*)aTemplate;

- (void) addObserver:(id<TCCurrentCorpDelegate>)obs;

- (void) removeObserver:(id<TCCurrentCorpDelegate>)obs;

- (BOOL) exist;

- (BOOL) havePermissionForFunc:(NSInteger)funcID;

- (void) modified;

- (void) reset;

- (void) save;

- (void) print;

@end
