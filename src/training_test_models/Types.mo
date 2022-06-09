module {
  public type User = {
    username : Text;
    email : Text;
    phone_number : Text;
    created_at : ?Int;
    updated_at : ?Int;
  };

  // public type Post = {
  //   ...
  // }

  public type Error = {
    #NotFound;
    #AlreadyExisting;
    #NotAuthorized;
  }
}