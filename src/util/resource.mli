(** Utility function to handle any resources *)

type 'a get = unit -> 'a
(** ['a get] is the type of a function which create the resource. *)

type 'a release = 'a -> unit
(** ['a release] is the type of a function which release the resource. *)

type 'a resource = 'a get * 'a release
(** ['a resource] contains both a create function and a release function. *)

val with_resource : 'a resource -> ('a -> 'b) -> 'b
(** [with_resource resource f] apply the function [f] with the created resource.
    It closes the resource before returning the value. If an exception occurs
    during the execution of the function [f], it closes the resources and
    raise the same exception. *)
