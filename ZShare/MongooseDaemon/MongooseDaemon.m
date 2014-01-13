//
//  MongooseDaemon.m
//
//  Created by Rama McIntosh on 3/4/09.
//  Copyright Rama McIntosh 2009. All rights reserved.
//

//
// Copyright (c) 2009, Rama McIntosh All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of Rama McIntosh nor the names of its
//   contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//

// MongooseDaemon is a small wrapper to make ingetrating mongoose
// with iPhone apps super easy

#import "MongooseDaemon.h"
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#import "ZTokenManager.h"
#import "UIDevice+RExtension.h"

//#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define DOCUMENTS_FOLDER NSTemporaryDirectory()

@implementation MongooseDaemon

@synthesize ctx;

void token_callback(struct mg_connection *connection, const struct mg_request_info *info, void *user_data)
{
    NSString *uri = [NSString stringWithUTF8String:info->uri];
    NSString *token = [uri substringFromIndex:3];
    if ([ZTokenManager verifyToken:token]) {
        NSString *path = [ZTokenManager filePathForToken:token];
        mg_send_file(connection, path.UTF8String);
    }
}

- (void)startHTTP:(NSString *)ports
{
    self.ctx = mg_start();     // Start Mongoose serving thread
    mg_set_option(ctx, "root", [DOCUMENTS_FOLDER UTF8String]);  // Set document root
    mg_set_option(ctx, "ports", [ports UTF8String]);    // Listen on port XXXX

    //mg_bind_to_uri(ctx, "/foo", &bar, NULL); // Setup URI handler
    mg_set_uri_callback(ctx, "/t/*", token_callback, NULL);

    // Now Mongoose is up, running and configured.
    // Server until somebody terminates us
    NSLog(@"Mongoose Server is running on http://%@:%@", [[UIDevice currentDevice] localIPAddress], ports);
}

- (void)startMongooseDaemon:(NSString *)ports;
{
    [self startHTTP:ports];
}

- (void)stopMongooseDaemon
{
    if (self.ctx) {
        mg_stop(ctx);
        self.ctx = NULL;
    }
}

@end
