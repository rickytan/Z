//
//  ChirpService.h
//  XQuquerSDK
//
//  Created by Wu Yifan on 12-9-5.
//  Copyright (c) 2012年 139ME. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XQuquerDelegate <NSObject>

- (void)didSendDataToken;
- (void)didReceiveDataToken:(NSString*)dataToken;
- (void)didUploadData:(NSString*)dataToken withError:(NSError*)error;
- (void)didDownloadData:(NSString*)dataContent withError:(NSError*)error;

@end

@interface XQuquerService : NSObject

+ (XQuquerService*)defaultService;

- (void)setAccesskey:(NSString*)accesskey andSecretkey:(NSString*)secretkey;
- (void)setDelegate:(id<XQuquerDelegate>)delegate;

- (void)start;
- (void)stop;
- (short*)getWaveData:(short*)size;

- (BOOL)sendDataToken:(NSString*)dataToken;
- (BOOL)uploadData:(NSString*)dataContent;
- (BOOL)downloadData:(NSString*)dataToken;

@end
