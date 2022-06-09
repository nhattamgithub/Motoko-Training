import type { Principal } from '@dfinity/principal';
export type Error = { 'AlreadyExisting' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null };
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : User } |
  { 'err' : Error };
export interface User {
  'updated_at' : [] | [bigint],
  'username' : string,
  'created_at' : [] | [bigint],
  'email' : string,
  'phone_number' : string,
}
export interface _SERVICE {
  'createUser' : (arg_0: User) => Promise<Result>,
  'deleteUser' : () => Promise<Result>,
  'readUser' : () => Promise<Result_1>,
  'updateUser' : (arg_0: User) => Promise<Result>,
}
