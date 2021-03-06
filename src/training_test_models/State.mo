import Types "Types";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";

module {
  private type Map<K,V> = TrieMap.TrieMap<K,V>;
  public type State = {
    users : Map<Principal,Types.User>;
  };

  public func empty() : State {
    {
      users = TrieMap.TrieMap<Principal,Types.User>(Principal.equal, Principal.hash);
    }
  };
}