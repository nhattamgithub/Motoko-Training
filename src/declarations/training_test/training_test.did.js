export const idlFactory = ({ IDL }) => {
  const User = IDL.Record({
    'updated_at' : IDL.Opt(IDL.Int),
    'username' : IDL.Text,
    'created_at' : IDL.Opt(IDL.Int),
    'email' : IDL.Text,
    'phone_number' : IDL.Text,
  });
  const Error = IDL.Variant({
    'AlreadyExisting' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const Result_1 = IDL.Variant({ 'ok' : User, 'err' : Error });
  return IDL.Service({
    'createUser' : IDL.Func([User], [Result], []),
    'deleteUser' : IDL.Func([], [Result], []),
    'readUser' : IDL.Func([], [Result_1], []),
    'updateUser' : IDL.Func([User], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
