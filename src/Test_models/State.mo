import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";

import Types "Types";

module {
  private type Map<K,V> = TrieMap.TrieMap<K,V>;
  public type State = {
    users : Map<Principal,Types.User>;
    posts : Map<Nat,Types.Post>;
    post_id_counter: Nat;
  };

  public func empty() : State {
    {
      users = TrieMap.TrieMap<Principal,Types.User>(Principal.equal, Principal.hash);
      posts = TrieMap.TrieMap<Nat,Types.Post>(Nat.equal,Hash.hash);
      post_id_counter = 1;
    }
  };

  public func increase_postCounter(S: State) : State {
    {
        users = S.users;
        posts = S.posts;
        post_id_counter = S.post_id_counter +1;
    }
  };
}