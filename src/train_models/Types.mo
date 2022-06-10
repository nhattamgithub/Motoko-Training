module {
    public type Bio = {
        username : ?Text;
        email : ?Text;
        phone_number : ?Text;
    };

    public type User = {
        bio : Bio;
        created_at : Int;
        updated_at : ?Int;
    };    

    public type Error = {
        #UserAlreadyExists;
        #NotAuthorized;
        #UserNotFound;
        #PostNotFound;
        #PostAlreadyExists;
    };

    public type PostInfo = {
        title : ?Text;
        body : Text;
    };

    public type Post = {
        author : Principal;
        active : Bool;
        post_info : PostInfo;        
        created_at : Int;
        updated_at : Int;
    };
}