import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Type "../training_test_models/Types";

actor {

  type User = Type.User;
  type Bio = Type.Bio;

  type UserUpdate = {
    bio: Bio;
    created_at: Int;
    update_at: Int;
  };

  type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized
  };

  stable var users : Trie.Trie<Principal, User> = Trie.empty();

  //Create user
  public shared(msg) func create(user: UserUpdate): async Result.Result<(), Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) ==  "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let new_user : User = {
      bio = user.bio;
      id = callerID;
      created_at = Time.now();
      update_at = Time.now();
    };

    let (newUser, existing) = Trie.put(
      users, 
      key(callerID),
      Principal.equal,
      new_user
    );

    switch (existing) {
      case null {
        users := newUser;
        #ok();
      };
      case(?value) {
        return #err(#AlreadyExists);
      };
    };
  };

  //Read user
  public shared(msg) func read() : async Result.Result<User, Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
        return #err(#NotAuthorized);
    };

    let result = Trie.find(users, key(callerID), Principal.equal);
    return Result.fromOption(result, #NotFound);
  };

  // Update user
  public shared(msg) func update(user: User) : async Result.Result<(), Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) ==  "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let update_user : User = {
      bio = user.bio;
      id = callerID;
      created_at =user.created_at;
      update_at = Time.now();
    };

    let result = Trie.find(users, key(callerID), Principal.equal);

    switch (result) {
      case null {
        #err(#NotFound);
      };
      case (?value) {
        users := Trie.replace(
          users,
          key(callerID),
          Principal.equal,
          ?update_user
        ).0;
        #ok();
      }
    }
  };

  //Delete user
  public shared(msg) func delete() : async Result.Result<(), Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) ==  "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let result = Trie.find(users, key(callerID), Principal.equal);

    switch (result) {
      case null {
        #err(#NotFound);
      };
      case(?value){
        users := Trie.replace(
          users,
          key(callerID),
          Principal.equal,
          null
        ).0;
        #ok();
      };
    };
  };

  private func key(x: Principal) : Trie.Key<Principal> {
    return {key = x; hash = Principal.hash(x)};
  }
}
