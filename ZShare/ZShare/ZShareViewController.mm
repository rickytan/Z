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
#import "ZTokenManager.h"
#import <CommonCrypto/CommonCryptor.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>

const char dkey[] = {5,0,9,7,12,4,3,10,6,8,11,2,15,1,13,14};
const char ekey[] = {1,13,11,6,5,0,8,3,9,2,7,10,4,14,15,12};


@interface ZShareViewController () <XQuquerDelegate>
@property (nonatomic, retain) NSString *tokenSent;
@property (nonatomic, retain) NSString *tokenReceived;
- (IBAction)onSend:(id)sender;
@end

@implementation ZShareViewController

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

    [[XQuquerService defaultService] setDelegate:self];
    [[XQuquerService defaultService] start];
    [[XQuquerService defaultService] setAccesskey:@"3527402060"
                                     andSecretkey:@"8e47a8bda484eca5bbc32df8743b3e3c"];
    //[[XQuquerService defaultService] uploadData:@"Hello World!"];
    //[self sendToken:@"8abd8292af"];

    NSString *file = [[NSBundle mainBundle] pathForResource:@"bootstrap_cheatsheet"
                                                     ofType:@"pdf"];
    [self sendFile:file];

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

#pragma mark - Actions

- (IBAction)onSend:(id)sender
{
    if ([[XQuquerService defaultService] sendDataToken:self.tokenSent])
        NSLog(@"Send %@ OK", self.tokenSent);
    else
        NSLog(@"Send %@ Fail...", self.tokenSent);
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
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:fileURL];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    if (indexPath.row == 0)
        cell.textLabel.text = self.tokenSent;
    else
        cell.textLabel.text = self.tokenReceived;

    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation

 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

 */

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
        [self downloadFile:url];
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

@end
