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
@property (nonatomic, retain) NSString *token;
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

    [[XQuquerService defaultService] start];
    [[XQuquerService defaultService] setDelegate:self];

    NSString *file = [[NSBundle mainBundle] pathForResource:@"bootstrap_cheatsheet"
                                                     ofType:@"pdf"];
    NSString *token = [ZTokenManager generateTokenForFile:file];
    [self sendToken:token];
    NSLog(@"%@", [ZTokenManager filePathForToken:token]);
    //[self uploadFile:file];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)sendToken:(NSString *)token
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
    NSLog(@"Final string: %@", ququerToken);
    if ([[XQuquerService defaultService] sendDataToken:ququerToken]) {
        NSLog(@"Success!");
    }
}

- (void)uploadFile:(NSString *)filePath
{

    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://box.myqsc.com/item/add_item"]];

    [request addRequestHeader:@"Referer"
                        value:@"http://box.myqsc.com/"];
    [request addRequestHeader:@"Cookie"
                        value:@"PHPSESSID=73ftnudvefphfn9tu4875gs6e3;"];

    [request addFile:filePath
        withFileName:filePath.lastPathComponent
      andContentType:@"application/octet-stream"
              forKey:@"file"];


    [request setCompletionBlock:^{
        NSError *error = nil;
        if (request.responseString.length > 8) {
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"<code>(.*)</code>"
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
            if (!error) {
                NSArray *results = [regular matchesInString:request.responseString
                                                    options:0
                                                      range:NSMakeRange(0, request.responseString.length)];
                if (results.count > 0) {
                    NSTextCheckingResult *result = [results objectAtIndex:0];
                    if (result.numberOfRanges > 0) {
                        NSRange range = [result rangeAtIndex:1];
                        NSString *code = [request.responseString substringWithRange:range];
                        NSLog(@"%@", code);
                        self.token = [@"00" stringByAppendingString:code];
                        [self sendToken:self.token];
                    }
                }
            }
        }

    }];
    [request setFailedBlock:^{

    }];
    [request startAsynchronous];
}

- (void)downloadFile:(NSURL *)fileURL
{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:fileURL];
    request.downloadDestinationPath = [NSString documentsPath];
    [request setCompletionBlock:^{
        NSError *error = nil;
        if (request.responseString.length > 8) {
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"<code>(.*)</code>"
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
            if (!error) {
                NSArray *results = [regular matchesInString:request.responseString
                                                    options:0
                                                      range:NSMakeRange(0, request.responseString.length)];
                if (results.count > 0) {
                    NSTextCheckingResult *result = [results objectAtIndex:0];
                    if (result.numberOfRanges > 0) {
                        NSRange range = [result rangeAtIndex:1];
                        NSString *code = [request.responseString substringWithRange:range];
                        NSLog(@"%@", code);
                        self.token = [@"00" stringByAppendingString:code];
                        [self sendToken:self.token];
                    }
                }
            }
        }

    }];
    [request setFailedBlock:^{

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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...

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
    NSLog(@"%@", dataToken);
    NSString *host = [ZTokenManager hostForToken:dataToken];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7777/t/%@", host, dataToken]];
    [self downloadFile:url];
}

- (void)didDownloadData:(NSString *)dataContent
              withError:(NSError *)error
{

}

- (void)didUploadData:(NSString *)dataToken
            withError:(NSError *)error
{
    NSLog(@"%@", dataToken);
    if ([[XQuquerService defaultService] sendDataToken:dataToken])
        NSLog(@"YES");
}

@end
