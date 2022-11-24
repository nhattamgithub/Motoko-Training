import TrieMap "mo:base/TrieMap";
import Error "mo:base/Error";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
// import Source "./utils/uuid/async/SourceV4";
// import UUID "./utils/uuid/UUID";

import State "../training_test_models/State";
import Types "../training_test_models/Types";

actor {
  var state : State.State = State.empty();
  
  // User
  public shared(msg) func createUser(user: Types.User): async Result.Result<(), Types.Error> {
  let callerID = msg.caller;
  if (Principal.toText(callerID) == "2vxsx-fae"){
    return #err(#NotAuthorized);
  };
  // let g = Source.Source();
  // UUID.toText(await g.new());
  let readUser = state.users.get(callerID);
  switch (readUser) {
    case (? v){ 
    #err(#AlreadyExisting);
    };
    case null {
    let newUser : Types.User = {
      username = user.username;
      email = user.email;
      phone_number = user.phone_number;
      created_at : ?Int = Option.get(null, ?Time.now());
      updated_at : ?Int = Option.get(null, ?Time.now());
    };
    let createdUser = state.users.put(callerID, newUser);
    #ok(());
    };
  };
  };

  public shared(msg) func readUser() : async Result.Result<Types.User, Types.Error> {
  let callerID = msg.caller;

  if (Principal.toText(callerID) == "2vxsx-fae") {
    return #err(#NotAuthorized);
  };

  let result = state.users.get(callerID);
  return Result.fromOption(result, #NotFound);
  };


  // Post
  // ...
};
