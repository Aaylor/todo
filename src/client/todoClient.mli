(** Contains all available commands for the binary. *)

val add : title:string option -> due_date:string option ->
  priority:int option -> description:string -> unit
(** [add ~title ~due_date ~priority ~description ()] creates a
    new todo task according to all parameters and add it to the
    task list. *)

val done_ : int list -> unit
(** [done_ l] renders all taks ids in [l] from todo to done. *)

type list_kind =
  | Todo                        (** Show the todo list. *)
  | Done                        (** Show the done list. *)
(** The kind of elements to show. *)

val list : list_kind -> unit
(** [list kind] show elements into the category given by [kind]. *)

val show : int -> unit
(** [show id] show the task with given [id]. An error occurs if the
    task doesn't exists. *)
