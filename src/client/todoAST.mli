(** The AST of a todo file. *)

type todo = {
  id: int;                      (** Unique identifier of a task.  *)
  title: string;                (** The short title of a task.    *)
  creation_date: float;         (** The creation date of a task.  *)
  due_date: float option;       (** The due date of a task.       *)
  priority: int;                (** The task's priority. 0 is the lower
                                    priority *)
  description: string;          (** The task's description. *)
}
(** Every informations concerning the todo task. *)

val deserialize : string -> todo
(** [deserialize str] transforms the binary string [str] into a todo task. *)

val serialize : todo -> string
(** [serialize todo] serialize [todo] into a binary string. *)

val pp_short_todo : Format.formatter -> todo -> unit
(** [pp_short_todo fmt todo] display [todo] with important informations only. *)

val pp_todo : Format.formatter -> todo -> unit
(** [pp_todo fmt todo] displays all informations about [todo]. *)
