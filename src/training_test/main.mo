import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import State "../training_test_models/State";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/AssocList";
import TrieMap "mo:base/TrieMap";
import Type "../training_test_models/Types";
import Types "../training_test_models/Types";


actor {
  var state : State.State = State.empty();
  
  // User
  //Create user
  public shared(msg) func createUser(user: Types.User): async Result.Result<(), Types.Error> {
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae"){
      return #err(#NotAuthorized);
    };
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

  //Read user
  public shared(msg) func readUser() : async Result.Result<Types.User, Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.users.get(callerID);
    return Result.fromOption(result, #NotFound);
  };

  // Update user
  public shared(msg) func updateUser(user: Type.User) : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.users.get(callerID);

    switch (result) {
      case null {
        #err(#NotFound);
      };
      case(?value) {
        let updateUser : Types.User = {
        username = user.username;
        email = user.email;
        phone_number = user.phone_number;
        created_at : ?Int = Option.get(null, ?Time.now());
        updated_at : ?Int = Option.get(null, ?Time.now());
      };
        let result_update = state.users.replace(callerID, updateUser);
        #ok();
      };
    };
  };

  // Delete user
  public shared(msg) func deleteUser() : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.users.remove(callerID);

    switch (result) {
      case (null) {
        #err(#NotFound);
      };
      case (?value) {
        #ok();
      };
    };
  };

  // Post
  // Create post
  public shared(msg) func createPost(post: Type.Post) : async Result.Result<(),Type.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let readPost = state.posts.get(callerID);
    switch (readPost) {
      case (?value){
        #err(#AlreadyExisting);
      };
      case (nulll) {
        let newPost : Type.Post = {
          title = post.title;
          body = post.body;
          author = post.author;
          active = post.active;
          created_at : ?Int = Option.get(null, ?Time.now());
          updated_at : ?Int = Option.get(null, ?Time.now());
        };
        let createPost = state.posts.put(callerID, newPost);
        #ok();
      };
    };
  };

  //Read post
  public shared(msg) func readPost() : async Result.Result<Types.Post, Types.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.posts.get(callerID);
    return Result.fromOption(result, #NotFound);
  };

  // Update post
  public shared(msg) func updatePost(post: Types.Post) : async Result.Result<(), Types.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.posts.get(callerID);

    switch (result) {
      case null {
        #err(#NotFound);
      };
      case (?value) {
         let updatePost : Type.Post = {
          title = post.title;
          body = post.body;
          author = post.author;
          active = post.active;
          created_at : ?Int = Option.get(null, ?Time.now());
          updated_at : ?Int = Option.get(null, ?Time.now());
        };
        let result_update = state.posts.replace(callerID, updatePost);
        #ok();
      };
    };
  };

  //Delete post 
  public shared(msg) func deletePost() : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.posts.remove(callerID);

    switch (result) {
      case (null){
        #err(#NotFound);
      };
      case(?value){
        #ok();
      };
    }; 
  };

  //Active post
  //Dang hoat dong len active --> true
  public shared(msg) func active_post() : async Result.Result<(), Types.Error>{
    let callerID = msg.caller;

    let readPost = state.posts.get(callerID);

    switch (readPost) {
      case (null) {
        #err(#NotFound);
      };
      case (?value) {
        let check_active = value.active;

        if (check_active == true){
          #err( #AlreadyActivePost);
        }
        else {
          let updatePost : Type.Post = {
          title = value.title;
          body = value.body;
          author = value.author;
          active = true;
          created_at : ?Int = Option.get(null, ?Time.now());
          updated_at : ?Int = Option.get(null, ?Time.now());
          };
          let result_update = state.posts.replace(callerID, updatePost);
          #ok();
        };
      };
    };
  };

  //check active 
  //kiem tra bai dang co hoat dong
  public shared(msg) func check_active() : async Bool{
    let callerID = msg.caller;

    let readPost = state.posts.get(callerID);

    switch(readPost) {
      case (null) {
        return false;
      };
      case(?value){
        return value.active == true;
      };
    };
  };
};