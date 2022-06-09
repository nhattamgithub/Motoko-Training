export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'AlreadyExisting' : IDL.Null,
    'AlreadyActivePost' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const User = IDL.Record({
    'updated_at' : IDL.Opt(IDL.Int),
    'username' : IDL.Text,
    'created_at' : IDL.Opt(IDL.Int),
    'email' : IDL.Text,
    'phone_number' : IDL.Text,
  });
  const Post = IDL.Record({
    'title' : IDL.Opt(IDL.Text),
    'updated_at' : IDL.Opt(IDL.Int),
    'active' : IDL.Bool,
    'body' : IDL.Opt(IDL.Text),
    'created_at' : IDL.Opt(IDL.Int),
    'author' : IDL.Opt(User),
  });
  const Result_2 = IDL.Variant({ 'ok' : Post, 'err' : Error });
  const Result_1 = IDL.Variant({ 'ok' : User, 'err' : Error });
  return IDL.Service({
    'active_post' : IDL.Func([], [Result], []),
    'check_active' : IDL.Func([], [IDL.Bool], []),
    'createPost' : IDL.Func([Post], [Result], []),
    'createUser' : IDL.Func([User], [Result], []),
    'deletePost' : IDL.Func([], [Result], []),
    'deleteUser' : IDL.Func([], [Result], []),
    'readPost' : IDL.Func([], [Result_2], []),
    'readUser' : IDL.Func([], [Result_1], []),
    'updatePost' : IDL.Func([Post], [Result], []),
    'updateUser' : IDL.Func([User], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
