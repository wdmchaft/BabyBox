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


#import "BoxRESTApiFactory.h" 


@implementation BoxRESTApiFactory

static const NSString * BOX_API_KEY = @"7r4sye4yr5abf36m4km9i80vo9fdm2f4";

+ (NSString *)getAuthTokenUrlString:(NSString *)userName userPassword:(NSString *)userPassword {
	NSString *password = [BoxModelUtilityFunctions urlEncodeParameter:userPassword];
	NSString *user = [BoxModelUtilityFunctions urlEncodeParameter:userName];
	NSString *urlString =  [NSString stringWithFormat:
							@"https://www.box.net/api/1.0/rest?action=authorization&api_key=%@&login=%@&password=%@&method",
							BOX_API_KEY,
							user,
							password];

	return urlString;
}

+ (NSString *)getAccountTreeOneLevelUrlString:(NSString *)token boxFolderId:(NSString *)folderID {
	NSString *urlString = [NSString stringWithFormat:
						   @"https://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=has_collaborators&params[]=checksum",
						   BOX_API_KEY,
						   token,
						   folderID];

	return urlString;
}

+ (NSString *)getAccountTreeOneLevelUrlStringFoldersOnly:(NSString *)token boxFolderId:(NSString *)folderID {
	NSString *urlString = [NSString stringWithFormat:
						   @"https://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=has_collaborators&params[]=checksum&params[]=nofiles",
						   BOX_API_KEY,
						   token,
						   folderID];

	return urlString;
}

+ (NSString *)getLogoutUrlString:(NSString *)boxAuthToken {
	NSString *urlString = [NSString stringWithFormat: 
						   @"https://www.box.net/api/1.0/rest?action=logout&api_key=%@&auth_token=%@",
						   BOX_API_KEY,
						   boxAuthToken];

	return urlString;
}

+ (NSString *)getUploadUrlString:(NSString *)boxAuthToken boxFolderID:(NSString *)boxFolderID {
	NSString *urlString = [NSString stringWithFormat:
						   @"https://upload.box.net/api/1.0/upload/%@/%@",
						   boxAuthToken,
						   boxFolderID];

	return urlString;
}

+ (NSString *)getDownloadUrlString:(NSString *)boxAuthToken
						 boxFileID:(int)boxFileID
{
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/download/%@/%d",
			boxAuthToken,
			boxFileID];
}

+ (NSString *)getFolderFileShareUrlString:(NSString *)boxToken
								 boxTarget:(NSString *)target
							   boxTargetId:(NSString *)targetId
						 boxSharePassword:(NSString *)sharePassword
								boxMessage:(NSString *)shareMessage
								boxEmails:(NSArray *)shareEmails
{
	if (shareMessage == nil) {
		shareMessage = @"";
	}

	NSString *encodedString = [BoxModelUtilityFunctions urlEncodeParameter:shareMessage];
	NSString *urlString =  [NSString stringWithFormat:
							@"https://www.box.net/api/1.0/rest?action=public_share&api_key=%@&auth_token=%@&target=%@&target_id=%@&password=%@&message=%@",
							BOX_API_KEY,
							boxToken,
							target,
							targetId,
							sharePassword,
							encodedString];

	if (shareEmails) {
		for (NSString *str in shareEmails) {
			urlString = [urlString stringByAppendingFormat:
						 @"&emails[]=%@",
						 [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		}
	}

	return urlString;
}

+ (NSString *)getBoxRegisterNewAccountUrlString:(NSString *)boxLoginName boxPassword:(NSString *)password {
	NSString *pword = [BoxModelUtilityFunctions urlEncodeParameter:password];
	NSString *user = [BoxModelUtilityFunctions urlEncodeParameter:boxLoginName];
	NSString *urlString =  [NSString stringWithFormat:
							@"https://www.box.net/api/1.0/rest?action=register_new_user&api_key=%@&login=%@&password=%@",
							BOX_API_KEY,
							user,
							pword];

	return urlString;
}

+ (NSString *)getTicketUrlString {
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=get_ticket&api_key=%@",
			BOX_API_KEY];
}

+ (NSString *)authenticationUrlStringForTicket:(NSString *)ticket {
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/auth/%@",
			ticket];
}

+ (NSString *)getAuthTokenUrlStringForTicket:(NSString *)ticket {
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=get_auth_token&api_key=%@&ticket=%@",
			BOX_API_KEY,
			ticket];
}

+ (NSString *)moveURLStringForAuthToken:(NSString *)authToken
							 targetType:(NSString *)targetType
							   targetID:(int)targetID
						  destinationID:(int)destinationID
{
	return [NSString stringWithFormat:
			@"%@/rest?action=move&api_key=%@&auth_token=%@&target=%@&target_id=%d&destination_id=%d",
			@"https://www.box.net/api/1.0",
			BOX_API_KEY,
			authToken,
			targetType,
			targetID,
			destinationID];
}

+ (NSString *)copyUrlStringForAuthToken:(NSString *)authToken
							 targetType:(NSString *)targetType
							   targetId:(int)targetId
						  destinationId:(int)destinationId
{
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=copy&api_key=%@&auth_token=%@&target=%@&target_id=%d&destination_id=%d",
			BOX_API_KEY,
			authToken,
			targetType,
			targetId,
			destinationId];
}

+ (NSString *)deleteUrlStringForAuthToken:(NSString *)authToken
							   targetType:(NSString *)targetType
								 targetId:(int)targetId
{
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=delete&api_key=%@&auth_token=%@&target=%@&target_id=%d",
			BOX_API_KEY,
			authToken,
			targetType,
			targetId];
}

+ (NSString *)getCommentsURLStringForAuthToken:(NSString *)authToken
									targetType:(NSString *)targetType
									  targetID:(int)targetID
{
	return [NSString stringWithFormat:
			@"%@/rest?action=get_comments&api_key=%@&auth_token=%@&target=%@&target_id=%d",
			@"https://www.box.net/api/1.0",
			BOX_API_KEY,
			authToken,
			targetType,
			targetID];
}

+ (NSString *)addCommentsURLStringForAuthToken:(NSString *)authToken
									targetType:(NSString *)targetType
									  targetID:(int)targetID
									   message:(NSString *)message
{
	return [NSString stringWithFormat:
			@"%@/rest?action=add_comment&api_key=%@&auth_token=%@&target=%@&target_id=%d&message=%@",
			@"https://www.box.net/api/1.0",
			BOX_API_KEY,
			authToken,
			targetType,
			targetID,
			[BoxModelUtilityFunctions urlEncodeParameter:message]];
}

+ (NSString *)deleteCommentURLStringForAuthToken:(NSString *)authToken
									   commentID:(int)commentID
{
	return [NSString stringWithFormat:
			@"%@/rest?action=delete_comment&api_key=%@&auth_token=%@&target_id=%d",
			@"https://www.box.net/api/1.0",
			BOX_API_KEY,
			authToken,
			commentID];
}

+ (NSString *)publicShareURLStringForAuthToken:(NSString *)authToken
									  targetID:(int)targetID
									targetType:(NSString *)targetType
									  password:(NSString *)password
									   message:(NSString *)message
										emails:(NSArray *)emails
{
	password = password ? [BoxModelUtilityFunctions urlEncodeParameter:password] : @"";
	message = message ? [BoxModelUtilityFunctions urlEncodeParameter:message] : @"";
	emails = emails ? emails : [NSArray array];

	NSString *url = [NSString stringWithFormat:
					 @"%@/rest?action=public_share&api_key=%@&auth_token=%@&target=%@&target_id=%d&password=%@&message=%@",
					 @"https://www.box.net/api/1.0",
					 BOX_API_KEY,
					 authToken,
					 targetType,
					 targetID,
					 password,
					 message];

	for (NSString *email in emails) {
		url = [url stringByAppendingFormat:
			   @"&emails[]=%@",
			   [email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	}

	return url;
}

+ (NSString *)publicUnshareURLStringForAuthToken:(NSString *)authToken
										targetID:(int)targetID
									  targetType:(NSString *)targetType
{
	return [NSString stringWithFormat:
			@"%@/rest?action=public_unshare&api_key=%@&auth_token=%@&target=%@&target_id=%d",
			@"https://www.box.net/api/1.0",
			BOX_API_KEY,
			authToken,
			targetType,
			targetID];	
}

+ (NSString *)privateShareURLStringForAuthToken:(NSString *)authToken
									   targetID:(int)targetID
									 targetType:(NSString *)targetType
										message:(NSString *)message
										 emails:(NSArray *)emails
										 notify:(BOOL)notify
{
	NSString *url;

	message = message ? [BoxModelUtilityFunctions urlEncodeParameter:message] : @"";
	emails = emails ? emails : [NSArray array];

	url = [NSString stringWithFormat:
		   @"%@/rest?action=private_share&api_key=%@&auth_token=%@&target=%@&target_id=%d&message=%@&notify=%@",
		   @"https://www.box.net/api/1.0",
		   BOX_API_KEY,
		   authToken,
		   targetType,
		   targetID,
		   message,
		   (notify ? @"true" : @"false")];

	for (NSString *email in emails) {
		url = [url stringByAppendingFormat:
			   @"&emails[]=%@",
			   [email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	}

	return url;
}

+ (NSString *)updatesURLStringSince:(NSDate *)date authToken:(NSString *)authToken {
	NSString *beginTimeStampString = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
	NSString *endTimeStampString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];

	return [NSString stringWithFormat:
			@"%@/rest?action=get_updates&api_key=%@&auth_token=%@&begin_timestamp=%@&end_timestamp=%@&params[]=nozip&params[]=use_attributes&params[]=comment_count&params[]=web_links",
			@"https://www.box.net/api/1.0",
			BOX_API_KEY,
			authToken,
			beginTimeStampString,
			endTimeStampString];
}


+ (NSString *)registerUrlStringForLogin:(NSString *)login password:(NSString *)password {
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=register_new_user&api_key=%@&login=%@&password=%@",
			BOX_API_KEY,
			login,
			password];
}

+ (NSString *)createFolderUrlStringForAuthToken:(NSString *)authToken
									   parentId:(int)parentID
										   name:(NSString *)name
										  share:(BOOL)share
{
	NSString *encodedName = [BoxModelUtilityFunctions urlEncodeParameter:name];
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=create_folder&api_key=%@&auth_token=%@&parent_id=%d&name=%@&share=%d",
			BOX_API_KEY,
			authToken,
			parentID,
			encodedName,
			share];
}

+ (NSString *)renameUrlStringForAuthToken:(NSString *)authToken
							   targetType:(NSString *)targetType
								 targetID:(int)targetID
								  newName:(NSString *)newName
{
	NSString *encodedName = [BoxModelUtilityFunctions urlEncodeParameter:newName];
	return [NSString stringWithFormat:
			@"https://www.box.net/api/1.0/rest?action=rename&api_key=%@&auth_token=%@&target=%@&target_id=%d&new_name=%@",
			BOX_API_KEY,
			authToken,
			targetType,
			targetID,
			encodedName];
}

+ (NSString *)getUserInfo:(NSString *)authToken
{
    NSString *urlString = [NSString stringWithFormat:
						   @"https://www.box.net/api/1.0/rest?action=get_account_info&api_key=%@&auth_token=%@",
						   BOX_API_KEY,
						   authToken];
    
	return urlString;
}
@end
