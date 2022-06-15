export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'AlreadyExisting' : IDL.Null,
    'UsernameNotSpace' : IDL.Null,
    'PhoneNumberAlreadyExisting' : IDL.Null,
    'IdNotVailid' : IDL.Null,
    'AlreadyActivePost' : IDL.Null,
    'NotFound' : IDL.Null,
    'EmailAlreadyExisting' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'PostNotFound' : IDL.Null,
    'UserNotFound' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const Result_5 = IDL.Variant({ 'ok' : IDL.Bool, 'err' : Error });
  const Post = IDL.Record({
    'title' : IDL.Opt(IDL.Text),
    'updated_at' : IDL.Opt(IDL.Int),
    'active' : IDL.Bool,
    'body' : IDL.Opt(IDL.Text),
    'created_at' : IDL.Opt(IDL.Int),
    'author' : IDL.Text,
  });
  const User = IDL.Record({
    'updated_at' : IDL.Opt(IDL.Int),
    'username' : IDL.Text,
    'created_at' : IDL.Opt(IDL.Int),
    'email' : IDL.Opt(IDL.Text),
    'phone_number' : IDL.Opt(IDL.Text),
  });
  const Result_4 = IDL.Variant({ 'ok' : IDL.Vec(Post), 'err' : Error });
  const Result_3 = IDL.Variant({ 'ok' : IDL.Vec(User), 'err' : Error });
  const Result_2 = IDL.Variant({ 'ok' : Post, 'err' : Error });
  const Result_1 = IDL.Variant({ 'ok' : User, 'err' : Error });
  return IDL.Service({
    'activePost' : IDL.Func([IDL.Nat], [Result], []),
    'checkActivePost' : IDL.Func([IDL.Nat], [Result_5], []),
    'createPost' : IDL.Func([Post], [Result], []),
    'createUser' : IDL.Func([User], [Result], []),
    'deletePost' : IDL.Func([IDL.Nat], [Result], []),
    'deleteUser' : IDL.Func([IDL.Text], [Result], []),
    'listPost' : IDL.Func([], [Result_4], []),
    'listUser' : IDL.Func([], [Result_3], []),
    'readPost' : IDL.Func([IDL.Nat], [Result_2], []),
    'readUser' : IDL.Func([IDL.Text], [Result_1], []),
    'updatePost' : IDL.Func([IDL.Nat, Post], [Result], []),
    'updateUser' : IDL.Func([IDL.Text, User], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
