export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'PostAlreadyExists' : IDL.Null,
    'UserAlreadyExists' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'PostNotFound' : IDL.Null,
    'UserNotFound' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const Result_3 = IDL.Variant({ 'ok' : IDL.Bool, 'err' : Error });
  const PostInfo = IDL.Record({
    'title' : IDL.Opt(IDL.Text),
    'body' : IDL.Text,
  });
  const Bio = IDL.Record({
    'username' : IDL.Opt(IDL.Text),
    'email' : IDL.Opt(IDL.Text),
    'phone_number' : IDL.Opt(IDL.Text),
  });
  const PostInfo__1 = IDL.Record({
    'title' : IDL.Opt(IDL.Text),
    'body' : IDL.Text,
  });
  const Post = IDL.Record({
    'updated_at' : IDL.Int,
    'active' : IDL.Bool,
    'post_info' : PostInfo__1,
    'created_at' : IDL.Int,
    'author' : IDL.Principal,
  });
  const Bio__1 = IDL.Record({
    'username' : IDL.Opt(IDL.Text),
    'email' : IDL.Opt(IDL.Text),
    'phone_number' : IDL.Opt(IDL.Text),
  });
  const User = IDL.Record({
    'bio' : Bio__1,
    'updated_at' : IDL.Opt(IDL.Int),
    'created_at' : IDL.Int,
  });
  const Result_2 = IDL.Variant({ 'ok' : Post, 'err' : Error });
  const Result_1 = IDL.Variant({ 'ok' : User, 'err' : Error });
  return IDL.Service({
    'activePost' : IDL.Func([IDL.Nat], [Result], []),
    'checkActivePost' : IDL.Func([IDL.Nat], [Result_3], []),
    'createPost' : IDL.Func([PostInfo], [Result], []),
    'createUser' : IDL.Func([Bio], [Result], []),
    'deletePost' : IDL.Func([IDL.Nat], [Result], []),
    'deleteUser' : IDL.Func([], [Result], []),
    'listPost' : IDL.Func([], [IDL.Vec(Post)], []),
    'listUsers' : IDL.Func([], [IDL.Vec(User)], []),
    'readPost' : IDL.Func([IDL.Nat], [Result_2], []),
    'readUser' : IDL.Func([], [Result_1], []),
    'updatePost' : IDL.Func([IDL.Nat, PostInfo], [Result], []),
    'updateUser' : IDL.Func([Bio], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
