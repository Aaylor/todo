
type 'a get = unit -> 'a
type 'a release = 'a -> unit
type 'a resource = 'a get * 'a release

val with_resource : 'a resource -> ('a -> 'b) -> 'b
