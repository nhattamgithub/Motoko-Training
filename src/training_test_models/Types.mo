module {
  public type User = {
    username : Text;
    email : Text;
    phone_number : Text;
    created_at : ?Int;
    updated_at : ?Int;
  };

  public type Post = {
    title : ?Text;
    body : ?Text;
    author : ?User;
    active : Bool;
    created_at : ?Int;
    updated_at : ?Int;
  };

  public type Error = {
    #NotFound;
    #AlreadyExisting;
    #NotAuthorized;
    #AlreadyActivePost;
  }
}