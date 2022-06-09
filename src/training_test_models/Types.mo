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
}