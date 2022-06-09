import Types "Types";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";

module {
  private type Map<K,V> = TrieMap.TrieMap<K,V>;
  public type State = {
    users : Map<Principal,Types.User>;
    posts: Map<Principal, Types.Post>;
  };

  public func empty() : State {
    {
      users = TrieMap.TrieMap<Principal,Types.User>(Principal.equal, Principal.hash);
      posts = TrieMap.TrieMap<Principal,Types.Post>(Principal.equal, Principal.hash);
    }
  };
}