-module(dropbox).
-export([
    request_token/2, authorize/5, access_token/4, 
    account_info/4,
    file_get/6,
    file_put/8,
    file_delete/6,
    metadata/6
  ]).

-spec(request_token(string(), string()) -> [{string(), string()}]).
request_token(Key, Secret) -> 
  {ok, RequestToken} = oauth:post("https://api.dropbox.com/1/oauth/request_token", [], {Key, Secret, hmac_sha1}),
  oauth:params_decode(RequestToken).

authorize(Key, Secret, Token, TokenSecret, Callback) ->
  {ok, Authorize} = oauth:get("https://www.dropbox.com/1/oauth/authorize", [{"oauth_callback", Callback}], {Key, Secret, hmac_sha1}, Token, TokenSecret),
  oauth:params_decode(Authorize).

access_token(Key, Secret, Token, TokenSecret) ->
  {ok, AccessToken} = oauth:post("https://api.dropbox.com/1/oauth/access_token", [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
  oauth:params_decode(AccessToken).

account_info(Key, Secret, Token, TokenSecret) ->
  {ok, {_, _, AccountInfo}} = oauth:get("https://api.dropbox.com/1/account/info", [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
  AccountInfo.

%%
%% Files and metadata
%%

file_get(Key, Secret, Token, TokenSecret, Root, Path) ->
  {ok, {_, _, File}} = oauth:get("https://api-content.dropbox.com/1/files/" ++ Root ++ "/" ++ Path, [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
  File.

file_put(Key, Secret, Token, TokenSecret, Root, Path, ContentType, FileContent) ->
    {ok, {_, _, Metadata}} = oauth:put("https://api-content.dropbox.com/1/files_put/" ++ Root ++ "/" ++ Path, [], {ContentType, FileContent},  {Key, Secret, hmac_sha1}, Token, TokenSecret),
    Metadata.

file_delete(Key, Secret, Token, TokenSecret, Root, Path) ->
    {ok, {_, _, Metadata}} = oauth:post("https://api.dropbox.com/1/fileops/delete", [{"root", Root}, {"path", Path}], {Key, Secret, hmac_sha1}, Token, TokenSecret),
    Metadata.



metadata(Key, Secret, Token, TokenSecret, Root, Path) ->
  {ok, {_, _, Metadata}} = oauth:get("https://api.dropbox.com/1/metadata/" ++ Root ++ "/" ++ Path, [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
  Metadata.
