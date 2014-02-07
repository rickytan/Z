//
//  ZShareViewController.m
//  ZShare
//
//  Created by ricky on 14-1-10.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZShareViewController.h"
#import "XQuquerService.h"
#import "NSString+RExtension.h"
#import "Reachability.h"
#import "ZTokenManager.h"
#import "ZFileItem.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import "ZAppDelegate.h"

const char dkey[] = {5,0,9,7,12,4,3,10,6,8,11,2,15,1,13,14};
const char ekey[] = {1,13,11,6,5,0,8,3,9,2,7,10,4,14,15,12};


@interface ZShareViewController () <XQuquerDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) NSString                * tokenSent;
@property (nonatomic, retain) NSString                * tokenReceived;
@property (nonatomic, retain) NSURL                   * fileURL;
@property (nonatomic, retain) NSArray                 * fileItems;
@property (nonatomic, strong) UIActivityIndicatorView * spinnerView;
- (IBAction)onSend:(id)sender;
@end

@implementation ZShareViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetworkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [[Reachability reachabilityForLocalWiFi] startNotifier];

    self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinnerView];
    self.navigationItem.rightBarButtonItem = spinnerItem;

    [[XQuquerService defaultService] setDelegate:self];
    [[XQuquerService defaultService] start];

    [self loadFileItems];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTokenSent:(NSString *)tokenSent
{
    _tokenSent = tokenSent;
    [self.tableView reloadData];
}

- (void)setTokenReceived:(NSString *)tokenReceived
{
    _tokenReceived = tokenReceived;
    [self.tableView reloadData];
}

- (void)loadFileItems
{
    [self.spinnerView startAnimating];
    self.view.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSMutableArray *arr = [NSMutableArray array];
        NSDirectoryEnumerator *enumer = [fm enumeratorAtPath:[NSString documentsPath]];
        while (NSString *filePath = enumer.nextObject) {
            if ([enumer.fileAttributes.fileType isEqualToString:NSFileTypeRegular] && ![filePath hasPrefix:@"."]) {
                ZFileItem *item = [ZFileItem new];
                item.fileName = filePath;
                item.fileSize = [NSNumber numberWithUnsignedLongLong:enumer.fileAttributes.fileSize];
                [arr addObject:item];
            }
        }
        self.fileItems = [NSArray arrayWithArray:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinnerView stopAnimating];
            self.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Actions

- (IBAction)onSend:(id)sender
{
    if (!self.tokenSent)
        return;

    if ([[XQuquerService defaultService] sendDataToken:self.tokenSent]) {
        [((ZAppDelegate *)[UIApplication sharedApplication].delegate) startServer];
    }
}

- (void)onNetworkChanged:(NSNotification *)notification
{

}

#pragma mark - Methods

- (NSString *)encodeToken:(NSString *)token
{
    NSString *wuyifan = [token stringByAppendingString:@"wuyifan"];
    NSString *prefix = [[wuyifan md5] substringToIndex:16 - token.length];
    NSString *str = [token stringByAppendingString:prefix];
    unichar text[16] = {0};
    for (int i=0; i<str.length; i++) {
        text[i] = [str characterAtIndex:ekey[i]];
    }
    NSString *ququerToken = [NSString stringWithCharacters:text
                                                    length:16];
    return ququerToken;
}

- (NSString *)decodeToken:(NSString *)token
{
    NSString *str = token;
    unichar text[16] = {0};
    for (int i=0; i<str.length; i++) {
        text[i] = [str characterAtIndex:dkey[i]];
    }
    NSString *myToken = [NSString stringWithCharacters:text
                                                length:10];
    return myToken;
}

- (void)sendToken:(NSString *)token
{
    self.tokenSent = [self encodeToken:token];
    [self onSend:nil];
}

- (void)sendFile:(NSString *)filePath
{
    NSString *token = [ZTokenManager generateTokenForFile:filePath];
    [self sendToken:token];
}

- (void)downloadFile:(NSURL *)fileURL
{
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:fileURL];
    [request setCompletionBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"下载完成！"
                                    message:[NSString stringWithFormat:@"文件已经保存至：%@", request.downloadDestinationPath]
                                   delegate:nil
                          cancelButtonTitle:@"好"
                          otherButtonTitles:nil] show];
    }];
    [request setHeadersReceivedBlock:^(NSDictionary *responseHeaders) {
        NSString *filename = nil;
        NSString *disposition = responseHeaders[@"Content-Disposition"];
        NSRange range = [disposition rangeOfString:@"="];
        if (range.length > 0) {
            NSString *str = [disposition substringFromIndex:range.location + 1];
            filename = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \";"]];
        }
        if (!filename)
            filename = @"unknown";
        request.downloadDestinationPath = [[NSString documentsPath] stringByAppendingPathComponent:filename];
    }];
    [request setFailedBlock:^{
        NSLog(@"%@", request.error);
    }];
    [request startAsynchronous];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    ZFileItem *item = self.fileItems[indexPath.row];
    cell.textLabel.text = item.fileName;
    cell.detailTextLabel.text = item.fileSize.stringValue;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"simple/%@.png", item.fileName.pathExtension]];
    if (!image) {
        image = [UIImage imageNamed:@"simple/all.png"];
    }
    cell.imageView.image = image;

    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];

    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != ReachableViaWiFi) {
        [[[UIAlertView alloc] initWithTitle:@"错误"
                                    message:@"请连接局域网 WiFi 以使用文件分享功能！"
                                   delegate:nil
                          cancelButtonTitle:@"好"
                          otherButtonTitles:nil] show];
        return;
    }
    ZFileItem *item = self.fileItems[indexPath.row];
    NSString *path = [[NSString documentsPath] stringByAppendingPathComponent:item.fileName];
    [self sendFile:path];
}

#pragma mark - XQuquer Delegate

- (void)didSendDataToken
{

}

- (void)didReceiveDataToken:(NSString *)dataToken
{
    self.tokenReceived = dataToken;
    NSString *decode = [self decodeToken:dataToken];
    if ([ZTokenManager verifyToken:decode]) {
        NSString *host = [ZTokenManager hostForToken:decode];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7777/t/%@", host, decode]];
        self.fileURL = url;
        [[[UIAlertView alloc] initWithTitle:@"收到文件"
                                   message:@"下载吗？"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                          otherButtonTitles:@"好", nil] show];
    }
}

- (void)didDownloadData:(NSString *)dataContent
              withError:(NSError *)error
{

}

- (void)didUploadData:(NSString *)dataToken
            withError:(NSError *)error
{
    NSLog(@"%@", dataToken);
    self.tokenSent = dataToken;
    [self onSend:nil];
}

#pragma mark - UIAlert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self downloadFile:self.fileURL];
    }
}

@end
