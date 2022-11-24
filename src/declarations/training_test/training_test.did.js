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
  const Result_1 = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const Result = IDL.Variant({ 'ok' : User, 'err' : Error });
  return IDL.Service({
    'createUser' : IDL.Func([User], [Result_1], []),
    'readUser' : IDL.Func([], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
