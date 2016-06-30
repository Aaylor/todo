
exception ParseFailure of string
exception ExecutionFailure of string

module type Command = sig
  type t
  val pprint : Format.formatter -> t -> unit
  val parse : string array -> t
  val execute : t -> unit
end

module CommandTable : sig
  val register_command : string -> (module Command) -> unit
  val lookup_command : string -> (module Command) option
end

module ListCommand : Command

module AddCommand : Command

module DoneCommand : Command
