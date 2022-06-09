import type { Principal } from '@dfinity/principal';
export type Error = { 'AlreadyExisting' : null } |
  { 'AlreadyActivePost' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null };
export interface Post {
  'title' : [] | [string],
  'updated_at' : [] | [bigint],
  'active' : boolean,
  'body' : [] | [string],
  'created_at' : [] | [bigint],
  'author' : [] | [User],
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : User } |
  { 'err' : Error };
export type Result_2 = { 'ok' : Post } |
  { 'err' : Error };
export interface User {
  'updated_at' : [] | [bigint],
  'username' : string,
  'created_at' : [] | [bigint],
  'email' : string,
  'phone_number' : string,
}
export interface _SERVICE {
  'active_post' : () => Promise<Result>,
  'check_active' : () => Promise<boolean>,
  'createPost' : (arg_0: Post) => Promise<Result>,
  'createUser' : (arg_0: User) => Promise<Result>,
  'deletePost' : () => Promise<Result>,
  'deleteUser' : () => Promise<Result>,
  'readPost' : () => Promise<Result_2>,
  'readUser' : () => Promise<Result_1>,
  'updatePost' : (arg_0: Post) => Promise<Result>,
  'updateUser' : (arg_0: User) => Promise<Result>,
}
