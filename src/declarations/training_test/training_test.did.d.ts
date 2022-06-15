import type { Principal } from '@dfinity/principal';
export type Error = { 'AlreadyExisting' : null } |
  { 'UsernameNotSpace' : null } |
  { 'PhoneNumberAlreadyExisting' : null } |
  { 'IdNotVailid' : null } |
  { 'AlreadyActivePost' : null } |
  { 'NotFound' : null } |
  { 'EmailAlreadyExisting' : null } |
  { 'NotAuthorized' : null } |
  { 'PostNotFound' : null } |
  { 'UserNotFound' : null };
export interface Post {
  'title' : [] | [string],
  'updated_at' : [] | [bigint],
  'active' : boolean,
  'body' : [] | [string],
  'created_at' : [] | [bigint],
  'author' : string,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : User } |
  { 'err' : Error };
export type Result_2 = { 'ok' : Post } |
  { 'err' : Error };
export type Result_3 = { 'ok' : Array<User> } |
  { 'err' : Error };
export type Result_4 = { 'ok' : Array<Post> } |
  { 'err' : Error };
export type Result_5 = { 'ok' : boolean } |
  { 'err' : Error };
export interface User {
  'updated_at' : [] | [bigint],
  'username' : string,
  'created_at' : [] | [bigint],
  'email' : [] | [string],
  'phone_number' : [] | [string],
}
export interface _SERVICE {
  'activePost' : (arg_0: bigint) => Promise<Result>,
  'checkActivePost' : (arg_0: bigint) => Promise<Result_5>,
  'createPost' : (arg_0: Post) => Promise<Result>,
  'createUser' : (arg_0: User) => Promise<Result>,
  'deletePost' : (arg_0: bigint) => Promise<Result>,
  'deleteUser' : (arg_0: string) => Promise<Result>,
  'listPost' : () => Promise<Result_4>,
  'listUser' : () => Promise<Result_3>,
  'readPost' : (arg_0: bigint) => Promise<Result_2>,
  'readUser' : (arg_0: string) => Promise<Result_1>,
  'updatePost' : (arg_0: bigint, arg_1: Post) => Promise<Result>,
  'updateUser' : (arg_0: string, arg_1: User) => Promise<Result>,
}
