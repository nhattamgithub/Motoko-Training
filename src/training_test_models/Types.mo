<<<<<<< HEAD
import Principal "mo:base/Principal";

module {

    public type Bio = {
        username: ?Text;
        email: ?Text;
        phone_number: ?Text;
    };

    public type User = {
        bio: Bio;
        id: Principal;
        created_at: Int;
        update_at: Int;
    };

    public type Post = {
        title: ?Text;
        body: ?Text;
        author: User;
        active: ?Bool;
    };
=======
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
>>>>>>> f5c3da8b3bf0a019bca4f320dc5b613d83a87bce
}