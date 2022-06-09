import type { Principal } from '@dfinity/principal';
export type Error = { 'AlreadyExisting' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null };
export type Result = { 'ok' : null } |
  { 'err' : Error };
export interface User {
  'updated_at' : [] | [bigint],
  'username' : string,
  'created_at' : [] | [bigint],
  'email' : string,
  'phone_number' : string,
}
export interface _SERVICE { 'createUser' : (arg_0: User) => Promise<Result> }
