
//
// Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import <Foundation/Foundation.h>
#import "BoxComment.h"

@interface BoxCommentsListModelXMLBuilder : NSObject <NSXMLParserDelegate> {
	NSMutableString *_contentHolder;
	NSMutableString *_status;

	NSMutableArray *_mainCommentList;
	NSMutableArray *_replyCommentList;
	BoxComment *_currentComment;
	NSMutableDictionary *_currentCommentAttributes;

	BOOL _inReplyComments;
	BoxCommentsListModelXMLBuilder *_replyCommentsBuilder;
}

@property (retain) NSMutableString *contentHolder;
@property (retain) NSMutableString *status;

@property (retain) NSMutableArray *mainCommentList;
@property (retain) NSMutableArray *replyCommentList;
@property (retain) BoxComment *currentComment;
@property (retain) NSMutableDictionary *currentCommentAttributes;

@property (assign) BOOL inReplyComments;
@property (retain) BoxCommentsListModelXMLBuilder *replyCommentsBuilder;

+ (NSArray *)commentsForURL:(NSURL *)url;
- (NSArray *)commentsForURL:(NSURL *)url;

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict;

@end
